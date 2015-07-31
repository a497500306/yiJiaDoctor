//
//  MLNavigationController.m
//  医家(医生端)
//
//  Created by 洛耳 on 15/7/16.
//  Copyright (c) 2015年 workorz. All rights reserved.
//

#import "MLNavigationController.h"

@interface MLNavigationController ()

@end

@implementation MLNavigationController
-(void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated{
    viewController.hidesBottomBarWhenPushed = YES;
}
@end
