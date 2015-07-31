//
//  MLErweimaView.m
//  医家(医生端)
//
//  Created by 洛耳 on 15/7/24.
//  Copyright (c) 2015年 workorz. All rights reserved.
//

#import "MLErweimaView.h"
#import "UIImageView+WebCache.h"
#import "MLMyModel.h"
#import "MLGenderAgeView.h"
#define wenzidaxiao 17
@implementation MLErweimaView
-(void)erweimaURL:(MLMyModel *)mm{
    //添加单击退出
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] init];
    tap.numberOfTapsRequired = 1;
    [tap addTarget:self action:@selector(danji)];
    [self addGestureRecognizer:tap];

    UIView *BG = [[UIView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    BG.alpha = 0.5;
    BG.backgroundColor = [UIColor blackColor];
    [self addSubview:BG];
    //显示框
    UIView *xianshi = [[UIView alloc] initWithFrame:CGRectMake(30, 64 + 10, [UIScreen mainScreen].bounds.size.width - 60, 430)];
    xianshi.backgroundColor = [UIColor whiteColor];
    [self addSubview:xianshi];
    //头像
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(20, 20, 60, 60)];
    NSURL *url1 = [NSURL URLWithString:[NSString stringWithFormat:@"http://rolle.cn:8080%@",mm.headImage]];
    [imageView sd_setImageWithURL:url1 placeholderImage:[UIImage imageNamed:@"icon－默认头像"]];
    //圆角
    imageView.layer.cornerRadius = 30;
    imageView.layer.masksToBounds = YES;
    [xianshi addSubview:imageView];
    //名字
    //计算文字大小
    NSDictionary *attrs = @{NSFontAttributeName:[UIFont systemFontOfSize:wenzidaxiao]};
    CGSize nameMaxSize = CGSizeMake(300, 30);
    CGSize nameSize = [mm.nickname boundingRectWithSize:nameMaxSize options:NSStringDrawingUsesLineFragmentOrigin attributes:attrs context:nil].size;
    UILabel *nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(imageView.frame.size.width + imageView.frame.origin.x + 10, imageView.frame.origin.y + (imageView.frame.size.height/2) - 10, nameSize.width, nameSize.height)];
    nameLabel.font = [UIFont systemFontOfSize:wenzidaxiao];
    nameLabel.text = mm.nickname;
    [xianshi addSubview:nameLabel];
    //年龄性别属性
    MLGenderAgeView *ag = [[MLGenderAgeView alloc] initWithFrame:CGRectMake(nameLabel.frame.origin.x + nameLabel.frame.size.width + 5, nameLabel.frame.origin.y + 2, 20, 20)];
    //取出年龄和性别
    NSString *xingbie = nil;
    if ([mm.sex isEqualToString:@"1"]) {//性别
        xingbie = @"男";
    }else{
        xingbie = @"女";
    }
    //两个日期之间相隔多少秒
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat: @"yyyy-MM-dd"];
    NSDate *destDate= [dateFormatter dateFromString:mm.birthday];
    NSTimeInterval secondsInterval= [[NSDate date] timeIntervalSinceDate:destDate];
    NSTimeInterval nian = secondsInterval / 60 / 60 /24 / 365;
    NSInteger nianling = nian / 1;
    NSString *nianlingStr = [NSString stringWithFormat:@"%ld",(long)nianling];
    [ag age:nianlingStr andGender:xingbie];
    [xianshi addSubview:ag];
    //二维码图片
    UIImageView *erweimaImageView = [[UIImageView alloc] initWithFrame:CGRectMake(imageView.frame.origin.x, imageView.frame.origin.y +imageView.frame.size.height + 20, xianshi.frame.size.width - 40, xianshi.frame.size.width - 40)];
    [erweimaImageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://rolle.cn:8080%@",mm.qrCode]] placeholderImage:[UIImage imageNamed:@"icon－二维码默认图"]];
    [xianshi addSubview:erweimaImageView];
    //加我
    UILabel *jiawo = [[UILabel alloc] initWithFrame:CGRectMake(20, erweimaImageView.frame.origin.y + erweimaImageView.frame.size.height + 4, xianshi.frame.size.width - 40, 40)];
    jiawo.text = @"扫一扫上面二维码图案,加我~";
    jiawo.font = [UIFont systemFontOfSize:20];
    [xianshi addSubview:jiawo];
}
-(void)danji{
    [UIView animateWithDuration:0.3 animations:^{
        self.alpha = 0;
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}
@end
