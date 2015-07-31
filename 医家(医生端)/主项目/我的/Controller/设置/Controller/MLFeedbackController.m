//
//  MLFeedbackController.m
//  医家(医生端)
//
//  Created by 洛耳 on 15/7/21.
//  Copyright (c) 2015年 workorz. All rights reserved.
//

#import "MLFeedbackController.h"
#import "IWTextView.h"
#import "MBProgressHUD+MJ.h"
#import "IWHttpTool.h"
#import "MLUserInfo.h"
#import "MLDizhiModel.h"
#import "MJExtension.h"
#import "MLInterface.h"

@interface MLFeedbackController ()<IWTextViewDelegate>
@property (nonatomic, weak)IWTextView *textView;
@property (nonatomic ,copy)NSString *str;


@end

@implementation MLFeedbackController

- (void)viewDidLoad {
    [super viewDidLoad];
    //添加单击退出键盘
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] init];
    tap.numberOfTapsRequired = 1;
    [tap addTarget:self action:@selector(danji)];
    [self.view addGestureRecognizer:tap];
    self.title = @"意见反馈";
    self.view.backgroundColor = [UIColor colorWithRed:239/255.0 green:239/255.0 blue:239/255.0 alpha:1];
    //设置右上角提交按钮
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"提交" style:UIBarButtonItemStylePlain target:self action:@selector(dianjitijiao)];
    //创建第二个框
    IWTextView *field = [[IWTextView alloc] init];
    field.frame  = CGRectMake(10 , 10, [UIScreen mainScreen].bounds.size.width - 20 , 250);
    field.placeholder = @"填写意见反馈";
    field.delegate = self;
    self.textView = field;
    [self.view addSubview:field];
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, -10, field.frame.size.width, 10)];
    view.backgroundColor = self.view.backgroundColor;
    [field addSubview:view];
    
}
#pragma mark - 点击提交
-(void)dianjitijiao{
    [[MLUserInfo sharedMLUserInfo] loadUserInfoFromSanbox];
    NSString *url = [MLInterface sharedMLInterface].saveFeedback;
    NSDictionary *dict = @{@"token":[MLUserInfo sharedMLUserInfo].token,@"content":self.str};
    [IWHttpTool postWithURL:url params:dict success:^(id json) {
        MLDizhiModel *dm = [MLDizhiModel objectWithKeyValues:json];
        if ([dm.statusCode isEqualToString:@"200"]) {
            [MBProgressHUD showSuccess:@"提交成功" toView:self.view];
        }
    } failure:^(NSError *error) {
        
    }];
}
#pragma mark - 输入文字代理方法
-(void)shuruleduoshaowenzi:(NSString *)wenzi{
    self.str = wenzi;
}
#pragma mark - 单击退出键盘
-(void)danji{
    [self.view endEditing:YES];
}
@end
