//
//  MLShoudongShuruController.m
//  医家(医生端)
//
//  Created by 洛耳 on 15/7/23.
//  Copyright (c) 2015年 workorz. All rights reserved.
//

#import "MLShoudongShuruController.h"

@interface MLShoudongShuruController ()<UITextFieldDelegate>
@property (nonatomic ,weak)UITextField *chikerenField;
@property (nonatomic ,weak)UITextField *kahaoField;
@property (nonatomic ,weak)UIButton *btn;

@end

@implementation MLShoudongShuruController

- (void)viewDidLoad {
    [super viewDidLoad];
    //添加单击退出键盘
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] init];
    tap.numberOfTapsRequired = 1;
    [tap addTarget:self action:@selector(danji)];
    [self.view addGestureRecognizer:tap];
    self.title = @"输入银行卡";
    self.view.backgroundColor = [UIColor colorWithRed:239/255.0 green:239/255.0 blue:239/255.0 alpha:1];
    //初始化
    [self chushihua];
}

-(void)chushihua{
    //提示文字
    UILabel *tishi = [[UILabel alloc] initWithFrame:CGRectMake(10, 10, [UIScreen mainScreen].bounds.size.width - 10, 20)];
    tishi.text = @"本次验证信息仅用于提现,请使用持卡人本人的储蓄卡";
    tishi.textColor = [UIColor colorWithRed:160/255.0 green:160/255.0 blue:160/255.0 alpha:1];
    tishi.font = [UIFont systemFontOfSize:12];
    [self.view addSubview:tishi];
    //设置背景
    UIView *BG = [[UIView alloc] initWithFrame:CGRectMake(0, tishi.frame.size.height + tishi.frame.origin.y, [UIScreen mainScreen].bounds.size.width, 103)];
    BG.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:BG];
    //设置线
    UIView *xian1 = [[UIView alloc] initWithFrame:CGRectMake(0, tishi.frame.size.height + tishi.frame.origin.y, [UIScreen mainScreen].bounds.size.width, 1)];
    xian1.backgroundColor = [UIColor colorWithRed:223/255.0 green:223/255.0 blue:223/255.0 alpha:1];
    [self.view addSubview:xian1];
    //设置持卡人
    UILabel *chikeren = [[UILabel alloc] initWithFrame:CGRectMake(0, xian1.frame.origin.y + 1, 70, 50)];
    chikeren.textAlignment = NSTextAlignmentRight;
    chikeren.text = @"持卡人:";
    [self.view addSubview:chikeren];
    //持卡人输入窗口
    UITextField *chikerenField = [[UITextField alloc] initWithFrame:CGRectMake(chikeren.frame.origin.x + chikeren.frame.size.width + 10, chikeren.frame.origin.y, self.view.frame.size.width - chikeren.frame.size.width - chikeren.frame.origin.x - 20, chikeren.frame.size.height)];
    chikerenField.delegate = self;
    chikerenField.textColor = [UIColor blackColor];
    chikerenField.tintColor = [UIColor colorWithRed:34/255.0 green:120/255.0 blue:240/255.0 alpha:1];
    [self.view addSubview:chikerenField];
    //设置提示文字
    NSMutableDictionary *attrs = [NSMutableDictionary dictionary];
    attrs[NSForegroundColorAttributeName] = [UIColor colorWithRed:196/255.0 green:196/255.0 blue:196/255.0 alpha:1];
    chikerenField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"开户姓名" attributes:attrs];
    //设置清除按钮
    chikerenField.clearButtonMode = UITextFieldViewModeAlways;
    self.chikerenField = chikerenField;
    //线2
    UIView *xian2 = [[UIView alloc] initWithFrame:CGRectMake(0, chikerenField.frame.size.height + chikerenField.frame.origin.y, [UIScreen mainScreen].bounds.size.width, 1)];
    xian2.backgroundColor = [UIColor colorWithRed:223/255.0 green:223/255.0 blue:223/255.0 alpha:1];
    [self.view addSubview:xian2];
    //设置卡号
    UILabel *kahao = [[UILabel alloc] initWithFrame:CGRectMake(0, xian2.frame.origin.y + 1, 70, 50)];
    kahao.textAlignment = NSTextAlignmentRight;
    kahao.text = @"卡号:";
    [self.view addSubview:kahao];
    //卡号输入框
    UITextField *kahaoField = [[UITextField alloc] initWithFrame:CGRectMake(kahao.frame.origin.x + kahao.frame.size.width + 10, kahao.frame.origin.y, self.view.frame.size.width - kahao.frame.size.width - kahao.frame.origin.x - 20, chikeren.frame.size.height)];
    kahaoField.delegate = self;
    //弹出数字键盘
    kahaoField.keyboardType = UIKeyboardTypeNumberPad;
    kahaoField.textColor = [UIColor blackColor];
    kahao.tintColor = [UIColor colorWithRed:34/255.0 green:120/255.0 blue:240/255.0 alpha:1];
    [self.view addSubview:kahaoField];
    //设置提示文字
    NSMutableDictionary *attrs1 = [NSMutableDictionary dictionary];
    attrs1[NSForegroundColorAttributeName] = [UIColor colorWithRed:196/255.0 green:196/255.0 blue:196/255.0 alpha:1];
    kahaoField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"银行卡号" attributes:attrs1];
    //设置清除按钮
    kahaoField.clearButtonMode = UITextFieldViewModeAlways;
    self.kahaoField = kahaoField;
    //设置线3
    UIView *xian3 = [[UIView alloc] initWithFrame:CGRectMake(0, kahaoField.frame.size.height + kahaoField.frame.origin.y, [UIScreen mainScreen].bounds.size.width, 1)];
    xian3.backgroundColor = [UIColor colorWithRed:223/255.0 green:223/255.0 blue:223/255.0 alpha:1];
    [self.view addSubview:xian3];
    //设置确定按钮
    UIButton *loginButton = [UIButton buttonWithType:UIButtonTypeSystem];
    loginButton.frame = CGRectMake(10, xian3.frame.size.height + xian3.frame.origin.y + 15 , [UIScreen mainScreen].bounds.size.width - 30, 40);
    [loginButton setTitle:@"下一步" forState:UIControlStateNormal];
    loginButton.titleLabel.font = [UIFont systemFontOfSize:20.0];
    [loginButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [loginButton addTarget:self action:@selector(dianjixiayibu) forControlEvents:UIControlEventTouchUpInside];
    loginButton.tag = 100;
//    [loginButton.layer setBorderWidth:1.0f];
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGColorRef colorref = CGColorCreate(colorSpace,(CGFloat[]){ 1.0,1.0, 1.0,1.0 });
    [loginButton.layer setBorderColor:colorref];
    //圆角
    loginButton.layer.cornerRadius = 3;
    loginButton.layer.masksToBounds = YES;
    self.btn = loginButton;
    self.btn.enabled = NO;
    [self.btn setBackgroundColor:[UIColor grayColor]];
    [self.view addSubview:loginButton];
}

#pragma mark - 单击退出键盘
-(void)danji{
    [self.view endEditing:YES];
}
#pragma mark - 点击下一步
-(void)dianjixiayibu{
    
}
#pragma mark - 输入代理方法
-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    if ([string isEqualToString:@"\n"]) {
        return YES;
    }
    if (self.chikerenField.text.length == 0 && self.kahaoField.text.length == 0) {
        self.btn.enabled = NO;
        [self.btn setBackgroundColor:[UIColor grayColor]];
        
    }else{
        self.btn.enabled = YES;
        self.btn.backgroundColor = [UIColor colorWithRed:34/255.0 green:120/255.0 blue:240/255.0 alpha:1];
    }
    return YES;
}
@end
