//
//  MLMyPromptCell.m
//  医家(医生端)
//
//  Created by 洛耳 on 15/7/10.
//  Copyright (c) 2015年 workorz. All rights reserved.
//

#import "MLMyPromptCell.h"
#import "UIButton+Badge.h"

@interface MLMyPromptCell()
@property (weak, nonatomic) IBOutlet UIButton *jiaobiao;

@end

@implementation MLMyPromptCell
-(void)setJiaobiaoInt:(NSInteger)jiaobiaoInt{
    _jiaobiaoInt = jiaobiaoInt;
    NSString *str = [NSString stringWithFormat:@"%ld",(long)jiaobiaoInt];
    if (jiaobiaoInt > 20) {
        str = [NSString stringWithFormat:@"20+"];
    }
    if (jiaobiaoInt == 0) {
        return;
    }
    self.jiaobiao.badgeValue = str;
}
- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
