//
//  MLUserTongxunluTool.h
//  医家(医生端)
//
//  Created by 洛耳 on 15/7/16.
//  Copyright (c) 2015年 workorz. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Singleton.h"
@interface MLUserTongxunluTool : NSObject
singleton_interface(MLUserTongxunluTool);
/**
 *  患者数
 */
@property (nonatomic, copy) NSString *huanzheshu;
/**
 *  患者角标
 */
@property (nonatomic, copy) NSString *huanzhejiaobiao;
/**
 *  新朋友数
 */
@property (nonatomic, copy) NSString *xinpengyoushu;
/**
 *  新朋友角标
 */
@property (nonatomic, copy) NSString *xinpengyoujiaobiao;
/**
 *  朋友圈数
 */
@property (nonatomic, copy) NSString *pengyouquanshu;
/**
 *  朋友圈角标
 */
@property (nonatomic, copy) NSString *pengyouquanjiaobiao;

/**
 *  从沙盒里获取用户数据
 */
-(void)loadUserInfoFromSanbox;

/**
 *  保存用户数据到沙盒
 
 */
-(void)saveUserInfoToSanbox;




@end
