//
//  MLGenderAgeView.h
//  医家(医生端)
//
//  Created by 洛耳 on 15/7/17.
//  Copyright (c) 2015年 workorz. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MLGenderAgeView : UIView
/**
 *  设置年龄性别
 *
 *  @param age    年龄
 *  @param gender 性别
 */
-(void)age:(NSString *)age andGender:(NSString *)gender;
@end
