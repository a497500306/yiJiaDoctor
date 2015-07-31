//
//  MLSetUpController.m
//  医家(医生端)
//
//  Created by 洛耳 on 15/7/20.
//  Copyright (c) 2015年 workorz. All rights reserved.
//

#import "MLSetUpController.h"
#import "MLUserInfo.h"
#import "MLFeedbackController.h"
#import "MLGuanyuwomenController.h"

@interface MLSetUpController ()<UITableViewDataSource,UITableViewDelegate>

@end

@implementation MLSetUpController

- (void)viewDidLoad {
    [super viewDidLoad];
    //不透明
    self.navigationController.navigationBar.translucent = NO;
    //标题
    self.title = @"设置";
    self.view.backgroundColor = [UIColor whiteColor];
    //初始化
    [self chushihua];
}
#pragma mark - 初始化
-(void)chushihua{
    UITableView *table = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, self.view.frame.size.height) style:UITableViewStyleGrouped];
    table.delegate = self;
    table.dataSource = self;
    table.backgroundColor = [UIColor colorWithRed:239/255.0 green:239/255.0 blue:239/255.0 alpha:1];
    //底部退出按钮
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 100)];
    UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(10, 0, [UIScreen mainScreen].bounds.size.width - 20, 50)];
    [btn setTitle:@"退出登录" forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor colorWithRed:226/255.0 green:46/255.0 blue:46/255.0 alpha:1] forState:UIControlStateNormal];
    btn.backgroundColor = [UIColor whiteColor];
    //圆角
    btn.layer.cornerRadius = 3;
    btn.layer.masksToBounds = YES;
    [btn addTarget:self action:@selector(tuichudenglu) forControlEvents:UIControlEventTouchUpInside];
    [view addSubview:btn];
    table.tableFooterView = view;
    [self.view addSubview:table];
}
#pragma mark - uitableview代理数据源方法
//一共有多少组
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}
//每组又多少行
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section == 0) {
        return 2;
    }else{
        return 3;
    }
}
//每行显示什么内容
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:nil];
    if (indexPath.section == 0) {//第一组
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        if (indexPath.row == 0) {//第一组第一行
            cell.textLabel.text = @"推送设置";
            UISwitch *switchView = [[UISwitch alloc] initWithFrame:CGRectMake([UIScreen mainScreen].bounds.size.width - 60, 6, 100.0f, 28.0f)];
            //设置UISwitch的初始化状态
            switchView.on = YES;//设置初始为ON的一边
            //UISwitch事件的响应
            [switchView addTarget:self action:@selector(switchAction:) forControlEvents:UIControlEventValueChanged];
            [cell.contentView addSubview:switchView];
        }else if (indexPath.row == 1){//第一组第二行
            cell.textLabel.text = @"版本";
            cell.detailTextLabel.text = [[[NSBundle mainBundle] infoDictionary] objectForKey:(NSString *)kCFBundleVersionKey];
        }
    }else if (indexPath.section == 1) {//第二组
        //设置小箭头
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        if (indexPath.row == 0) {
            cell.textLabel.text = @"意见反馈";
        }else if (indexPath.row == 1) {
            cell.textLabel.text = @"给我们评分";
        }else if (indexPath.row == 2) {
            cell.textLabel.text = @"关于我们";
        }
    }
    return cell;
}
//点击每行做什么事情
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    //取消选择
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    if (indexPath.section == 1) {
        if (indexPath.row == 0) {//意见反馈
            MLFeedbackController *nf = [[MLFeedbackController alloc] init];
            nf.hidesBottomBarWhenPushed=YES;
            [self.navigationController pushViewController:nf animated:YES];
            self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStyleDone target:nil action:nil];
        }else if (indexPath.row == 1) {//给我们评分,跳到APP
        
        }else if (indexPath.row == 2) {//关于我们
            MLGuanyuwomenController *nf = [[MLGuanyuwomenController alloc] init];
            nf.hidesBottomBarWhenPushed=YES;
            [self.navigationController pushViewController:nf animated:YES];
            self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStyleDone target:nil action:nil];
        }
    }
}
#pragma mark - 退出登录
-(void)tuichudenglu{
        //这里做注销操作
        [[MLUserInfo sharedMLUserInfo] loadUserInfoFromSanbox];
        [MLUserInfo sharedMLUserInfo].user = nil;
        [MLUserInfo sharedMLUserInfo].pwd = nil;
        [MLUserInfo sharedMLUserInfo].loginStatus = YES;
        [[MLUserInfo sharedMLUserInfo] saveUserInfoToSanbox];
        //跳转到登陆界面
        UIStoryboard *storayobard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        self.view.window.rootViewController = storayobard.instantiateInitialViewController;
}

//section头部间距
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        return 10;
    }else if (section == 1){
        return 9;
    }else{
        return 1;
    }
}
//section底部间距
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    if (section == 0) {
        return 1;
    }else{
        return 9;
    }
}
-(void)switchAction:(UISwitch *)switchView{

}
@end
