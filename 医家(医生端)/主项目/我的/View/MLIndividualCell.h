//
//  MLIndividualCell.h
//  医家(医生端)
//
//  Created by 洛耳 on 15/7/10.
//  Copyright (c) 2015年 workorz. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol  MLIndividualCellDelegate <NSObject>
@optional
-(void)dianjierweima;
@end
@interface MLIndividualCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *image;
@property (weak, nonatomic) IBOutlet UILabel *name;
@property (weak, nonatomic) IBOutlet UILabel *yaoqingma;
@property (nonatomic, weak) id<MLIndividualCellDelegate> delegate;

@end
