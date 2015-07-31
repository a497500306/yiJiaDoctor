//
//  MLMailistCell.m
//  医家(医生端)
//
//  Created by 洛耳 on 15/7/16.
//  Copyright (c) 2015年 workorz. All rights reserved.
//

#import "MLMailistCell.h"

@interface MLMailistCell()
@property (nonatomic ,weak)UIImageView *myImageView;
@property (nonatomic ,weak)UILabel *namuText;
@end

@implementation MLMailistCell

- (void)awakeFromNib {
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
-(void)cellImage:(UIImage *)image andName:(NSString *)text{
    //图片
    UIImageView *myImageView = [[UIImageView alloc] init];
    myImageView.frame = CGRectMake(15, 5, 40, 40);
    [self.contentView addSubview:myImageView];
    //text
    UILabel *nameText = [[UILabel alloc] initWithFrame:CGRectMake(65, 0, 200, 60)];
    self.namuText = nameText;
    nameText.font = [UIFont systemFontOfSize:14];
    nameText.textColor = [UIColor blackColor];
    [self.contentView addSubview:nameText];
    self.imageView.image = image;
    self.namuText.text = text;
    //两根线
    UIView *xian1 = [[UIView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 0.5)];
    xian1.backgroundColor = [UIColor colorWithRed:217/255.0 green:217/255.0 blue:217/255.0 alpha:1];
    self.shangxian = xian1;
    [self.contentView addSubview:xian1];
    UIView *xian2 = [[UIView alloc] initWithFrame:CGRectMake(0, 59.5, [UIScreen mainScreen].bounds.size.width, 0.5)];
    xian2.backgroundColor = [UIColor colorWithRed:217/255.0 green:217/255.0 blue:217/255.0 alpha:1];
    self.xiaxian =xian2;
    [self.contentView addSubview:xian2];
    
}
@end
