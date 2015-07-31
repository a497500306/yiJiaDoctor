//
//  MLXianxiDizhiController.m
//  医家(医生端)
//
//  Created by 洛耳 on 15/7/30.
//  Copyright (c) 2015年 workorz. All rights reserved.
//

#import "MLXianxiDizhiController.h"

@interface MLXianxiDizhiController ()
@property (nonatomic ,weak)UITextField *field;

@end

@implementation MLXianxiDizhiController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"详细地址";
    //设置右上角完成按钮
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"完成" style:UIBarButtonItemStylePlain target:self action:@selector(dianjiwangcheng)];
    //设置左上角取消按钮
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"取消" style:UIBarButtonItemStylePlain target:self action:@selector(dianjiquxiao)];
    self.view.backgroundColor = [UIColor whiteColor];
    //创建text
    UITextField *field = [[UITextField alloc] initWithFrame:CGRectMake(10, 84, [UIScreen mainScreen].bounds.size.width - 20, 44)];
    //设置清除按钮
    field.clearButtonMode = UITextFieldViewModeAlways;
    //设置提示文字
    NSMutableDictionary *attrs1 = [NSMutableDictionary dictionary];
    attrs1[NSForegroundColorAttributeName] = [UIColor colorWithRed:196/255.0 green:196/255.0 blue:196/255.0 alpha:1];
    field.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"请输入详细地址" attributes:attrs1];
    self.field = field;
    [self.view addSubview:field];
    //创建两根线
    UIView *xian1 = [[UIView alloc] initWithFrame:CGRectMake(0, 83, self.view.frame.size.width, 0.5)];
    xian1.backgroundColor = [UIColor colorWithRed:211/255.0 green:211/255.0 blue:211/255.0 alpha:1];
    [self.view addSubview:xian1];
    //创建两根线
    UIView *xian2 = [[UIView alloc] initWithFrame:CGRectMake(0, 84 + 44 + 1, self.view.frame.size.width, 0.5)];
    xian2.backgroundColor = [UIColor colorWithRed:211/255.0 green:211/255.0 blue:211/255.0 alpha:1];
    [self.view addSubview:xian2];
}

#pragma mark - 点击完成
-(void)dianjiwangcheng{
    [self dismissViewControllerAnimated:YES completion:nil];
    //设置完成,发送通知
    NSNotificationCenter *center = [NSNotificationCenter defaultCenter];
    NSDictionary *dict = @{@"地址":self.dizhi,@"ID":self.ID,@"详细地址":self.field.text};
    [center postNotificationName:@"地址" object:self userInfo:dict];
    [self dismissViewControllerAnimated:YES completion:nil];

}
#pragma mark - 点击取消
-(void)dianjiquxiao{
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
