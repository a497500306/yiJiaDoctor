//
//  MLPersonalDataController.h
//  医家(医生端)
//
//  Created by 洛耳 on 15/7/17.
//  Copyright (c) 2015年 workorz. All rights reserved.
//

#import <UIKit/UIKit.h>
@class MLMyModel;

@interface MLPersonalDataController : UIViewController
@property (nonatomic ,strong)MLMyModel *mm;
@property (nonatomic ,weak)UITableView *table;
@end
