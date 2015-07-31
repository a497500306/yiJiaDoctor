//
//  MLImageNameCell.h
//  医家(医生端)
//
//  Created by 洛耳 on 15/7/17.
//  Copyright (c) 2015年 workorz. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MLImageNameCell : UITableViewCell
@property (nonatomic ,weak)UIImageView *zhengjian;
@property (nonatomic ,weak)UIImageView *touxiang;
-(void)image:(UIImage *)image andName:(NSString *)text andZhengjian:(UIImage *)zhengjian andNianling:(NSString *)nianling andXingbie:(NSString *)xingbie;
@end
