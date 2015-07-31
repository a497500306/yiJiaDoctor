//
//  MLImageNameCell.m
//  医家(医生端)
//
//  Created by 洛耳 on 15/7/17.
//  Copyright (c) 2015年 workorz. All rights reserved.
//

#import "MLImageNameCell.h"
#import "MLGenderAgeView.h"
#define zhiti 16
@interface MLImageNameCell()
@property (nonatomic ,weak)UILabel *name;
@property (nonatomic ,weak)MLGenderAgeView *xingbienianling;
@end


@implementation MLImageNameCell
- (instancetype)init
{
    self = [super init];
    if (self) {
        //添加和初始化必须要得控件
        //头像
        UIImageView *touxiang = [[UIImageView alloc] init];
        //圆角
        touxiang.layer.cornerRadius = 25;
        touxiang.layer.masksToBounds = YES;
        self.touxiang = touxiang;
        [self.contentView addSubview:touxiang];
        //name
        UILabel *name = [[UILabel alloc] init];
        name.font = [UIFont systemFontOfSize:zhiti];
        self.name = name;
        [self.contentView addSubview:name];
        //证件
        UIImageView *zhengjian = [[UIImageView alloc] init];
        self.zhengjian = zhengjian;
        [self.contentView addSubview:zhengjian];
        //性别年龄
        MLGenderAgeView *ga = [[MLGenderAgeView alloc] init];
        self.xingbienianling = ga;
        [self.contentView addSubview:ga];
        
    }
    return self;
}
-(void)image:(UIImage *)image andName:(NSString *)text andZhengjian:(UIImage *)zhengjian andNianling:(NSString *)nianling andXingbie:(NSString *)xingbie{
    self.touxiang.frame = CGRectMake(10, 5, 50, 50);
    self.touxiang.image = image;
    //计算名字的长度
    NSDictionary *attrs = @{NSFontAttributeName : [UIFont systemFontOfSize:zhiti]};
    CGSize nameMaxSize = CGSizeMake(200, 60);
    CGSize nameSize = [text boundingRectWithSize:nameMaxSize options:NSStringDrawingUsesFontLeading attributes:attrs context:nil].size;
    CGFloat nameY =( 60 - nameSize.height ) / 2;
    self.name.frame = CGRectMake(self.touxiang.frame.origin.x + self.touxiang.frame.size.width + 10, nameY, nameSize.width, nameSize.height);
    self.name.text = text;
    //设置年龄跟性别
    self.xingbienianling.frame = CGRectMake(self.name.frame.size.width + self.name.frame.origin.x + 5, self.name.frame.origin.y, 40, nameSize.height);
    [self.xingbienianling age:nianling andGender:xingbie];
    //设置证件位置
//    self.zhengjian.frame = CGRectMake(self.frame.size.width - 10 - 55, 7.5, 55, 45);
//    self.zhengjian.image = zhengjian;
}
@end
