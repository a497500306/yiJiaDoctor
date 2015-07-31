//
//  MLWalletModel.h
//  医家(医生端)
//
//  Created by 洛耳 on 15/7/22.
//  Copyright (c) 2015年 workorz. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MLWalletModel : NSObject
/**
 *  状态码
 */
@property (nonatomic ,copy)NSString *statusCode;
/**
 *  信息代码
 */
@property (nonatomic ,copy)NSString *code;
/**
 *  信息
 */
@property (nonatomic ,copy)NSString *message;
/**
 *  账户总额
 */
@property (nonatomic ,copy)NSString *accountAmount;
/**
 *  取款密码
 */
@property (nonatomic ,copy)NSString *password;
/**
 *  数组
 */
@property (nonatomic ,strong)NSArray *list;
@end
