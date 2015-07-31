//
//  MLZhanController.m
//  医家(医生端)
//
//  Created by 洛耳 on 15/7/24.
//  Copyright (c) 2015年 workorz. All rights reserved.
//

#import "MLZhanController.h"
#import "MBProgressHUD+MJ.h"
#import "IWHttpTool.h"
#import "MLUserInfo.h"
#import "MJExtension.h"
#import "MLInterface.h"
#import "MLDizhiModel.h"
#import "MLZhanModel.h"
#import "MLZhanCell.h"
#import "MJRefresh.h"
#import "MLCoreDataTool.h"
#import "Zhan.h"


@interface MLZhanController ()<UITableViewDataSource,UITableViewDelegate>{
    //数据库文件
    NSManagedObjectContext *_context;
}
@property (nonatomic ,weak)UITableView *table;
@property (nonatomic ,strong)NSMutableArray *array;
@end

@implementation MLZhanController
-(NSMutableArray *)array{
    if (_array == nil) {
        _array = [NSMutableArray array];
        return _array;
    }
    return _array;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"收到的赞";
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
    UITableView *table = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, self.view.frame.size.height)];
    table.delegate = self;
    table.dataSource = self;
    //去除下滑线
    table.separatorStyle = UITableViewCellSeparatorStyleNone;
    table.backgroundColor = [UIColor colorWithRed:239/255.0 green:239/255.0 blue:239/255.0 alpha:1];
    //上拉加载下拉刷新
    table.header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadNewData)];
    table.rowHeight = 70;
    //cell不可被选中
    table.allowsSelection = NO;
    self.table = table;
    [self.view addSubview:table];
}
#pragma mark - 上拉加载更多
-(void)loadNewData{
    [self wangluo];
}
#pragma mark - 网络获取
-(void)wangluo{
    NSString *url = [MLInterface sharedMLInterface].getPraiseUserListByMap;
    [[MLUserInfo sharedMLUserInfo] loadUserInfoFromSanbox];
    NSDictionary *dict = @{@"token":[MLUserInfo sharedMLUserInfo].token};
    [IWHttpTool postWithURL:url params:dict success:^(id json) {
        [self.table.header endRefreshing];
        MLDizhiModel *model = [MLDizhiModel objectWithKeyValues:json];
        if ([model.statusCode isEqualToString:@"200"]) {
            [MLZhanModel setupReplacedKeyFromPropertyName:^NSDictionary *{
                return @{@"ID":@"id"};
            }];
            NSMutableArray *array = [MLZhanModel objectArrayWithKeyValuesArray:model.list];
            self.array = array;
            [self.table reloadData];
            //子线程保存到数据库
            dispatch_group_t group = dispatch_group_create();
            dispatch_group_async(group, dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                [self baochunshujuku];
            });
        }else if ([model.statusCode isEqualToString:@"310"]){
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
#pragma mark - tableView代理和数据源方法
//每组有多少行
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.array.count;
}
//每行显示什么内容
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *ID = @"cell";
    MLZhanCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        cell = [[MLZhanCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
    }
    MLZhanModel *liebiaoM = self.array[indexPath.row];
    NSString *URL = [NSString stringWithFormat:@"http://rolle.cn:8080%@",liebiaoM.headImage];
    NSString *str = [NSString stringWithFormat:@"收到了来自\"%@\"的赞",liebiaoM.nickname];
    [cell cellTouxiangURL:URL andName:str andShijian:liebiaoM.createTime];
    return cell;
}
//设置分割线包含整个宽度
-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath

{
    [cell setSeparatorInset:UIEdgeInsetsZero];
    [cell setLayoutMargins:UIEdgeInsetsZero];
}

#pragma mark - 数据库操作
-(void)shujuku{
    //取出数据库数据
    [[MLUserInfo sharedMLUserInfo] loadUserInfoFromSanbox];
    NSString *name =  [NSString stringWithFormat:@"%@MLForumCoreData.sqlite",[MLUserInfo sharedMLUserInfo].user];
    _context = [MLCoreDataTool chuanjianCoreData:name];
    //查询数据
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Zhan"];
    NSArray* items = [_context executeFetchRequest:request error:nil];
    if (items.count > 0 ) {
        //取出数据库的模型数组
        self.array = [self coreDataArray:items];
    }
}
#pragma mark - 数据库转模型数组
-(NSMutableArray *)coreDataArray:(NSArray *)array{
    NSMutableArray *neirongArray = [NSMutableArray array];
    for (Zhan *fe in array) {
        MLZhanModel *neirong = [[MLZhanModel alloc] init];
        neirong.createTime = fe.createTime ;
        neirong.headImage = fe.headImage;
        neirong.ID = fe.zhanID;
        neirong.mainUserId = fe.mainUserId;
        neirong.minorUserId = fe.minorUserId;
        neirong.nickname = fe.nickname;
        neirong.post = fe.post;
        neirong.postId = fe.postId;
        neirong.reply = fe.reply;
        neirong.replyId = fe.replyId;
        neirong.typeId = fe.typeId;
        [neirongArray addObject:neirong];
    }
    return neirongArray;
}
#pragma mark - 保存到数据库
-(void)baochunshujuku{
    //查询数据
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Zhan"];
    NSArray *emps = [_context executeFetchRequest:request error:nil];
    if (emps.count > 0) {
        //删除数据
        for (Zhan *fe in emps) {
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
        MLZhanModel *neirong = self.array[i];
        [self neirongModel:neirong];
    }
}
#pragma mark - 模型数组转数据库
-(Zhan *)neirongModel:(MLZhanModel *)neirong{
    Zhan *fe = [NSEntityDescription insertNewObjectForEntityForName:@"Zhan" inManagedObjectContext:_context];
    fe.createTime = neirong.createTime ;
    fe.headImage = neirong.headImage;
    fe.zhanID = neirong.ID;
    fe.mainUserId = neirong.mainUserId;
    fe.minorUserId = neirong.minorUserId;
    fe.nickname = neirong.nickname;
    fe.postId = neirong.postId;
    fe.post = neirong.post;
    fe.replyId = neirong.replyId;
    fe.reply = neirong.reply;
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
