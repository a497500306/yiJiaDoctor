//
//  MLPinglunXiangxiController.m
//  医家(医生端)
//
//  Created by 洛耳 on 15/7/24.
//  Copyright (c) 2015年 workorz. All rights reserved.
//

#import "MLPinglunXiangxiController.h"
#import "MBProgressHUD+MJ.h"
#import "IWHttpTool.h"
#import "MLUserInfo.h"
#import "MJExtension.h"
#import "MLInterface.h"

@interface MLPinglunXiangxiController ()

@end

@implementation MLPinglunXiangxiController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"记录";
    //初始化
    [self chushihua];
    //网络获取数据
    [self wangluo];
}
#pragma mark - 网络获取数据
-(void)wangluo{
    NSString *url = [MLInterface sharedMLInterface].getMessageRecordByMap;
    [[MLUserInfo sharedMLUserInfo] loadUserInfoFromSanbox];
    NSDictionary *dict = @{@"token":[MLUserInfo sharedMLUserInfo].token,@"typeId":@"22"};
}
#pragma mark - 初始化
-(void)chushihua{

}
@end
