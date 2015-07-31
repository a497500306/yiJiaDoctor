//
//  MLShoudaoPinglunController.m
//  医家(医生端)
//
//  Created by 洛耳 on 15/7/23.
//  Copyright (c) 2015年 workorz. All rights reserved.
//

#import "MLShoudaoPinglunController.h"
#import "MBProgressHUD+MJ.h"
#import "IWHttpTool.h"
#import "MLUserInfo.h"
#import "MJExtension.h"
#import "MLInterface.h"
#import "MLDizhiModel.h"
#import "MLPinglunLiebiaoModel.h"
#import "MLPinglunLiebiaoCell.h"
#import "MLCoreDataTool.h"
#import "Pinglun.h"
#import "MJRefresh.h"

@interface MLShoudaoPinglunController ()<UITableViewDataSource,UITableViewDelegate>{
    //数据库文件
    NSManagedObjectContext *_context;
}
@property (nonatomic ,strong)NSArray *array;
@property (nonatomic ,weak)UITableView *table;

@end

@implementation MLShoudaoPinglunController
-(NSArray *)array{
    if (_array == nil) {
        _array = [NSArray array];
        return _array;
    }
    return _array;
}
#warning 没有性别和年龄属性,没有分页
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"收到的评论";
    //初始化
    [self chushihua];
    // 马上进入刷新状态
    [self.table.header beginRefreshing];
    //子线程中数据库操作
    dispatch_group_t group = dispatch_group_create();
    dispatch_group_async(group, dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [self shujuku];
        //回到主线程刷新UI
        dispatch_group_notify(group, dispatch_get_main_queue(), ^{
            [self.table reloadData];
        });
    });
}

#pragma mark - 初始化
-(void)chushihua{
    UITableView *table = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, self.view.frame.size.height - 64)];
    //设置头部间距
    UIView *jianju = [[UIView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 10)];
    jianju.backgroundColor = [UIColor colorWithRed:239/255.0 green:239/255.0 blue:239/255.0 alpha:1];
    table.tableHeaderView = jianju;
    //去除下滑线
    table.separatorStyle = UITableViewCellSeparatorStyleNone;
    table.delegate = self;
    table.dataSource = self;
    table.backgroundColor = [UIColor colorWithRed:239/255.0 green:239/255.0 blue:239/255.0 alpha:1];
    //上拉加载下拉刷新
    table.header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadNewData)];
    table.rowHeight = 90;
    [self.view addSubview:table];
    self.table = table;
}
#pragma mark - 网络获取
-(void)wangluo{
    NSString *url =  [MLInterface sharedMLInterface].getMessageListByMap;
    [[MLUserInfo sharedMLUserInfo] loadUserInfoFromSanbox];
    NSDictionary *dict = @{@"token":[MLUserInfo sharedMLUserInfo].token,@"typeId":@"22"};
    [IWHttpTool postWithURL:url params:dict success:^(id json) {
        [self.table.header endRefreshing];
        MLDizhiModel *model = [MLDizhiModel objectWithKeyValues:json];
        if ([model.statusCode isEqualToString:@"200"]) {
            [MLPinglunLiebiaoModel setupReplacedKeyFromPropertyName:^NSDictionary *{
                return @{@"ID":@"id"};
            }];
            NSArray *array = [MLPinglunLiebiaoModel objectArrayWithKeyValuesArray:model.list];
            self.array =array;
            [self.table reloadData];
            //子线程保存到数据库
            dispatch_group_t group = dispatch_group_create();
            dispatch_group_async(group, dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                [self baochunshujuku];
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
            self.view.window.rootViewController = storayobard.instantiateInitialViewController;
        }else{
            [MBProgressHUD showError:model.message toView:self.view];
        }
    } failure:^(NSError *error) {
        [self.table.header endRefreshing];
        [MBProgressHUD showError:@"请检查网络" toView:self.view];
    }];
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.array.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *ID = @"cell";
    MLPinglunLiebiaoCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        cell = [[MLPinglunLiebiaoCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
    }
    MLPinglunLiebiaoModel *liebiaoM = self.array[indexPath.row];
    NSString *URL = [NSString stringWithFormat:@"http://rolle.cn:8080%@",liebiaoM.headImage];
    [cell cellTouxiangURL:URL andName:liebiaoM.nickname andShijian:liebiaoM.createTime andNianling:@"22" andXingbie:@"1" andNeirong:liebiaoM.content];
    return cell;
}
#pragma mark - 上拉加载更多
-(void)loadNewData{
    [self wangluo];
}
#pragma mark - 数据库操作
-(void)shujuku{
    //取出数据库数据
    [[MLUserInfo sharedMLUserInfo] loadUserInfoFromSanbox];
    NSString *name =  [NSString stringWithFormat:@"%@MLForumCoreData.sqlite",[MLUserInfo sharedMLUserInfo].user];
    _context = [MLCoreDataTool chuanjianCoreData:name];
    //查询数据
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Pinglun"];
    NSArray* items = [_context executeFetchRequest:request error:nil];
    if (items.count > 0 ) {
        //取出数据库的模型数组
        self.array = [self coreDataArray:items];
    }
}
#pragma mark - 数据库转模型数组
-(NSMutableArray *)coreDataArray:(NSArray *)array{
    NSMutableArray *neirongArray = [NSMutableArray array];
    for (Pinglun *fe in array) {
        MLPinglunLiebiaoModel *neirong = [[MLPinglunLiebiaoModel alloc] init];
        neirong.content = fe.content ;
        neirong.createTime = fe.createTime;
        neirong.disabled = fe.disabled;
        neirong.displayOrder = fe.displayOrder;
        neirong.headImage = fe.headImage;
        neirong.ID = fe.pinglunid;
        neirong.mainUserId = fe.mainUserId;
        neirong.minorUserId = fe.minorUserId;
        neirong.nickname = fe.nickname;
        neirong.typeId = fe.typeId;
        [neirongArray addObject:neirong];
    }
    return neirongArray;
}
#pragma mark - 保存到数据库
-(void)baochunshujuku{
    //查询数据
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Pinglun"];
    NSArray *emps = [_context executeFetchRequest:request error:nil];
    if (emps.count > 0) {
        //删除数据
        for (Pinglun *fe in emps) {
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
        MLPinglunLiebiaoModel *neirong = self.array[i];
        [self neirongModel:neirong];
    }
}
#pragma mark - 模型数组转数据库
-(Pinglun *)neirongModel:(MLPinglunLiebiaoModel *)neirong{
    Pinglun *fe = [NSEntityDescription insertNewObjectForEntityForName:@"Pinglun" inManagedObjectContext:_context];
    fe.content = neirong.content ;
    fe.createTime = neirong.createTime;
    fe.disabled = neirong.disabled;
    fe.displayOrder = neirong.displayOrder;
    fe.headImage = neirong.headImage;
    fe.pinglunid = neirong.ID;
    fe.mainUserId = neirong.mainUserId;
    fe.minorUserId = neirong.minorUserId;
    fe.nickname = neirong.nickname;
    fe.typeId = neirong.typeId;
    // 直接保存数据库
    NSError *error = nil;
    [_context save:&error];
    if (error) {
        NSLog(@"%@",error);
    }
    return fe;
}
@end
