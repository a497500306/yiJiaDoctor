//
//  MLHuangzheXuetangCell.m
//  医家(医生端)
//
//  Created by 洛耳 on 15/7/29.
//  Copyright (c) 2015年 workorz. All rights reserved.
//

#import "MLHuangzheXuetangCell.h"

#define zhiti 13;
@interface MLHuangzheXuetangCell()
@property(nonatomic ,weak)UILabel *lable;
@end

@implementation MLHuangzheXuetangCell
-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        UILabel *lable = [[UILabel alloc] init];
        lable.font = [UIFont systemFontOfSize:13];
        lable.textAlignment = NSTextAlignmentCenter;
        self.lable = lable;
        [self addSubview:lable];
        //线
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, [UIScreen mainScreen].bounds.size.width / 9, [UIScreen mainScreen].bounds.size.width / 9, 0.5)];
        view.backgroundColor = [UIColor colorWithRed:220/255.0 green:220/255.0 blue:220/255.0 alpha:1];
        [self.lable addSubview:view];
        //线2
        UIView *xian2 =[[UIView alloc] initWithFrame:CGRectMake(0, 0, 0.5, [UIScreen mainScreen].bounds.size.width / 9)];
        xian2.backgroundColor = [UIColor colorWithRed:210/255.0 green:210/255.0 blue:210/255.0 alpha:1];
        [self.lable addSubview:xian2];
    }
    return self;
}
-(void)lableText:(NSString *)text andYanse:(UIColor *)color{
    self.lable.frame =CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width / 9, [UIScreen mainScreen].bounds.size.width / 9);
    self.lable.text = text;
    self.lable.textColor = color;
}
@end
