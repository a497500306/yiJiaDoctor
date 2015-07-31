//
//  MLSearchBox.m
//  医家(医生端)
//
//  Created by 洛耳 on 15/7/16.
//  Copyright (c) 2015年 workorz. All rights reserved.
//

#import "MLSearchBox.h"


@interface MLSearchBox()<UITextFieldDelegate>
/**
 *  输入背景
 */
@property(nonatomic ,weak)UIView *bg;
/**
 *  搜索图片
 */
@property(nonatomic ,weak)UIImageView *image;
/**
 *  取消Btn
 */
@property (nonatomic ,weak)UIButton *btn;
@end

@implementation MLSearchBox

-(void)chuangjianSearchBox{
    //背景
    self.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 44);
    self.backgroundColor = [UIColor colorWithRed:239/255.0 green:239/255.0 blue:239/255.0 alpha:1];
    //搜索背景
    UIView *bg = [[UIView alloc] initWithFrame:CGRectMake(10, 7, self.frame.size.width - 20, 30)];
    bg.backgroundColor = [UIColor whiteColor];
    //圆角
    bg.layer.cornerRadius = 3;
    bg.layer.masksToBounds = YES;
    [self addSubview:bg];
    self.bg = bg;
    //搜索图片
    UIImageView *image = [[UIImageView alloc] initWithFrame:CGRectMake(bg.frame.size.width *0.5 - 25, 9, 16, 16)];
    image.image = [UIImage imageNamed:@"btn－搜索"];
    [bg addSubview:image];
    self.image = image;
    //创建搜索Text
    UITextField *text = [[UITextField alloc] initWithFrame:CGRectMake(image.frame.origin.x + image.frame.size.width + 5, 5, 100, 25)];
    text.tintColor = [UIColor blueColor];
    text.delegate = self;
    //设置提示文字
    NSMutableDictionary *attrs1 = [NSMutableDictionary dictionary];
    attrs1[NSForegroundColorAttributeName] = [UIColor colorWithRed:196/255.0 green:196/255.0 blue:196/255.0 alpha:1];
    text.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"搜索" attributes:attrs1];
    text.textColor = [UIColor blackColor];
    text.font = [UIFont systemFontOfSize:15];
    [bg addSubview:text];
    self.text = text;
    //创建取消按钮
    UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(bg.frame.size.width + bg.frame.origin.x + 10, bg.frame.origin.y, 40, bg.frame.size.height)];
    [btn setTitle:@"取消" forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor colorWithRed:1/255.0 green:134/255.0 blue:108/255.0 alpha:1] forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(dianjiquxiao) forControlEvents:UIControlEventTouchUpInside];
    self.btn = btn;
    [self addSubview:btn];
}
#pragma mark - 点击取消
-(void)dianjiquxiao{
    [UIView animateWithDuration:0.2 animations:^{
        self.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 44);
        self.bg.frame = CGRectMake(10, 7, self.frame.size.width - 20, 30);
        self.image.frame = CGRectMake(self.bg.frame.size.width *0.5 - 25, 9, 16, 16);
        self.text.frame = CGRectMake(self.image.frame.origin.x + self.image.frame.size.width + 5, 5, 100, 25);
        self.text.text = nil;
        self.btn.frame = CGRectMake(self.bg.frame.size.width + self.bg.frame.origin.x + 10, self.bg.frame.origin.y, 40, self.bg.frame.size.height);
        [self endEditing:YES];
    }];
    [self.delegate dianjiquxiao];
}
#pragma mark - 开始编辑时触发
-(void)textFieldDidBeginEditing:(UITextField *)textField{
    [self.delegate jijiangdonghua];
    [UIView animateWithDuration:0.2 animations:^{
        self.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 64);
        self.bg.frame = CGRectMake(10, 27, self.frame.size.width - 20 - 50, 30);
        self.image.frame = CGRectMake(5, 9, 16, 16);
        self.text.frame = CGRectMake(self.image.frame.origin.x + self.image.frame.size.width + 5, 5, 300, 25);
        self.btn.frame = CGRectMake(self.bg.frame.size.width + self.bg.frame.origin.x + 10, self.bg.frame.origin.y, 40, self.bg.frame.size.height);
    }];
}
@end
