//
//  MLMailListController.m
//  医家(医生端)
//
//  Created by 洛耳 on 15/7/9.
//  Copyright (c) 2015年 workorz. All rights reserved.
//

#import "MLMailListController.h"
#import "MLSearchBox.h"
#import "IWHttpTool.h"
#import "MJExtension.h"
#import "MLInterface.h"
#import "MLUserInfo.h"
#import "MLMailistCell.h"
#import "MBProgressHUD+MJ.h"
#import "MLHuangzheModel.h"
#import "MLNewFriendsController.h"
#import "MLUserTongxunluTool.h"
#import "MLPatientController.h"
#import "MLDoctorCircleController.h"
#import "MLNavigationController.h"
#import "MLHuangzheModel.h"
#import "MBProgressHUD+MJ.h"


@interface MLMailListController ()<MLSearchBoxDelegate,UITableViewDataSource,UITableViewDelegate>
@property (nonatomic ,weak)UITableView *table;
@property (nonatomic ,copy)NSString *huangzheshu;
@property (nonatomic ,strong)MLHuangzheModel *model;

@end

@implementation MLMailListController

- (void)viewDidLoad {
    [super viewDidLoad];
    //不透明
    self.navigationController.navigationBar.translucent = NO;
    UITabBarItem* item = [self.tabBarController.tabBar.items objectAtIndex:1];
    item.selectedImage = [UIImage imageNamed:@"btn－通讯录选中"];
    //初始化
    [self chushihua];
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
}
#pragma mark - 初始化
-(void)chushihua{
    [self huangzheshumu];
    //取出用户数据
    [[MLUserTongxunluTool sharedMLUserTongxunluTool] loadUserInfoFromSanbox];
    self.huangzheshu = [MLUserTongxunluTool sharedMLUserTongxunluTool].huanzheshu;
    //创建搜索栏
    MLSearchBox * shousuo = [[MLSearchBox alloc] init];
    shousuo.delegate = self;
    [shousuo chuangjianSearchBox];
    [self.view addSubview:shousuo];
    //创建table
    UITableView *table = [[UITableView alloc] initWithFrame:CGRectMake(0, shousuo.frame.origin.y + shousuo.frame.size.height, [UIScreen mainScreen].bounds.size.width, self.view.frame.size.height - shousuo.frame.size.height)];
    //主背景颜色
    table.backgroundColor = [UIColor colorWithRed:239/255.0 green:239/255.0 blue:239/255.0 alpha:1];
    table.delegate = self;
    table.dataSource = self;
    self.table = table;
    //取消下划线
    table.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:table];
}
#pragma mark - 网络获取患者数目
-(void)huangzheshumu{
    //网络处理
    [[MLUserInfo sharedMLUserInfo] loadUserInfoFromSanbox];
    NSString *token1 = [MLUserInfo sharedMLUserInfo].token;
    //患者
    NSString *pengyouquanURL = [MLInterface sharedMLInterface].getfriendSumPatient;
    NSDictionary *parameters2 = @{@"token":token1, @"typeId":@"5"};
    __weak typeof(self) weakSelf = self;
    [IWHttpTool postWithURL:pengyouquanURL params:parameters2 success:^(id json) {
        MLHuangzheModel *model = [MLHuangzheModel objectWithKeyValues:json];
        NSLog(@"调用了网络");
        if ([model.statusCode isEqualToString:@"200"]) {//数据保存到沙盒
            weakSelf.huangzheshu = model.friendSum;
            [[MLUserTongxunluTool sharedMLUserTongxunluTool] loadUserInfoFromSanbox];
            [MLUserTongxunluTool sharedMLUserTongxunluTool].huanzheshu = self.huangzheshu;
            [[MLUserTongxunluTool sharedMLUserTongxunluTool] saveUserInfoToSanbox];
            [weakSelf.table reloadData];
        }else if ([model.statusCode isEqualToString:@"310"]){
            //这里做注销操作
            [[MLUserInfo sharedMLUserInfo] loadUserInfoFromSanbox];
            [MLUserInfo sharedMLUserInfo].user = nil;
            [MLUserInfo sharedMLUserInfo].pwd = nil;
            [MLUserInfo sharedMLUserInfo].loginStatus = YES;
            [[MLUserInfo sharedMLUserInfo] saveUserInfoToSanbox];
            //跳转到登陆界面
            UIStoryboard *storayobard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
            weakSelf.view.window.rootViewController = storayobard.instantiateInitialViewController;
        }
    } failure:^(NSError *error) {
        [MBProgressHUD showError:@"请检查您的网络" toView:self.view];
    }];
}
#pragma mark - tableView代理方法
//多少行
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 4;
}
//每行显示什么内容
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 1) {
        UITableViewCell *cell = [[UITableViewCell alloc] init];
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 10)];
        view.backgroundColor = [UIColor colorWithRed:239/255.0 green:239/255.0 blue:239/255.0 alpha:1];
        [cell.contentView addSubview:view];
        cell.userInteractionEnabled = NO;
        return cell;
    }
    MLMailistCell *mc = [[MLMailistCell alloc] init];
    if (indexPath.row == 0) {
        [mc cellImage:[UIImage imageNamed:@"icon－加朋友"] andName:@"新朋友"];
    }else if (indexPath.row == 2){
        if (self.huangzheshu == nil) {
            self.huangzheshu = @"0";
        }
        NSString *str = [NSString stringWithFormat:@"患者(%@)",self.huangzheshu];
        [mc cellImage:[UIImage imageNamed:@"icon－患者"] andName:str];
    }else if (indexPath.row == 3){
        [mc cellImage:[UIImage imageNamed:@"icon－医生圈"] andName:@"医生圈"];
        [mc.shangxian removeFromSuperview];
    }
    return mc;
}
//点击每行做什么事
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    //取消选择
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    if (indexPath.row == 0) {
        MLNewFriendsController *nf = [[MLNewFriendsController alloc] init];
        nf.hidesBottomBarWhenPushed=YES;
        [self.navigationController pushViewController:nf animated:YES];
        self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStyleDone target:nil action:nil];
    }else if (indexPath.row == 2){
        MLPatientController *oc = [[MLPatientController alloc] init];
        //隐藏UITabBar
        oc.hidesBottomBarWhenPushed=YES;
        [self.navigationController pushViewController:oc animated:YES];
        self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStyleDone target:nil action:nil];
    }else if (indexPath.row == 3){
        MLDoctorCircleController *dc = [[MLDoctorCircleController alloc] init];
        dc.hidesBottomBarWhenPushed=YES;
        [self.navigationController pushViewController:dc animated:YES];
        self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStyleDone target:nil action:nil];
    }
    
}
//动态设置高度
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 1) {
        return 10;
    }
    return 60;
}

#pragma mark - MLSearchBoxDelegate
-(void)dianjiquxiao{
    //显示uinavigationcontroller
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    // 2.计算控制器的view需要平移的距离
    [UIView animateWithDuration:0.2 animations:^{
        self.table.transform = CGAffineTransformMakeTranslation(0, 0);
    }];
}
-(void)jijiangdonghua{
    //隐藏uinavigationcontroller
    [self.navigationController setNavigationBarHidden:YES animated:YES];
    // 2.计算控制器的view需要平移的距离
    [UIView animateWithDuration:0.2 animations:^{
        self.table.transform = CGAffineTransformMakeTranslation(0, 20);
    }];
}
@end
