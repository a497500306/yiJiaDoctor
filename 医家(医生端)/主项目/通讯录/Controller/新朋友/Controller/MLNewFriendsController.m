//
//  MLNewFriendsController.m
//  医家(医生端)
//
//  Created by 洛耳 on 15/7/16.
//  Copyright (c) 2015年 workorz. All rights reserved.
//

#import "MLNewFriendsController.h"
#import "MLMailistCell.h"
#import "IWHttpTool.h"
#import "MJExtension.h"
#import "MLInterface.h"
#import "MLUserInfo.h"
#import "MLXinpengyouModel.h"
#import "MBProgressHUD+MJ.h"
#import "UMSocial.h"

@interface MLNewFriendsController ()<UITableViewDataSource,UITableViewDelegate,UMSocialUIDelegate>
@property (nonatomic ,weak)UITableView *table;
@property (nonatomic ,strong)NSArray *diyizhuArray;
@end

@implementation MLNewFriendsController
-(NSArray *)diyizhuArray{
    if (_diyizhuArray == nil) {
        _diyizhuArray = [[NSArray alloc] init];
        return _diyizhuArray;
    }
    return _diyizhuArray;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    //标题
    self.title = @"新朋友";
    //不透明
    self.navigationController.navigationBar.translucent = NO;
    //网络刷新数据
    [self wangluo];
    //初始化
    [self chushihua];
}
//-(void)viewWillAppear:(BOOL)animated{
//    [super viewWillAppear:animated];
//    //隐藏tabler
//    self.tabBarController.tabBar.hidden = YES;
//}
//- (void)viewWillDisappear: (BOOL)animated{
//    [super viewWillDisappear:animated];
//    //隐藏tabler
//    self.tabBarController.tabBar.hidden = NO;
//
//}
#pragma mark - 网络处理数据
-(void)wangluo{
    //网络处理
//    [[MLUserInfo sharedMLUserInfo] loadUserInfoFromSanbox];
//    NSString *token1 = [MLUserInfo sharedMLUserInfo].token;
//    //患者
//    NSString *pengyouquanURL = [MLInterface sharedMLInterface].getfriendSumPatient;
//    NSDictionary *parameters2 = @{@"token":token1, @"typeId":@"5"};
//    [IWHttpTool postWithURL:pengyouquanURL params:parameters2 success:^(id json) {
//        MLXinpengyouModel *model = [MLXinpengyouModel objectWithKeyValues:json];
//        if ([model.statusCode isEqualToString:@"200"]) {//数据保存到沙盒
//            [self.table reloadData];
//        }else if ([model.statusCode isEqualToString:@"310"]){
//            [[MLUserInfo sharedMLUserInfo] zhuxiaoyonghu];
//            UIStoryboard *storayobard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
//            self.view.window.rootViewController = storayobard.instantiateInitialViewController;
//        }
//    } failure:^(NSError *error) {
//        [MBProgressHUD showError:@"请检查您的网络" toView:self.view];
//    }];

}
#pragma mark - 初始化
-(void)chushihua{
    UITableView *table = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height) style:UITableViewStyleGrouped];
    table.backgroundColor = [UIColor colorWithRed:239/255.0 green:239/255.0 blue:239/255.0 alpha:1];
    table.delegate = self;
    table.dataSource = self;
    //取出分割线
    table.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:table];
    self.table = table;
    //设置数据
    NSDictionary *dict = @{@"image":@"btn－微信",@"text":@"邀请微信好友"};
    NSDictionary *dict1 = @{@"image":@"btn－QQ",@"text":@"邀请QQ好友"};
    NSDictionary *dict2 = @{@"image":@"btn－通讯录通讯录",@"text":@"邀请通讯录好友"};
    NSArray *array = @[dict,dict1,dict2];
    self.diyizhuArray = array;
}
#pragma mark - tableView代理方法
//多少组
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}
//多少行
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section == 0) {
        return self.diyizhuArray.count;
    }else{
    
    }
    return 4;
}
//每行显示什么内容
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        //循环利用
        static NSString *MLID = @"MLCell";
        MLMailistCell *cell = [tableView dequeueReusableCellWithIdentifier:MLID];
        if (cell == nil) {
            cell = [[MLMailistCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:MLID];
        }
        NSDictionary *dict = self.diyizhuArray[indexPath.row];
        [cell cellImage:[UIImage imageNamed:[dict objectForKey:@"image"]] andName:[dict objectForKey:@"text"]];
        if (indexPath.row > 0) {
            [cell.shangxian removeFromSuperview];
        }
        return cell;
    }
    UITableViewCell *cell = [[UITableViewCell alloc] init];
    cell.textLabel.text= @"测试";
    return cell;
}
//点击每行做什么事情
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    //取消选择
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    if (indexPath.section == 0 && indexPath.row == 0) {
        //点击邀请微信好友
        //设置分享内容，和回调对象
        NSString *shareText = @"友盟社会化组件可以让移动应用快速具备社会化分享、登录、评论、喜欢等功能，并提供实时、全面的社会化数据统计分析服务。 http://www.umeng.com/social";
        UIImage *shareImage = [UIImage imageNamed:@"UMS_social_demo"];
        
        [[UMSocialControllerService defaultControllerService] setShareText:shareText shareImage:shareImage socialUIDelegate:self];
        UMSocialSnsPlatform *snsPlatform = [UMSocialSnsPlatformManager getSocialPlatformWithName:@"wxfavorite"];
        snsPlatform.snsClickHandler(self,[UMSocialControllerService defaultControllerService],YES);
    }else if (indexPath.section == 0 && indexPath.row == 1) {
        //点击QQ邀请好友
        //设置分享内容，和回调对象
        NSString *shareText = @"友盟社会化组件可以让移动应用快速具备社会化分享、登录、评论、喜欢等功能，并提供实时、全面的社会化数据统计分析服务。 http://www.umeng.com/social";
        UIImage *shareImage = [UIImage imageNamed:@"UMS_social_demo"];
        
        [[UMSocialControllerService defaultControllerService] setShareText:shareText shareImage:shareImage socialUIDelegate:self];
        UMSocialSnsPlatform *snsPlatform = [UMSocialSnsPlatformManager getSocialPlatformWithName:@"qq"];
        snsPlatform.snsClickHandler(self,[UMSocialControllerService defaultControllerService],YES);
    }
}
//动态设置高度
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 60;
}
//section头部间距
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        return 10;
    }else{
        return 9;
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
@end
