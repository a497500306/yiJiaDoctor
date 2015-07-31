//
//  MLChongzhiMimaController.m
//  医家(医生端)
//
//  Created by 洛耳 on 15/7/23.
//  Copyright (c) 2015年 workorz. All rights reserved.
//

#import "MLChongzhiMimaController.h"
#import "MBProgressHUD+MJ.h"
#import "IWHttpTool.h"
#import "MLUserInfo.h"
#import "MJExtension.h"
#import "MLInterface.h"
#import "ZSDPaymentView.h"
#import "MD5Tool.h"
#import "MLDizhiModel.h"
#define chongfashijian 60
#define zhiti 17

@interface MLChongzhiMimaController ()<ZSDPaymentViewDelegate>
/**
 *  验证码Field
 */
@property (nonatomic ,weak)UITextField *yanzhemaField;
/**
 *  手机Field
 */
@property (nonatomic ,weak)UITextField *shoujiField;
/**
 *  密码Field
 */
@property (nonatomic ,weak)UITextField *mimaField;
/**
 *  重发Btn
 */
@property (nonatomic ,weak)UIButton *chongfaBtn;
/**
 *  重发定时器
 */
@property (nonatomic,strong) NSTimer *chongfaTimer;
/**
 *  重发时间计时
 */
@property (nonatomic, assign)NSInteger shijianjishi;
@property (nonatomic ,weak)ZSDPaymentView *payment;

@end

@implementation MLChongzhiMimaController

- (void)viewDidLoad {
    [super viewDidLoad];
    //标题
    self.title = @"重置支付密码";
    //初始化
    [self chushihua];
}
-(void)chushihua{
    //创建背景图片
    UIImageView *bg = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    bg.userInteractionEnabled = YES;
    bg.backgroundColor = [UIColor colorWithRed:239/255.0 green:239/255.0 blue:239/255.0 alpha:1];
    //添加单击退出键盘
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] init];
    tap.numberOfTapsRequired = 1;
    [tap addTarget:self action:@selector(danji)];
    [bg addGestureRecognizer:tap];
    [self.view addSubview:bg];
    //创建对话框
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(10 , 10 , self.view.frame.size.width - 20, 40)];
    imageView.userInteractionEnabled = YES;
    imageView.backgroundColor = [UIColor whiteColor];
    //圆角
    imageView.layer.cornerRadius = 3;
    imageView.layer.masksToBounds = YES;
    [self.view addSubview:imageView];
    //输入手机号
    UITextField *shoujiField = [[UITextField alloc] initWithFrame:CGRectMake(10, 0, imageView.frame.size.width - 10, 40)];
    self.shoujiField = shoujiField;
    shoujiField.textColor = [UIColor blackColor];
    //设置提示文字
    NSMutableDictionary *attrs1 = [NSMutableDictionary dictionary];
    attrs1[NSForegroundColorAttributeName] = [UIColor colorWithRed:196/255.0 green:196/255.0 blue:196/255.0 alpha:1];
    shoujiField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"手机码" attributes:attrs1];
    shoujiField.font = [UIFont systemFontOfSize:zhiti];
    //设置清除按钮
    shoujiField.clearButtonMode = UITextFieldViewModeAlways;
    //弹出数字键盘
    shoujiField.keyboardType = UIKeyboardTypeNumberPad;
    shoujiField.tintColor = [UIColor colorWithRed:34/255.0 green:119/255.0 blue:240/255.0 alpha:1];
    [imageView addSubview:shoujiField];
    //创建验证码对话框
    UIImageView *imageView1= [[UIImageView alloc] initWithFrame:CGRectMake(10 , imageView.frame.origin.y + imageView.frame.size.height + 10, self.view.frame.size.width - 20, 40)];
    imageView1.userInteractionEnabled = YES;
    imageView1.backgroundColor = [UIColor whiteColor];
    //圆角
    imageView1.layer.cornerRadius = 3;
    imageView1.layer.masksToBounds = YES;
    [self.view addSubview:imageView1];
    //输入验证码
    UITextField *yanzhenmaField = [[UITextField alloc] initWithFrame:CGRectMake(10, 0, imageView.frame.size.width - 100, 40)];
    self.yanzhemaField = yanzhenmaField;
    yanzhenmaField.textColor = [UIColor blackColor];
    //设置提示文字
    NSMutableDictionary *attrs = [NSMutableDictionary dictionary];
    attrs[NSForegroundColorAttributeName] = [UIColor colorWithRed:196/255.0 green:196/255.0 blue:196/255.0 alpha:1];
    yanzhenmaField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"验证码" attributes:attrs];
    yanzhenmaField.font = [UIFont systemFontOfSize:zhiti];
    yanzhenmaField.tintColor = [UIColor colorWithRed:34/255.0 green:119/255.0 blue:240/255.0 alpha:1];
    //设置清除按钮
    yanzhenmaField.clearButtonMode = UITextFieldViewModeAlways;
    //弹出数字键盘
    yanzhenmaField.keyboardType = UIKeyboardTypeNumberPad;
    [imageView1 addSubview:yanzhenmaField];
    //发送验证码
    UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(imageView.frame.size.width - 90, 0, 90, 40)];
    btn.backgroundColor = [UIColor colorWithRed:34/255.0 green:119/255.0 blue:240/255.0 alpha:1];
    [btn setTitle:@"发送验证码" forState:UIControlStateNormal];
    btn.titleLabel.font = [UIFont systemFontOfSize:15];
    [btn addTarget:self action:@selector(dianjimeishoudao) forControlEvents:UIControlEventTouchUpInside];
    [imageView1 addSubview:btn];
    self.chongfaBtn = btn;
    //创建验证码对话框
    UIImageView *imageView2= [[UIImageView alloc] initWithFrame:CGRectMake(10 , imageView1.frame.origin.y + imageView1.frame.size.height + 10, self.view.frame.size.width - 20, 40)];
    imageView2.userInteractionEnabled = YES;
    imageView2.backgroundColor = [UIColor whiteColor];
    //圆角
    imageView2.layer.cornerRadius = 3;
    imageView2.layer.masksToBounds = YES;
    [self.view addSubview:imageView2];
    //设置确定按钮
    UIButton *queding = [[UIButton alloc] initWithFrame:CGRectMake(10, imageView2.frame.size.height + imageView2.frame.origin.y + 10 - 40 - 10, self.view.frame.size.width - 20, 40)];
    [queding setTitle:@"确定" forState:UIControlStateNormal];
    queding.titleLabel.font = [UIFont systemFontOfSize:20.0];
    [queding setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [queding addTarget:self action:@selector(dianjixiayibu) forControlEvents:UIControlEventTouchUpInside];
    queding.backgroundColor = [UIColor colorWithRed:34/255.0 green:119/255.0 blue:240/255.0 alpha:1];
    queding.tag = 100;
    [queding.layer setBorderWidth:1.0f];
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGColorRef colorref = CGColorCreate(colorSpace,(CGFloat[]){ 34/255.0,119/255.0, 240/255.0,1.0 });
    [queding.layer setBorderColor:colorref];
    //圆角
    queding.layer.cornerRadius = 3;
    queding.layer.masksToBounds = YES;
    [self.view addSubview:queding];
}
#pragma mark - 重发定时器
-(void)chongfadingshiqi{
    self.shijianjishi = self.shijianjishi + 1;
    NSString *str = [NSString stringWithFormat:@"%lds后重发",chongfashijian-self.shijianjishi];
    [self.chongfaBtn setTitle:str forState:UIControlStateNormal];
    if (self.shijianjishi == chongfashijian) {
        self.shijianjishi = 0 ;
        [self.chongfaTimer invalidate];
        self.chongfaTimer = nil;
        [self.chongfaBtn setTitle:@"没收到?" forState:UIControlStateNormal];
        self.chongfaBtn.backgroundColor = [UIColor colorWithRed:34/255.0 green:119/255.0 blue:240/255.0 alpha:1];
        //btn可以点击
        self.chongfaBtn.userInteractionEnabled = YES;
    }
}
#pragma mark - 点击重发
-(void)dianjimeishoudao{
    if (self.shoujiField.text.length != 11) {
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:nil message:@"请输入正确的手机号" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
        [alert show];
        return ;
    }
    self.chongfaBtn.backgroundColor = [UIColor colorWithRed:200/255.0 green:200/255.0 blue:200/255.0 alpha:1];
    self.shijianjishi = 0;
    self.chongfaBtn.userInteractionEnabled = NO;
    //创建重发定时器
    self.chongfaTimer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(chongfadingshiqi) userInfo:nil repeats:YES];
    //网络发送验证码
    NSString *url = @"http://192.168.1.88:8080/crm/wallet_sp/sendVerifycode.json";
    [[MLUserInfo sharedMLUserInfo] loadUserInfoFromSanbox];
    NSDictionary *parameters = @{@"token":[MLUserInfo sharedMLUserInfo].token};
    [IWHttpTool postWithURL:url params:parameters success:^(id json) {
        NSLog(@"%@",json[@"message"]);
    } failure:^(NSError *error) {//检查网络
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:nil message:@"请检查您的网络" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
        [alert show];
    }];
}
#pragma mark - 点击下一步
-(void)dianjixiayibu{
    if (self.shoujiField.text.length != 11 && self.yanzhemaField.text.length != 4) {
        [MBProgressHUD showError:@"请输入正确的信息" toView:self.view];
        return;
    }
    //弹出输入密码界面
    ZSDPaymentView *payment = [[ZSDPaymentView alloc]init];
    payment.title = @"支付密码";
    payment.goodsName = @"设置6位数的提现密码";
    payment.isChongzhi = NO;
    //                payment.amount = [self.jine floatValue];
    payment.delegate = self;
    self.payment = payment;
    [payment show];
}
-(void)mimashurucuowu{
    [self.payment dismiss];
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:nil message:@"请输入纯数字密码" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
    [alert show];

}
-(void)mimashuruwangbi:(NSString *)str{
    [self.payment dismiss];
    //网络获取
    NSString *url = [MLInterface sharedMLInterface].updatePasswordWithdrawals;
    [[MLUserInfo sharedMLUserInfo] loadUserInfoFromSanbox];
    NSString *passString = [MD5Tool md5:[str stringByAppendingString:@"rolle"]];
    NSDictionary *dict = @{@"token":[MLUserInfo sharedMLUserInfo].token,@"password":passString,@"verifycode":self.yanzhemaField.text};
    [IWHttpTool postWithURL:url params:dict success:^(id json) {
        MLDizhiModel *model = [MLDizhiModel objectWithKeyValues:json];
        if ([model.statusCode isEqualToString:@"200"]) {
            [MBProgressHUD showSuccess:@"修改成功" toView:self.view];
            //延时1秒
            [self performSelector:@selector(delayMethod) withObject:nil afterDelay:1.0f];
        }else{
            [MBProgressHUD showError:model.message toView:self.view];
        }
    } failure:^(NSError *error) {
        
    }];
}
-(void)delayMethod{
    [self.navigationController popViewControllerAnimated:YES];
}
#pragma mark - 单击退出键盘
-(void)danji{
    [self.view endEditing:YES];
}
@end
