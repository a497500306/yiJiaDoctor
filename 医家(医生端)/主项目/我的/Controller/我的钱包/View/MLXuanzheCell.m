//
//  MLXuanzheCell.m
//  医家(医生端)
//
//  Created by 洛耳 on 15/7/23.
//  Copyright (c) 2015年 workorz. All rights reserved.
//

#import "MLXuanzheCell.h"
#import "UIImageView+WebCache.h"
#define wenzidaxiao 17
@interface MLXuanzheCell ()
@property (nonatomic ,weak)UIImageView *image;
@property (nonatomic ,weak)UILabel *name;
@property (nonatomic ,weak)UILabel *haoma;
@property (nonatomic ,weak)UIButton *xianzhe;
@end

@implementation MLXuanzheCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        UIImageView *image = [[UIImageView alloc] init];
        self.image = image;
        [self.contentView addSubview:image];
        UILabel *name = [[UILabel alloc] init];
        name.font = [UIFont systemFontOfSize:wenzidaxiao];
        self.name = name;
        [self.contentView addSubview:name];
        UILabel *haoma = [[UILabel alloc] init];
        haoma.font = [UIFont systemFontOfSize:15];
        haoma.textColor = [UIColor colorWithRed:175/255.0 green:175/255.0 blue:175/255.0 alpha:1];
        self.haoma = haoma;
        [self.contentView addSubview:haoma];
        UIButton *btn = [[UIButton alloc] init];
        [btn setImage:[UIImage imageNamed:@"btn－勾"] forState:UIControlStateSelected];
        self.xianzhe = btn;
        [self.contentView addSubview:btn];
        
    }
    return self;
}
-(void)cellName:(NSString *)name andImageURL:(NSString *)url andHaoma:(NSString *)haoma andBtn:(BOOL)isBtn andBankOfZfb:(NSString *)bankZfb{
    self.image.frame = CGRectMake(5, 5, 40, 40);
    NSURL *url1 = [NSURL URLWithString:url];
    [self.image sd_setImageWithURL:url1 placeholderImage:[UIImage imageNamed:@"icon－银行默认图"]];
    
    //设置name
    //计算文字大小
    NSDictionary *attrs = @{NSFontAttributeName:[UIFont systemFontOfSize:wenzidaxiao]};
    CGSize nameMaxSize = CGSizeMake(200, 50);
    CGSize nameSize = [name boundingRectWithSize:nameMaxSize options:NSStringDrawingUsesLineFragmentOrigin attributes:attrs context:nil].size;
    self.name.frame = CGRectMake(self.image.frame.origin.x + self.image.frame.size.width + 10, 0, nameSize.width, 50);
    self.name.text = name;
    NSString *haomaStr = nil;
    if ([bankZfb isEqualToString:@"bank"]) {
        //取出后四位
        NSString *weihao = [haoma substringWithRange:NSMakeRange(haoma.length - 4, 4)];
        haomaStr = [NSString stringWithFormat:@"尾号%@",weihao];
        self.haoma.text = haomaStr;
    }else{
        self.haoma.text = haoma;
    }
    //设置haoma
    NSDictionary *attrs1 = @{NSFontAttributeName:[UIFont systemFontOfSize:15]};
    CGSize haomaMaxSize = CGSizeMake(100, 50);
    CGSize haomaSize = [haoma boundingRectWithSize:haomaMaxSize options:NSStringDrawingUsesLineFragmentOrigin attributes:attrs1 context:nil].size;
    self.haoma.frame = CGRectMake(self.name.frame.size.width + self.name.frame.origin.x + 20, 0, haomaSize.width, 50);
    //设置勾
    self.xianzhe.frame = CGRectMake([UIScreen mainScreen].bounds.size.width - 12 - 10, (50 - 9)/2, 12, 9);
    self.xianzhe.selected = isBtn;
}
@end
