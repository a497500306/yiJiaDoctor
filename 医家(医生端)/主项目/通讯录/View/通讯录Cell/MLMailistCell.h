//
//  MLMailistCell.h
//  医家(医生端)
//
//  Created by 洛耳 on 15/7/16.
//  Copyright (c) 2015年 workorz. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MLMailistCell : UITableViewCell
@property (nonatomic ,weak)UIView *shangxian;
@property (nonatomic ,weak)UIView *xiaxian;
-(void)cellImage:(UIImage *)image andName:(NSString *)text;
@end
