//
//  MLTheNewsController.m
//  医家(医生端)
//
//  Created by 洛耳 on 15/7/9.
//  Copyright (c) 2015年 workorz. All rights reserved.
//

#import "MLTheNewsController.h"

@interface MLTheNewsController ()

@end

@implementation MLTheNewsController

- (void)viewDidLoad {
    [super viewDidLoad];
    //不透明
    self.navigationController.navigationBar.translucent = NO;
    UITabBarItem* item = [self.tabBarController.tabBar.items objectAtIndex:0];
    item.selectedImage = [UIImage imageNamed:@"btn－消息选中"];
}

@end
