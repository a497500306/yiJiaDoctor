//
//  MLDoctorCircleController.m
//  医家(医生端)
//
//  Created by 洛耳 on 15/7/16.
//  Copyright (c) 2015年 workorz. All rights reserved.
//  全部tbale tag = 0;  同科室table tag = 1;

#import "MLDoctorCircleController.h"
#import "IWHttpTool.h"
#import "MLInterface.h"
#import "MJExtension.h"
#import "MLUserInfo.h"
#import "MBProgressHUD+MJ.h"
#import "MLDizhiModel.h"
#import "NSHuangzheShujuModel.h"
#import "MJRefresh.h"
#import "MLSlidingAroundView.h"
#import "MLYishengquanLBModel.h"
#import "MLHuangzheCell.h"
#import "MLCoreDataTool.h"
#import "MLMyModel.h"
#import "NewUser.h"
#import "MLYishengquanXiangxiZhiliaoController.h"
#import "DoctorCircle.h"

@interface MLDoctorCircleController ()<UITableViewDataSource,UITableViewDelegate>{
    //数据库文件
    NSManagedObjectContext *_context;
}
@property (nonatomic ,strong)MLMyModel *mm;
/**
 *  同科室View
 */
@property (nonatomic ,weak)UIView *tongkeshiView;
/**
 *  全部View
 */
@property (nonatomic ,weak)UIView *quanbuView;
/**
 *  隐藏
 */
@property (nonatomic ,weak)UIView *yingchang;
/**
 *  列表数据
 */
@property (nonatomic ,strong)NSMutableArray *array;
/**
 *  同科室Array
 */
@property (nonatomic ,strong)NSMutableArray *tongkeshiArray;
/**
 *  全部Table
 */
@property (nonatomic ,weak)UITableView *quanbuTable;
/**
 *   同科室Table
 */
@property (nonatomic ,weak)UITableView *tongkeshiTable;
@end

@implementation MLDoctorCircleController
-(NSMutableArray *)tongkeshiArray{
    if (_tongkeshiArray == nil) {
        _tongkeshiArray = [NSMutableArray array];
        return _tongkeshiArray;
    }
    return _tongkeshiArray;
}
-(NSMutableArray *)array{
    if (_array == nil) {
        _array = [NSMutableArray array];
        return _array;
    }
    return _array;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"医生圈";
    //不透明
    self.navigationController.navigationBar.translucent = NO;
    //隐藏黑线,在界面退出时消除
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 63, [UIScreen mainScreen].bounds.size.width, 2)];
    view.backgroundColor = [UIColor whiteColor];
    self.yingchang = view;
    [self.navigationController.view addSubview:view];
    [self.navigationController.view bringSubviewToFront:view];
    //初始化
    [self chushihua];
    //数据库取出个人信息和列表信息
    [self shujuku];
    // 马上进入刷新状态
    [self.quanbuTable.header beginRefreshing];
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    //不透明
    self.navigationController.navigationBar.translucent = NO;
}
#pragma mark - 数据库处理
-(void)shujuku{
    //这个数据库操作必须在主线程运行
    [self quchushujuku];
    [self quchuliebiao];
    [self.tongkeshiTable reloadData];
    [self.quanbuTable reloadData];
}
#pragma mark - 网络
-(void)wangluo{
    NSString *url = [MLInterface sharedMLInterface].getfriendListDoctor;
    [[MLUserInfo sharedMLUserInfo] loadUserInfoFromSanbox];
    NSDictionary *dict = @{@"token":[MLUserInfo sharedMLUserInfo].token,@"typeId":@"3"};
    [IWHttpTool postWithURL:url params:dict success:^(id json) {
        [self.quanbuTable.header endRefreshing];
        MLDizhiModel *model = [MLDizhiModel objectWithKeyValues:json];
        if ([model.statusCode isEqualToString:@"200"]) {
            [MLYishengquanLBModel setupReplacedKeyFromPropertyName:^NSDictionary *{
                return @{@"ID":@"id"};
            }];
            NSMutableArray *array = [MLYishengquanLBModel objectArrayWithKeyValuesArray:model.list];
            self.array = array;
            for (MLYishengquanLBModel *model in array) {
                if ([model.departmentsName isEqualToString:self.mm.department]) {
                    [self.tongkeshiArray addObject:model];
                }
            }
            //刷新数据库(子线程刷新数据库)
            __weak typeof(self) weakSelf = self;
            dispatch_group_t group = dispatch_group_create();
            dispatch_group_async(group, dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                //取出数据库保存的信息
                [weakSelf baochunshuju];
            });
            [self.tongkeshiTable reloadData];
            [self.quanbuTable reloadData];
        }else if ([model.statusCode isEqualToString:@"310"]) {
            //这里做注销操作
            [[MLUserInfo sharedMLUserInfo] loadUserInfoFromSanbox];
            [MLUserInfo sharedMLUserInfo].user = nil;
            [MLUserInfo sharedMLUserInfo].pwd = nil;
            [MLUserInfo sharedMLUserInfo].loginStatus = YES;
            [[MLUserInfo sharedMLUserInfo] saveUserInfoToSanbox];
            //跳转到登陆界面
            UIStoryboard *storayobard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
            self.view.window.rootViewController = storayobard.instantiateInitialViewController;
        }else {
            [MBProgressHUD showError:model.message toView:self.view];
        }
    } failure:^(NSError *error) {
        
    }];
}
#pragma mark - 初始化
-(void)chushihua{
    MLSlidingAroundView *sa = [[MLSlidingAroundView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, self.view.frame.size.height)];
    NSArray *array = @[@"全部",@"同科室"];
    sa.backgroundColor = [UIColor colorWithRed:239/255.0 green:239/255.0 blue:239/255.0 alpha:1];
    [sa slidingAroundBtnNumber:array];
    [self.view addSubview:sa];
    self.quanbuView = sa.views[0];
    self.tongkeshiView = sa.views[1];
    //创建全部界面
    [self chuangjianquanbu];
    //创建同科室界面
    [self chuangjiantongkeshi];
}
#pragma mark - 创建全部界面
-(void)chuangjianquanbu{
    UITableView *table = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, self.quanbuView.frame.size.height)];
    table.delegate = self;
    table.dataSource = self;
    //去除下滑线
    table.separatorStyle = UITableViewCellSeparatorStyleNone;
    table.backgroundColor = [UIColor colorWithRed:239/255.0 green:239/255.0 blue:239/255.0 alpha:1];
    //上拉加载下拉刷新
    table.header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadNewData)];
    table.rowHeight = 70;
    self.quanbuTable = table;
    [self.quanbuView addSubview:table];
}
#pragma mark - 创建同科室界面
-(void)chuangjiantongkeshi{
    UITableView *table = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, self.quanbuView.frame.size.height)];
    table.tag = 1;
    table.delegate = self;
    table.dataSource = self;
    //去除下滑线
    table.separatorStyle = UITableViewCellSeparatorStyleNone;
    table.backgroundColor = [UIColor colorWithRed:239/255.0 green:239/255.0 blue:239/255.0 alpha:1];
    //上拉加载下拉刷新
    table.header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadNewData)];
    table.rowHeight = 70;
    self.tongkeshiTable = table;
    [self.tongkeshiView addSubview:table];
}

#pragma mark - 数据库操作
//取出数据库保存的信息
-(void)quchushujuku{
    [[MLUserInfo sharedMLUserInfo] loadUserInfoFromSanbox];
    NSString *name =  [NSString stringWithFormat:@"%@User.sqlite",[MLUserInfo sharedMLUserInfo].user];
    _context = [MLCoreDataTool chuanjianCoreData:name];//查询数据
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"NewUser"];
    NSArray* items = [_context executeFetchRequest:request error:nil];
    if (items.count > 0) {
        //添加数据到模型
        for (NewUser *fe in items) {
            MLMyModel *mm = [[MLMyModel alloc] init];
            mm.headImage = fe.headImage;
            mm.nickname = fe.nickname;
            mm.qrCode = fe.qrCode;
            mm.intro = fe.intro;
            mm.workAddress = fe.workAddress;
            mm.hospitalName = fe.hospitalName;
            mm.doctorTitle = fe.doctorTitle;
            mm.department = fe.department;
            mm.doctorTitle = fe.doctorTitle;
            mm.department = fe.department;
            mm.specialty = fe.specialty;
            mm.idImage = fe.idImage;
            mm.businessLicense = fe.businessLicense;
            mm.isAudit = fe.isAudit;
            mm.sex = fe.sex;
            mm.birthday = fe.birthday;
            mm.age = fe.age;
            self.mm = mm;
        }
        // 3.保存
        [_context save:nil];
    }
}
//取出列表信息
-(void)quchuliebiao{
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"DoctorCircle"];
    NSArray* items = [_context executeFetchRequest:request error:nil];
    if (items.count > 0) {
        //添加数据到模型
        for (DoctorCircle *fe in items) {
            MLYishengquanLBModel *mm = [[MLYishengquanLBModel alloc] init];
            mm.headImage = fe.headImage;
            mm.nickname = fe.nickName;
            mm.age = fe.age;
            mm.sex = fe.sex;
            mm.departmentsName = fe.department;
            mm.ID = fe.iD;
            [self.array addObject:mm];
        }
        // 3.保存
        [_context save:nil];
    }
    for (MLYishengquanLBModel *model in self.array) {
        if ([model.departmentsName isEqualToString:self.mm.department]) {
            [self.tongkeshiArray addObject:model];
        }
    }
}
//保存到数据库
-(void)baochunshuju{
    //查询数据
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"DoctorCircle"];
    NSArray *emps = [_context executeFetchRequest:request error:nil];
    if (emps.count > 0) {
        //删除数据
        for (DoctorCircle *fe in emps) {
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
//添加数据到数据库
-(void)tianjiashuju{
    //添加数据
    for (int i = 0; i < self.array.count; i++) {
        MLYishengquanLBModel *neirong = self.array[i];
        [self neirongModel:neirong];
    }
}

//模型数组转数据库
-(DoctorCircle *)neirongModel:(MLYishengquanLBModel *)neirong{
    DoctorCircle *fe = [NSEntityDescription insertNewObjectForEntityForName:@"DoctorCircle" inManagedObjectContext:_context];
    fe.headImage = neirong.headImage;
    fe.nickName = neirong.nickname;
    fe.age = neirong.age;
    fe.sex = neirong.sex;
    fe.department = neirong.departmentsName;
    fe.iD = neirong.ID;
    // 直接保存数据库
    NSError *error = nil;
    [_context save:&error];
    if (error) {
        NSLog(@"%@",error);
    }
    return fe;
}

#pragma mark - 下拉刷新
-(void)loadNewData{
    [self wangluo];
}
#pragma mark - tableView代理和数据源方法
//每组有多少行
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (tableView.tag == 1) {
        return self.tongkeshiArray.count;
    }else{
        return self.array.count;
    }
}
//每行显示什么内容
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *ID = @"cell";
    MLHuangzheCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        cell = [[MLHuangzheCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
    }
    MLYishengquanLBModel *liebiaoM = nil;
    if (tableView.tag == 1) {
        liebiaoM = self.tongkeshiArray[indexPath.row];
    }else{
        liebiaoM = self.array[indexPath.row];
    }
    NSString *URL = [NSString stringWithFormat:@"http://rolle.cn:8080%@",liebiaoM.headImage];
    [cell cellTouxiangURL:URL andName:liebiaoM.nickname andNianling:liebiaoM.age andXingbie:liebiaoM.sex andKeshi:liebiaoM.departmentsName];
    return cell;
}
//点击每行做什么事情
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    //取消选择
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    MLYishengquanLBModel *model = nil;
    if (tableView.tag == 1 ) {
        model = self.tongkeshiArray[indexPath.row];
    }else{
        model = self.array[indexPath.row];
    }
    MLYishengquanXiangxiZhiliaoController *nf = [[MLYishengquanXiangxiZhiliaoController alloc] init];
    nf.model = model;
    nf.hidesBottomBarWhenPushed=YES;
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStyleDone target:nil action:nil];
    [self.navigationController pushViewController:nf animated:YES];
    
}
//设置分割线包含整个宽度
-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath

{
    [cell setSeparatorInset:UIEdgeInsetsZero];
    [cell setLayoutMargins:UIEdgeInsetsZero];
}

//界面消失完毕
-(void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    [self.yingchang removeFromSuperview];
}
@end
