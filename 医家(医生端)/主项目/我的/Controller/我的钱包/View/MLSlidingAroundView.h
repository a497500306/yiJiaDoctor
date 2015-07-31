//
//  MLSlidingAroundView.h
//  医家(医生端)
//
//  Created by 洛耳 on 15/7/22.
//  Copyright (c) 2015年 workorz. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MLSlidingAroundView : UIView
/**
 *  传入头部按钮标题数组(btn)
 */
@property (nonatomic ,strong)NSMutableArray *btnNumber;
/**
 *  传入头部按钮标题数组
 */
@property (nonatomic ,strong)NSMutableArray *boundarys;
/**
 *  view数组
 */
@property (nonatomic ,strong)NSMutableArray *views;
/**
 *  普通状态下得字体
 */
@property (nonatomic ,strong)UIColor *textColor;
/**
 *  选中状态下得字体
 */
@property (nonatomic ,strong)UIColor *selectedTextColor;
/**
 *  初始化设置
 *
 *  @param btnNumber 头部按钮标题数组
 */
-(void)slidingAroundBtnNumber:(NSArray *)btnNumber;
@end
