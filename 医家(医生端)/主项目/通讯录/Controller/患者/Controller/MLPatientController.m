//
//  MLPatientController.m
//  医家(医生端)
//
//  Created by 洛耳 on 15/7/16.
//  Copyright (c) 2015年 workorz. All rights reserved.
//  全部Table Tag = 0;
//  轻微table tag = 1;
//  严重table tag = 2;

#import "MLPatientController.h"
#import "MLSlidingAroundView.h"
#import "IWHttpTool.h"
#import "MLInterface.h"
#import "MJExtension.h"
#import "MLUserInfo.h"
#import "MBProgressHUD+MJ.h"
#import "MLDizhiModel.h"
#import "NSHuangzheShujuModel.h"
#import "MJRefresh.h"
#import "MLHuangzheCell.h"
#import "HuanzheLiebiao.h"
#import "MLCoreDataTool.h"
#import "MLBingshiController.h"

@interface MLPatientController ()<UITableViewDataSource,UITableViewDelegate>{
    //数据库文件
    NSManagedObjectContext *_context;
}
@property (nonatomic ,weak)UIView *quanbuView;
@property (nonatomic ,weak)UIView *qingweiView;
@property (nonatomic ,weak)UIView *yanzhongView;
@property (nonatomic ,strong)NSArray *array;
@property (nonatomic ,strong)NSMutableArray *qinweiArray;
@property (nonatomic ,strong)NSMutableArray *yanzhongArray;
@property (nonatomic ,weak)UIView *yingchang;
/**
 *  全部Table
 */
@property (nonatomic ,weak)UITableView *quanbuTable;
/**
 *  轻微Table
 */
@property (nonatomic ,weak)UITableView *qinweiTable;
/**
 *  严重Table
 */
@property (nonatomic ,weak)UITableView *yanzhongTable;
@end

@implementation MLPatientController
-(NSArray *)array{
    if (_array == nil) {
        _array = [NSArray array];
        return _array;
    }
    return _array;
}
-(NSMutableArray *)qinweiArray{
    if (_qinweiArray == nil) {
        _qinweiArray = [NSMutableArray array];
        return _qinweiArray;
    }
    return _qinweiArray;
}
-(NSMutableArray *)yanzhongArray{
    if (_yanzhongArray == nil) {
        _yanzhongArray = [NSMutableArray array];
        return _yanzhongArray;
    }
    return _yanzhongArray;
}
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    //隐藏黑线,在界面退出时消除
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 63, [UIScreen mainScreen].bounds.size.width, 2)];
    view.backgroundColor = [UIColor whiteColor];
    self.yingchang = view;
    [self.navigationController.view addSubview:view];
    [self.navigationController.view bringSubviewToFront:view];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    //标题
    self.title = @"患者";
    //初始化
    [self chushihua];
    // 马上进入刷新状态
    [self.quanbuTable.header beginRefreshing];
    //子线程中数据库操作
    dispatch_group_t group = dispatch_group_create();
    dispatch_group_async(group, dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [self shujuku];
        //回到主线程刷新UI
        dispatch_group_notify(group, dispatch_get_main_queue(), ^{
            for (NSHuangzheShujuModel *huangzhe in self.array) {
                [self.qinweiArray removeAllObjects];
                [self.yanzhongArray removeAllObjects];
                if ([huangzhe.condition isEqualToString:@"120"]) {//轻微
                    [self.qinweiArray addObject:huangzhe];
                }else if ([huangzhe.condition isEqualToString:@"121"]) {//严重
                    [self.yanzhongArray addObject:huangzhe];
                }
            }
            [self.quanbuTable reloadData];
            [self.qinweiTable reloadData];
            [self.yanzhongTable reloadData];
        });
    });
    //不透明
    self.navigationController.navigationBar.translucent = NO;
}
#pragma mark - 数据库操作
-(void)shujuku{
    //取出数据库数据
    [[MLUserInfo sharedMLUserInfo] loadUserInfoFromSanbox];
    NSString *name =  [NSString stringWithFormat:@"%@MLForumCoreData.sqlite",[MLUserInfo sharedMLUserInfo].user];
    _context = [MLCoreDataTool chuanjianCoreData:name];
    //查询数据
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"HuanzheLiebiao"];
    NSArray* items = [_context executeFetchRequest:request error:nil];
    if (items.count > 0 ) {
        //取出数据库的模型数组
        self.array = [self coreDataArray:items];
    }
}
#pragma mark - 数据库转模型数组
-(NSMutableArray *)coreDataArray:(NSArray *)array{
    NSMutableArray *neirongArray = [NSMutableArray array];
    for (HuanzheLiebiao *fe in array) {
        NSHuangzheShujuModel *neirong = [[NSHuangzheShujuModel alloc] init];
        neirong.headImage = fe.headImage ;
        neirong.nickname = fe.nickname;
        neirong.ID = fe.iD;
        neirong.age = fe.age;
        neirong.token = fe.token;
        neirong.booldSugarMax = fe.booldSugarMax;
        neirong.booldSugarMin = fe.booldSugarMin;
        neirong.sex = fe.sex;
        neirong.condition = fe.condition;
        [neirongArray addObject:neirong];
    }
    return neirongArray;
}
#pragma mark - 保存到数据库
-(void)baochunshujuku{
    //查询数据
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"HuanzheLiebiao"];
    NSArray *emps = [_context executeFetchRequest:request error:nil];
    if (emps.count > 0) {
        //删除数据
        for (HuanzheLiebiao *fe in emps) {
            [_context deleteObject:fe];
        }
        // 3.保存
        [_context save:nil];
        [self tianjiashuju];
    }else{
        //添加数据
        [self tianjiashuju];
    }
}
#pragma mark - 添加数据到数据库
-(void)tianjiashuju{
    //添加数据
    for (int i = 0; i < self.array.count; i++) {
        NSHuangzheShujuModel *neirong = self.array[i];
        [self neirongModel:neirong];
    }
}
#pragma mark - 模型数组转数据库
-(HuanzheLiebiao *)neirongModel:(NSHuangzheShujuModel *)neirong{
    HuanzheLiebiao *fe = [NSEntityDescription insertNewObjectForEntityForName:@"HuanzheLiebiao" inManagedObjectContext:_context];
    fe.userName = neirong.userName ;
    fe.typeId = neirong.typeId;
    fe.token = neirong.token;
    fe.tel = neirong.tel;
    fe.statusId = neirong.statusId;
    fe.speciality = neirong.speciality;
    fe.sex = neirong.sex;
    fe.regionId = neirong.regionId;
    fe.qrCodeId = neirong.qrCodeId;
    fe.qrCode = neirong.qrCode;
    fe.photoId = neirong.photoId;
    fe.patientDetail = neirong.patientDetail;
    fe.password = neirong.password;
    fe.openid = neirong.openid;
    fe.noteName = neirong.noteName;
    fe.nickname = neirong.nickname;
    fe.mobile = neirong.mobile;
    fe.level = neirong.level;
    fe.lastContactTime = neirong.lastContactTime;
    fe.lastContactContent = neirong.lastContactContent;
    fe.isBind = neirong.isBind;
    fe.isAudit = neirong.isAudit;
    fe.inviteCode = neirong.inviteCode;
    fe.intro = neirong.intro;
    fe.idCardNo = neirong.idCardNo;
    fe.iD = neirong.ID;
    fe.headImage = neirong.headImage;
    fe.email = neirong.email;
    fe.doctorDetail = neirong.doctorDetail;
    fe.disabled = neirong.disabled;
    fe.departmentsName = neirong.departmentsName;
    fe.createTime = neirong.createTime;
    fe.condition = neirong.condition;
    fe.booldSugarMin = neirong.booldSugarMin;
    fe.booldSugarMax = neirong.booldSugarMax;
    fe.birthday = neirong.birthday;
    fe.age = neirong.age;
    fe.address = neirong.address;
    fe.account = neirong.account;
    // 直接保存数据库
    NSError *error = nil;
    [_context save:&error];
    if (error) {
        NSLog(@"%@",error);
    }
    return fe;
}

#pragma mark - 初始化
-(void)chushihua{
    //创建支付宝和银行卡界面
    MLSlidingAroundView *sa = [[MLSlidingAroundView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, self.view.frame.size.height)];
    NSArray *array = @[@"全部",@"轻微",@"严重"];
    sa.backgroundColor = [UIColor colorWithRed:239/255.0 green:239/255.0 blue:239/255.0 alpha:1];
    [sa slidingAroundBtnNumber:array];
    [self.view addSubview:sa];
    self.quanbuView = sa.views[0];
    self.qingweiView = sa.views[1];
    self.yanzhongView = sa.views[2];
    //全部table
    UITableView *quanbuTable = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, self.view.frame.size.height - 64 + 64)];
    quanbuTable.tag = 0;
    quanbuTable.dataSource = self;
    quanbuTable.delegate = self;//去除下滑线
    quanbuTable.separatorStyle = UITableViewCellSeparatorStyleNone;
    quanbuTable.backgroundColor = [UIColor colorWithRed:239/255.0 green:239/255.0 blue:239/255.0 alpha:1];
    //上拉加载下拉刷新
    quanbuTable.header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadNewData)];
    quanbuTable.rowHeight = 70;
    self.quanbuTable = quanbuTable;
    [self.quanbuView addSubview:self.quanbuTable];
    //设置轻微Table
    UITableView *qinweiTable = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, self.view.frame.size.height - 64 + 64)];
    qinweiTable.tag = 1;
    qinweiTable.dataSource = self;
    qinweiTable.delegate = self;//去除下滑线
    qinweiTable.separatorStyle = UITableViewCellSeparatorStyleNone;
    qinweiTable.backgroundColor = [UIColor colorWithRed:239/255.0 green:239/255.0 blue:239/255.0 alpha:1];
    //上拉加载下拉刷新
    qinweiTable.header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadNewData)];
    qinweiTable.rowHeight = 70;
    self.qinweiTable = qinweiTable;
    [self.qingweiView addSubview:self.qinweiTable];
    //设置严重Table
    UITableView *yanzhongTable = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, self.view.frame.size.height - 64 + 64)];
    yanzhongTable.tag = 2;
    yanzhongTable.dataSource = self;
    yanzhongTable.delegate = self;//去除下滑线
    yanzhongTable.separatorStyle = UITableViewCellSeparatorStyleNone;
    yanzhongTable.backgroundColor = [UIColor colorWithRed:239/255.0 green:239/255.0 blue:239/255.0 alpha:1];
    //上拉加载下拉刷新
    yanzhongTable.header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadNewData)];
    yanzhongTable.rowHeight = 70;
    self.yanzhongTable = yanzhongTable;
    [self.yanzhongView addSubview:self.yanzhongTable];
}
#pragma mark - 下拉刷新
-(void)loadNewData{
    [self wangluo];
}
#pragma mark - 网络
-(void)wangluo{
    [[MLUserInfo sharedMLUserInfo] loadUserInfoFromSanbox];
    NSString *url = [MLInterface sharedMLInterface].getfriendListPatient;
    NSDictionary *dict = @{@"token":[MLUserInfo sharedMLUserInfo].token,@"typeId":@"5"};
    __weak typeof(self) weakSelf = self;
    [IWHttpTool postWithURL:url params:dict success:^(id json) {
        [weakSelf.quanbuTable.header endRefreshing];
        [weakSelf.qinweiTable.header endRefreshing];
        [weakSelf.yanzhongTable.header endRefreshing];
        MLDizhiModel *model = [MLDizhiModel objectWithKeyValues:json];
        if ([model.statusCode isEqualToString:@"200"]) {
            [NSHuangzheShujuModel setupReplacedKeyFromPropertyName:^NSDictionary *{
                return @{@"ID":@"id"};
            }];
            NSArray *array = [NSHuangzheShujuModel objectArrayWithKeyValuesArray:model.list];
            self.array = array;
            //分出严重array,和轻微array
            for (NSHuangzheShujuModel *huangzhe in array) {
                [weakSelf.qinweiArray removeAllObjects];
                [weakSelf.yanzhongArray removeAllObjects];
                if ([huangzhe.condition isEqualToString:@"120"]) {//轻微
                    [weakSelf.qinweiArray addObject:huangzhe];
                }else if ([huangzhe.condition isEqualToString:@"121"]) {//严重
                    [weakSelf.yanzhongArray addObject:huangzhe];
                }
            }
            [weakSelf.quanbuTable reloadData];
            [weakSelf.qinweiTable reloadData];
            [weakSelf.yanzhongTable reloadData];
            //子线程保存到数据库
            dispatch_group_t group = dispatch_group_create();
            dispatch_group_async(group, dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                NSLog(@"%@",[NSThread currentThread]);
                [weakSelf baochunshujuku];
            });
        }else if ([model.statusCode isEqualToString:@"310"]) {
            //这里做注销操作
            [[MLUserInfo sharedMLUserInfo] loadUserInfoFromSanbox];
            [MLUserInfo sharedMLUserInfo].user = nil;
            [MLUserInfo sharedMLUserInfo].pwd = nil;
            [MLUserInfo sharedMLUserInfo].loginStatus = YES;
            [[MLUserInfo sharedMLUserInfo] saveUserInfoToSanbox];
            //跳转到登陆界面
            UIStoryboard *storayobard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
            weakSelf.view.window.rootViewController = storayobard.instantiateInitialViewController;
        }else{
            [MBProgressHUD showError:model.message toView:self.view];
        }
    } failure:^(NSError *error) {
        [weakSelf.quanbuTable.header endRefreshing];
        [weakSelf.qinweiTable.header endRefreshing];
        [weakSelf.yanzhongTable.header endRefreshing];
        [MBProgressHUD showError:@"请检查网络" toView:self.view];
    }];
}
#pragma mark - tableView代理和数据源方法
//每组有多少行
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (tableView.tag == 0 ) {
        return self.array.count;
    }else if (tableView.tag == 1) {
        return self.qinweiArray.count;
    }else{
        return self.yanzhongArray.count;
    }
}
//每行显示什么内容
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *ID = @"cell";
    MLHuangzheCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        cell = [[MLHuangzheCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
    }
    if (tableView.tag == 0) {
        NSHuangzheShujuModel *model = self.array[indexPath.row];
        if (model.age == nil) {
            model.age = 0;
        }
        NSString *URL = [NSString stringWithFormat:@"http://rolle.cn:8080%@",model.headImage];
        [cell cellTouxiangURL:URL andName:model.nickname andNianling:model.age andXingbie:model.sex andZuigaoXuetang:model.booldSugarMax andZuidiXuetang:model.booldSugarMin andYanzhong:model.condition];
    }else if (tableView.tag == 1) {
        NSHuangzheShujuModel *model = self.qinweiArray[indexPath.row];
        if (model.age == nil) {
            model.age = 0;
        }
        NSString *URL = [NSString stringWithFormat:@"http://rolle.cn:8080%@",model.headImage];
        [cell cellTouxiangURL:URL andName:model.nickname andNianling:model.age andXingbie:model.sex andZuigaoXuetang:model.booldSugarMax andZuidiXuetang:model.booldSugarMin andYanzhong:model.condition];
    }else{
        NSHuangzheShujuModel *model = self.yanzhongArray[indexPath.row];
        if (model.age == nil) {
            model.age = 0;
        }
        NSString *URL = [NSString stringWithFormat:@"http://rolle.cn:8080%@",model.headImage];
        [cell cellTouxiangURL:URL andName:model.nickname andNianling:model.age andXingbie:model.sex andZuigaoXuetang:model.booldSugarMax andZuidiXuetang:model.booldSugarMin andYanzhong:model.condition];
    }
    return cell;
}
//点击每行做什么
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    //取消选择
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    if (tableView.tag == 0) {//点击全部
        NSHuangzheShujuModel *model = self.array[indexPath.row];
        MLBingshiController *nf = [[MLBingshiController alloc] init];
        [self.navigationController pushViewController:nf animated:YES];
        nf.model = model;
        self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStyleDone target:nil action:nil];
    }else if (tableView.tag == 1) {//点击轻微
        NSHuangzheShujuModel *model = self.qinweiArray[indexPath.row];
        MLBingshiController *nf = [[MLBingshiController alloc] init];
        [self.navigationController pushViewController:nf animated:YES];
        nf.model = model;
        self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStyleDone target:nil action:nil];
    }else if (tableView.tag == 2) {//点击严重
        NSHuangzheShujuModel *model = self.yanzhongArray[indexPath.row];
        MLBingshiController *nf = [[MLBingshiController alloc] init];
        [self.navigationController pushViewController:nf animated:YES];
        nf.model = model;
        self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStyleDone target:nil action:nil];
    }
}
//界面消失完毕
-(void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    [self.yingchang removeFromSuperview];
}
@end
