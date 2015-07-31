//
//  MLHuangzheCell.m
//  医家(医生端)
//
//  Created by 洛耳 on 15/7/27.
//  Copyright (c) 2015年 workorz. All rights reserved.
//

#import "MLHuangzheCell.h"
#import "NSDate+MLDate.h"
#import "UIImageView+WebCache.h"
#import "MLGenderAgeView.h"
#define daziti 16
#define xiaoziti 14
@interface MLHuangzheCell ()
@property (nonatomic ,weak)UIImageView *touxiang;
@property (nonatomic ,weak)UILabel *name;
@property (nonatomic ,weak)UILabel *yanzhong;
@property (nonatomic ,weak)MLGenderAgeView *ga;
/**
 *  最高血糖
 */
@property (nonatomic ,weak)UILabel *zuigaoxuetang;
/**
 *  最低血糖
 */
@property (nonatomic ,weak)UILabel *zuidixuetang;
@property (nonatomic ,weak)UIImageView *zuidiImage;
@property (nonatomic ,weak)UIImageView *zuigaoImage;
@property (nonatomic ,weak)UIView *xian;
/**
 * 医生圈Cell内容
 */
@property (nonatomic ,weak)UILabel *neirong;
@end

@implementation MLHuangzheCell


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
        //添加性别年龄
        MLGenderAgeView *ga = [[MLGenderAgeView alloc] init];
        self.ga = ga;
        [self.contentView addSubview:ga];
        //严重
        UILabel *yanzhong =[[UILabel alloc] init];
        yanzhong.font = [UIFont systemFontOfSize:xiaoziti];
        yanzhong.textColor = [UIColor colorWithRed:238/255.0 green:108/255.0 blue:154 alpha:54/255.0];
        self.yanzhong = yanzhong;
        //最高血糖图片
        UIImageView *zuigaoImage = [[UIImageView alloc] init];
        zuigaoImage.image = [UIImage imageNamed:@"icon－往上"];
        self.zuigaoImage = zuigaoImage;
        //最高血糖
        UILabel *zuigaoxuetang = [[UILabel alloc] init];
        zuigaoxuetang.font = [UIFont systemFontOfSize:xiaoziti];
        zuigaoxuetang.textColor = [UIColor colorWithRed:181/255.0 green:180/255.0 blue:180/255.0 alpha:1];
        self.zuigaoxuetang = zuigaoxuetang;
        //最低血糖图片
        UIImageView *zuidiImage = [[UIImageView alloc] init];
        zuidiImage.image = [UIImage imageNamed:@"icon－往下"];
        self.zuidiImage = zuidiImage;
        //最低血糖
        UILabel *zuidixuetang = [[UILabel alloc] init];
        zuidixuetang.font = [UIFont systemFontOfSize:xiaoziti];
        zuidixuetang.textColor = [UIColor colorWithRed:181/255.0 green:180/255.0 blue:180/255.0 alpha:1];
        self.zuidixuetang = zuidixuetang;
        //线
        UIView *xian = [[UIView alloc] init];
        xian.backgroundColor = [UIColor colorWithRed:214/255.0 green:214/255.0 blue:214/255.0 alpha:1];
        self.xian =xian;
        //内容
        UILabel *neirong = [[UILabel alloc] init];
        neirong.font = [UIFont systemFontOfSize:xiaoziti];
        neirong.textColor = [UIColor colorWithRed:181/255.0 green:180/255.0 blue:180/255.0 alpha:1];
        self.neirong = neirong;
        [self.contentView addSubview:neirong];
        [self.contentView addSubview:xian];
        [self.contentView addSubview:touxiang];
        [self.contentView addSubview:name];
        [self.contentView addSubview:zuigaoxuetang];
        [self.contentView addSubview:zuidixuetang];
        [self.contentView addSubview:zuidiImage];
        [self.contentView addSubview:zuigaoImage];
    }
    return self;
}
-(void)cellTouxiangURL:(NSString *)url andName:(NSString *)name andNianling:(NSString *)nianling andXingbie:(NSString *)xingbie andZuigaoXuetang:(NSString *)zuigao andZuidiXuetang:(NSString *)zuidi andYanzhong:(NSString *)yanzhong{
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
    //是否严重
    if ([yanzhong isEqualToString:@"121"]) {
        self.yanzhong.frame = CGRectMake(self.ga.frame.size.width + self.ga.frame.origin.x + 5, self.ga.frame.origin.y, 50, 20);
        self.yanzhong.text = @"严重";
    }
    //最高图片
    self.zuigaoImage.frame = CGRectMake(self.name.frame.origin.x, self.name.frame.origin.y + self.name.frame.size.height + 5 , 3.5, 13);
    //最高文字
    self.zuigaoxuetang.frame = CGRectMake(self.zuigaoImage.frame.origin.x + self.zuigaoImage.frame.size.width + 3, self.zuigaoImage.frame.origin.y , 120, 13);
    NSString *zuigaoStr = [NSString stringWithFormat:@"最高血糖:%@",zuigao];
    self.zuigaoxuetang.text = zuigaoStr;
    
    //最高图片
    self.zuidiImage.frame = CGRectMake(self.zuigaoxuetang.frame.origin.x + self.zuigaoxuetang.frame.size.width + 5, self.zuigaoxuetang.frame.origin.y  , 3.5, 13);
    //最高文字
    self.zuidixuetang.frame = CGRectMake(self.zuidiImage.frame.origin.x + self.zuidiImage.frame.size.width + 3, self.zuigaoImage.frame.origin.y, 120, 13);
    NSString *zuidiStr = [NSString stringWithFormat:@"最低血糖:%@",zuidi];
    self.zuidixuetang.text = zuidiStr;
}
-(void)cellTouxiangURL:(NSString *)url andName:(NSString *)name andNianling:(NSString *)nianling andXingbie:(NSString *)xingbie andKeshi:(NSString *)keshi{
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
    self.neirong.frame = CGRectMake(self.name.frame.origin.x, self.name.frame.origin.y + self.name.frame.size.height + 10 , [UIScreen mainScreen].bounds.size.width - self.touxiang.frame.size.width - self.touxiang.frame.origin.y - 20, 13);
    self.neirong.text = keshi;
}
@end
