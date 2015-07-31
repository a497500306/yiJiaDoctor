//
//  MLPinglunLiebiaoCell.m
//  医家(医生端)
//
//  Created by 洛耳 on 15/7/23.
//  Copyright (c) 2015年 workorz. All rights reserved.
//

#import "MLPinglunLiebiaoCell.h"
#import "MLGenderAgeView.h"
#import "UIImageView+WebCache.h"
#import "NSDate+MLDate.h"
#define daziti 16
#define xiaoziti 14
@interface MLPinglunLiebiaoCell ()
@property (nonatomic ,weak)UIImageView *touxiang;
@property (nonatomic ,weak)UILabel *name;
@property (nonatomic ,weak)UILabel *shijian;
@property (nonatomic ,weak)UILabel *neirong;
@property (nonatomic ,weak)MLGenderAgeView *ga;
@property (nonatomic ,weak)UIView *xian;
@end

@implementation MLPinglunLiebiaoCell
-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        //添加头像
        UIImageView *touxiang = [[UIImageView alloc] init];
        touxiang.layer.cornerRadius = 25;
        touxiang.layer.masksToBounds = YES;
        self.touxiang = touxiang;
        //添加name
        UILabel *name =[[UILabel alloc] init];
        name.font = [UIFont systemFontOfSize:daziti];
        name.textColor = [UIColor blackColor];
        self.name = name;
        //添加时间
        UILabel *shijian = [[UILabel alloc] init];
        shijian.font = [UIFont systemFontOfSize:xiaoziti];
        shijian.textColor = [UIColor colorWithRed:181/255.0 green:180/255.0 blue:180/255.0 alpha:1];
        self.shijian = shijian;
        //添加性别年龄
        MLGenderAgeView *ga = [[MLGenderAgeView alloc] init];
        self.ga = ga;
        //添加内容
        UILabel *neirong = [[UILabel alloc] init];
        neirong.font = [UIFont systemFontOfSize:daziti];
        neirong.textColor = [UIColor colorWithRed:120/255.0 green:120/255.0 blue:120/255.0 alpha:1];
        self.neirong.numberOfLines = 0;
        self.neirong = neirong;
        //线
        UIView *xian = [[UIView alloc] init];
        xian.backgroundColor = [UIColor colorWithRed:214/255.0 green:214/255.0 blue:214/255.0 alpha:1];
        self.xian =xian;
        [self.contentView addSubview:xian];
        [self.contentView addSubview:touxiang];
        [self.contentView addSubview:name];
        [self.contentView addSubview:shijian];
        [self.contentView addSubview:ga];
        [self.contentView addSubview:neirong];
    }
    return self;
}
-(void)cellTouxiangURL:(NSString *)url andName:(NSString *)name andShijian:(NSString *)shijian andNianling:(NSString *)nianling andXingbie:(NSString *)xingbie andNeirong:(NSString *)neirong{
    self.xian.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 0.5);
    self.touxiang.frame = CGRectMake(10, 10, 50, 50);
    NSURL *url1 = [NSURL URLWithString:url];
    [self.touxiang sd_setImageWithURL:url1 placeholderImage:[UIImage imageNamed:@"icon－默认头像"]];
    //计算名字的长度
    NSDictionary *attrs = @{NSFontAttributeName : [UIFont systemFontOfSize:daziti]};
    CGSize nameMaxSize = CGSizeMake(200, 20);
    CGSize nameSize = [name boundingRectWithSize:nameMaxSize options:NSStringDrawingUsesFontLeading attributes:attrs context:nil].size;
    self.name.frame = CGRectMake(self.touxiang.frame.origin.x + self.touxiang.frame.size.width + 5, self.touxiang.frame.origin.y + 5, nameSize.width, 20);
    self.name.text = name;
    //性别年龄属性
    self.ga.frame = CGRectMake(self.name.frame.origin.x + self.name.frame.size.width + 5, self.name.frame.origin.y + 2, 16, 16);
    [self.ga age:nianling andGender:xingbie];
    //设置时间
    NSDate *date = [NSDate dateWithTimeIntervalInMilliSecondSince1970:[shijian doubleValue]];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd"];
    NSString *str = [formatter stringFromDate:date];
    //计算时间长度
    NSDictionary *attrs1 = @{NSFontAttributeName : [UIFont systemFontOfSize:xiaoziti]};
    CGSize shijianMaxSize = CGSizeMake(200, 20);
    CGSize shijianSize = [str boundingRectWithSize:shijianMaxSize options:NSStringDrawingUsesFontLeading attributes:attrs1 context:nil].size;
    self.shijian.frame = CGRectMake(self.name.frame.origin.x, self.name.frame.origin.y + self.name.frame.size.height , shijianSize.width, self.name.frame.size.height);
    self.shijian.text = str;
    //设置内容
    //计算内容的长度
    CGSize neirongMaxSize = CGSizeMake([UIScreen mainScreen].bounds.size.width - 20, 300);
    CGSize neirongSize = [str boundingRectWithSize:neirongMaxSize options:NSStringDrawingUsesFontLeading attributes:attrs context:nil].size;
    self.neirong.frame = CGRectMake(10, self.touxiang.frame.size.height + self.touxiang.frame.origin.y + 5, [UIScreen mainScreen].bounds.size.width - 40, 20);
    self.neirong.text = neirong;
}
@end
