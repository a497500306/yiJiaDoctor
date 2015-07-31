//
//  MLIndividualCell.m
//  医家(医生端)
//
//  Created by 洛耳 on 15/7/10.
//  Copyright (c) 2015年 workorz. All rights reserved.
//

#import "MLIndividualCell.h"

@implementation MLIndividualCell

- (void)awakeFromNib {
    //圆角
    self.image.layer.cornerRadius = 24;
    self.image.layer.masksToBounds = YES;
    // Initialization code
}
- (IBAction)dianjierweima:(id)sender {
    [self.delegate dianjierweima];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
