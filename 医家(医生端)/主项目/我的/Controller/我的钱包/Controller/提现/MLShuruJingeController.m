//
//  MLShuruJingeController.m
//  医家(医生端)
//
//  Created by 洛耳 on 15/7/23.
//  Copyright (c) 2015年 workorz. All rights reserved.
//

#import "MLShuruJingeController.h"
#import "MLWalletModel.h"
#import "MLXuanzheTixianController.h"
#import "MBProgressHUD+MJ.h"
#import "IWHttpTool.h"
#import "MLUserInfo.h"
#import "MJExtension.h"
#import "MLInterface.h"

@interface MLShuruJingeController ()<UITextFieldDelegate>
@property (nonatomic ,weak)UITextField *field;
@property (nonatomic ,weak)UIButton *btn;
@end

@implementation MLShuruJingeController
-(NSMutableArray *)array{
    if (_array == nil) {
        _array = [NSMutableArray array];
        return _array;
    }
    return _array;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"钱币提现";
    //初始化
    [self chushihua];
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    //网络获取数据
    NSString *url = [MLInterface sharedMLInterface].getWalletByToken;
    [[MLUserInfo sharedMLUserInfo] loadUserInfoFromSanbox];
    NSDictionary *dict = @{@"token":[MLUserInfo sharedMLUserInfo].token};
    [IWHttpTool postWithURL:url params:dict success:^(id json) {
        MLWalletModel *model = [MLWalletModel objectWithKeyValues:json];
        self.walletM = model;
        //设置提示文字
        NSMutableDictionary *attrs1 = [NSMutableDictionary dictionary];
        attrs1[NSForegroundColorAttributeName] = [UIColor colorWithRed:196/255.0 green:196/255.0 blue:196/255.0 alpha:1];
        NSString *str = [NSString stringWithFormat:@"当前账户共有%@元",self.walletM.accountAmount];
        self.field.attributedPlaceholder = [[NSAttributedString alloc] initWithString:str attributes:attrs1];
    } failure:^(NSError *error) {
        [MBProgressHUD showError:@"请检查网络" toView:self.view];
    }];
}
#pragma mark - 初始化
-(void)chushihua{
    self.view.backgroundColor = [UIColor colorWithRed:239/255.0 green:239/255.0 blue:239/255.0 alpha:1];
    //金额(元)
    UILabel *lable = [[UILabel alloc] initWithFrame:CGRectMake(10, 20, 90, 50)];
    lable.text = @"金额 (元) :";
    lable.font = [UIFont systemFontOfSize:18];
    [self.view addSubview:lable];
    //输入框
    UITextField *field = [[UITextField alloc] initWithFrame:CGRectMake(lable.frame.size.width + lable.frame.origin.x + 5, lable.frame.origin.y, [UIScreen mainScreen].bounds.size.width - lable.frame.size.width - 10 - 5 - 10, lable.frame.size.height)];
    field.font = [UIFont systemFontOfSize:18];
    //设置提示文字
    NSMutableDictionary *attrs1 = [NSMutableDictionary dictionary];
    attrs1[NSForegroundColorAttributeName] = [UIColor colorWithRed:196/255.0 green:196/255.0 blue:196/255.0 alpha:1];
    NSString *str = [NSString stringWithFormat:@"当前账户共有%@元",self.walletM.accountAmount];
    field.attributedPlaceholder = [[NSAttributedString alloc] initWithString:str attributes:attrs1];
    field.tintColor = [UIColor blueColor];
    field.delegate = self;
    [self.view addSubview:field];
    //弹出数字键盘
    field.keyboardType = UIKeyboardTypeNumberPad;
    self.field = field;
    //线
    UIView *xian = [[UIView alloc] initWithFrame:CGRectMake(field.frame.origin.x, field.frame.origin.y + field.frame.size.height - 10, field.frame.size.width, 1)];
    xian.backgroundColor = [UIColor colorWithRed:221/255.0 green:221/255.0 blue:221/255.0 alpha:1];
    [self.view addSubview:xian];
    //添加下一步按钮
    UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(20, field.frame.origin.y + field.frame.size.height + 10, [UIScreen mainScreen].bounds.size.width - 40, 40)];
    [btn setTitle:@"下一步" forState:UIControlStateNormal];
    [btn setBackgroundColor:[UIColor grayColor]];
    [btn addTarget:self action:@selector(dianjixiayibu) forControlEvents:UIControlEventTouchUpInside];
    btn.layer.cornerRadius = 3;
    btn.layer.masksToBounds = YES;
    btn.enabled = NO;
    self.btn = btn;
    [self.view addSubview:btn];
}

#pragma mark - 判断输入的内容
-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    NSMutableString *shuruStr = [NSMutableString stringWithString:textField.text];
    if (range.length == 1 ) {//删除
        [shuruStr deleteCharactersInRange:range];
    }else{
        [shuruStr insertString:string atIndex:range.location];
    }
    NSLog(@"%@",shuruStr);
    CGFloat zonge = [self.walletM.accountAmount floatValue];
    CGFloat shuru = [shuruStr floatValue];
    if (shuru > zonge) {
        self.field.textColor = [UIColor redColor];
        [self.btn setBackgroundColor:[UIColor grayColor]];
        self.btn.enabled = NO;
    }else{
        self.field.textColor = [UIColor blackColor];
        [self.btn setBackgroundColor:[UIColor colorWithRed:35/255.0 green:120/255.0 blue:240/255.0 alpha:1]];
        self.btn.enabled = YES;
    }
    if (shuruStr.length == 0) {
        self.btn.enabled = NO;
        [self.btn setBackgroundColor:[UIColor grayColor]];
    }
    return YES;
}

#pragma mark - 点击下一步
-(void)dianjixiayibu{
    MLXuanzheTixianController *tianjiaC = [[MLXuanzheTixianController alloc] init];
    tianjiaC.jine = self.field.text;
    tianjiaC.array =self.array;
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStyleDone target:nil action:nil];
    [self.navigationController pushViewController:tianjiaC animated:YES];
}
@end
