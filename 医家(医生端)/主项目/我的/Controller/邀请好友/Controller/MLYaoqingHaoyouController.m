//
//  MLYaoqingHaoyouController.m
//  医家(医生端)
//
//  Created by 洛耳 on 15/7/31.
//  Copyright (c) 2015年 workorz. All rights reserved.
//

#import "MLYaoqingHaoyouController.h"

@interface MLYaoqingHaoyouController ()
@property (nonatomic ,weak)UILabel *ningdeLable;
@end

@implementation MLYaoqingHaoyouController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"邀请好友";
    //初始化
    [self chushihua];
}
#pragma mark - 初始化
-(void)chushihua{
    self.view.backgroundColor = [UIColor colorWithRed:239/255.0 green:239/255.0 blue:239/255.0 alpha:1];
    //创建邀请界面
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 10, [UIScreen mainScreen].bounds.size.width, 200)];
    view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:view];
    //邀请好友View
    UILabel *yaoqingLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 10, [UIScreen mainScreen].bounds.size.width, 20)];
    yaoqingLabel.text = @"邀请好友";
    yaoqingLabel.font = [UIFont systemFontOfSize:13];
    yaoqingLabel.textColor = [UIColor colorWithRed:118/255.0 green:118/255.0 blue:118/255.0 alpha:1];
    yaoqingLabel.textAlignment = NSTextAlignmentCenter;
    [view addSubview:yaoqingLabel];
    //我的邀请码
    UILabel *ningdeLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, yaoqingLabel.frame.origin.y + yaoqingLabel.frame.size.height + 10, yaoqingLabel.frame.size.width, 30)];
    ningdeLabel.text = @"您的邀请码:";
    ningdeLabel.font = [UIFont systemFontOfSize:16];
    [view addSubview:ningdeLabel];
    //邀请点击
    NSArray *array = @[@"btn－微信",@"btn－朋友圈",@"btn－QQ",@"btn－信息"];
    CGFloat w = 41;
    CGFloat h = 31;
    CGFloat jianju = ([UIScreen mainScreen].bounds.size.width - (w * 4))/5;
    CGFloat y = ningdeLabel.frame.size.height + ningdeLabel.frame.origin.y + 20;
    for (int i = 0; i < array.count; i ++) {
        CGFloat x =(i + 1) * jianju + (w * i);
        UIButton *btn = [[UIButton alloc]initWithFrame:CGRectMake(x, y, w, h)];
        btn.tag = i;
        NSString *str = array[i];
        [btn setImage:[UIImage imageNamed:str] forState:UIControlStateNormal];
        [btn addTarget:self action:@selector(dianjiyaoqinganniu:) forControlEvents:UIControlEventTouchUpInside];
        [view addSubview:btn];
    }
    //已经获得金额
    UIView *jingeView = [[UIView alloc] initWithFrame:CGRectMake(0, view.frame.size.height + view.frame.origin.y + 10, [UIScreen mainScreen].bounds.size.width, 100)];
    jingeView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:jingeView];
    //金额
    //人数
}
#pragma mark - 点击按钮
-(void)dianjiyaoqinganniu:(UIButton *)btn{
    if (btn.tag == 0) {
        
    }else if (btn.tag == 1) {
    
    } else if (btn.tag == 2) {
    
    }else if (btn.tag == 3) {
    
    }
}
@end
