//
//  MLMyPromptCell.h
//  医家(医生端)
//
//  Created by 洛耳 on 15/7/10.
//  Copyright (c) 2015年 workorz. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MLMyPromptCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *imageIcon;
@property (weak, nonatomic) IBOutlet UILabel *text;
@property (assign, nonatomic) NSInteger jiaobiaoInt;

@end
