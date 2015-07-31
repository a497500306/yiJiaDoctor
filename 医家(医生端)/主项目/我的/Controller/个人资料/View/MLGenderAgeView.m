//
//  MLGenderAgeView.m
//  医家(医生端)
//
//  Created by 洛耳 on 15/7/17.
//  Copyright (c) 2015年 workorz. All rights reserved.
//

#import "MLGenderAgeView.h"
#define zhiti 13
@implementation MLGenderAgeView

-(void)age:(NSString *)age andGender:(NSString *)gender{
    if (age.length == 0 || age == nil) {
        self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y, 48, 18);
        self.backgroundColor = [UIColor colorWithRed:230/255.0 green:230/255.0 blue:230/255.0 alpha:1];
        UILabel * a = [[UILabel alloc] initWithFrame:self.bounds];
        a.textColor = [UIColor whiteColor];
        a.text = @"未设置";
        a.font = [UIFont systemFontOfSize:15];
        [self addSubview:a];
        return;
    }
    if (gender.length == 0 || age == nil) {
        self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y, 48, 18);
        self.backgroundColor = [UIColor colorWithRed:230/255.0 green:230/255.0 blue:230/255.0 alpha:1];
        UILabel * a = [[UILabel alloc] initWithFrame:self.bounds];
        a.text = @"未设置";
        a.font = [UIFont systemFontOfSize:15];
        [self addSubview:a];
        return;
    }
    //添加性别图片
    UIImageView *image = [[UIImageView alloc] init];
    //设置背景颜色
    if ([gender isEqualToString:@"男"]) {
        self.backgroundColor = [UIColor colorWithRed:104/255.0 green:184/255.0 blue:222/255.0 alpha:1];
        image.image = [UIImage imageNamed:@"icon－男"];
    }else{
        self.backgroundColor = [UIColor colorWithRed:242/255.0 green:164/255.0 blue:169/255.0 alpha:1];
        image.image = [UIImage imageNamed:@"icon－女"];
    }
    //圆角
    self.layer.cornerRadius = 3;
    self.layer.masksToBounds = YES;
    image.frame = CGRectMake((self.frame.size.height - 15) / 2 + 1, (self.frame.size.height - 15) / 2 + 2, 11, 11);
    [self addSubview:image];
    //计算年龄宽度
    NSString *shui = [NSString stringWithFormat:@"%@岁",age];
    NSDictionary *attrs = @{NSFontAttributeName : [UIFont systemFontOfSize:zhiti]};
    CGSize nameMaxSize = CGSizeMake(200, 60);
    CGSize nameSize = [shui boundingRectWithSize:nameMaxSize options:NSStringDrawingUsesFontLeading attributes:attrs context:nil].size;
    //创建年龄
    UILabel *nianling = [[UILabel alloc] initWithFrame:CGRectMake(image.frame.size.width + 5, 0, nameSize.width, self.frame.size.height)];
    nianling.textColor = [UIColor whiteColor];
    nianling.font = [UIFont systemFontOfSize:zhiti];
    nianling.text = shui;
    [self addSubview:nianling];
    self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y, image.frame.size.width + image.frame.origin.x + nianling.frame.size.width + 7, self.frame.size.height);
}

@end
