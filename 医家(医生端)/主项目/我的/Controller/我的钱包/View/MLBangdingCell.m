//
//  MLBangdingCell.m
//  医家(医生端)
//
//  Created by 洛耳 on 15/7/22.
//  Copyright (c) 2015年 workorz. All rights reserved.
//

#import "MLBangdingCell.h"
#import "UIImageView+WebCache.h"

@interface MLBangdingCell()
@property(nonatomic ,weak)UILabel *chikaren;

@end

@implementation MLBangdingCell
-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        UILabel *chikaren = [[UILabel alloc] init];
        chikaren.font = [UIFont systemFontOfSize:14];
        chikaren.textColor = [UIColor colorWithRed:190/255.0 green:190/244.0 blue:190/255.0 alpha:1];
        chikaren.textAlignment = NSTextAlignmentRight;
        self.chikaren = chikaren;
        [self.contentView addSubview:chikaren];
    }
    return self;
}

-(void)cellName:(NSString *)name andHaoma:(NSString *)haoma andImageURL:(NSString *)imageURL andUserNmae:(NSString *)useName andBankOfZfb:(NSString *)bankZfb{
    NSURL *url = [NSURL URLWithString:imageURL];
    [self.imageView sd_setImageWithURL:url placeholderImage:[UIImage imageNamed:@"icon－银行默认图"]];
    self.textLabel.text = name;
    NSString *weihao = [haoma substringWithRange:NSMakeRange(haoma.length - 4, 4)];
    NSString *str = [NSString stringWithFormat:@"尾号:%@",weihao];
    if ([bankZfb isEqualToString:@"bank"]) {
        self.detailTextLabel.text = str;
    }else{
        self.detailTextLabel.text = haoma;
    }
    self.detailTextLabel.textColor = [UIColor colorWithRed:190/255.0 green:190/244.0 blue:190/255.0 alpha:1];
    //创建持卡人按钮
     self.chikaren.frame = CGRectMake([UIScreen mainScreen].bounds.size.width - 165, 20, 150, 30);
    NSString *qiequchikaren = [useName substringWithRange:NSMakeRange(1, useName.length - 1)];
    NSString *str1 = [NSString stringWithFormat:@"持卡人:※%@",qiequchikaren];
    self.chikaren.text = str1;
}
@end
