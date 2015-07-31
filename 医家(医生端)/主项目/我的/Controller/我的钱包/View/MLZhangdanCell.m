//
//  MLZhangdanCell.m
//  医家(医生端)
//
//  Created by 洛耳 on 15/7/22.
//  Copyright (c) 2015年 workorz. All rights reserved.
//

#import "MLZhangdanCell.h"


@interface MLZhangdanCell ()
@property (nonatomic ,weak)UILabel *neirong;
@property (nonatomic ,weak)UILabel *shijian;
@property (nonatomic ,weak)UILabel *qian;
@property (nonatomic ,weak)UILabel *zhuangtai;
@end

@implementation MLZhangdanCell
-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        UILabel *neirong = [[UILabel alloc] init];
        neirong.textColor = [UIColor blackColor];
        neirong.font = [UIFont systemFontOfSize:16];
        self.neirong = neirong;
        [self.contentView addSubview:neirong];
        UILabel *shijian = [[UILabel alloc] init];
        shijian.textColor = [UIColor colorWithRed:208/255.0 green:208/255.0 blue:208/255.0 alpha:1];
        shijian.font = [UIFont systemFontOfSize:13];
        self.shijian = shijian;
        [self.contentView addSubview:shijian];
        UILabel *qian = [[UILabel alloc] init];
        qian.textColor = [UIColor blackColor];
        qian.font = [UIFont systemFontOfSize:16];
        qian.textAlignment = NSTextAlignmentRight;
        self.qian = qian;
        [self.contentView addSubview:qian];
        UILabel *zhuangtai = [[UILabel alloc] init];
        zhuangtai.textColor = [UIColor colorWithRed:208/255.0 green:208/255.0 blue:208/255.0 alpha:1];
        zhuangtai.font = [UIFont systemFontOfSize:13];
        zhuangtai.textAlignment = NSTextAlignmentRight;
        self.zhuangtai = zhuangtai;
        [self.contentView addSubview:zhuangtai];
    }
    return self;
}
-(void)cellNeirong:(NSString *)neirong andShijian:(NSString *)shijian andQian:(NSString *)qian andZhuangtai:(NSString *)zhuangtai{
    //内容
    self.neirong.frame = CGRectMake(10, 5, [UIScreen mainScreen].bounds.size.width / 2 + 100, 20);
    self.neirong.text = neirong;
    //时间
    self.shijian.frame = CGRectMake(10, self.neirong.frame.size.height + 5, [UIScreen mainScreen].bounds.size.width / 2 + 100, 20);
    self.shijian.text = shijian;
    //钱
    self.qian.frame = CGRectMake(self.neirong.frame.size.width + 10, 5, [UIScreen mainScreen].bounds.size.width / 2 - 100 - 20, 20);
    self.qian.text = qian;
    //状态
    self.zhuangtai.frame =CGRectMake(self.qian.frame.origin.x, self.neirong.frame.size.height + 5, self.qian.frame.size.width, self.qian.frame.size.height);
    self.zhuangtai.text = zhuangtai;
}
@end