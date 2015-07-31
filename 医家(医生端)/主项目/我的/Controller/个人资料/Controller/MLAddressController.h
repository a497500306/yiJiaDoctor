//
//  MLAddressController.h
//  医家(医生端)
//
//  Created by 洛耳 on 15/7/20.
//  Copyright (c) 2015年 workorz. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MLAddressController : UIViewController
@property (nonatomic ,copy)NSString *ID;
/**
 *  地区级别
 */
@property (nonatomic ,assign)NSInteger jibie;
/**
 *  地区级别
 */
@property (nonatomic ,copy)NSString *dizhi;
@end
