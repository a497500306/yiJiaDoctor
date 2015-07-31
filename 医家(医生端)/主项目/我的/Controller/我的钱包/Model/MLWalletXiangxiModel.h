//
//  MLWalletXiangxiModel.h
//  医家(医生端)
//
//  Created by 洛耳 on 15/7/22.
//  Copyright (c) 2015年 workorz. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MLWalletXiangxiModel : NSObject
/**
 *  银行卡或支付宝账号
 */
@property (nonatomic ,copy)NSString *account;
@property (nonatomic ,copy)NSString *createTime;
/**
 *
 */
@property (nonatomic ,copy)NSString *disabled;
@property (nonatomic ,copy)NSString *email;
/**
 *  支付宝或银行卡ID
 */
@property (nonatomic ,copy)NSString *ID;
@property (nonatomic ,copy)NSString *isDefault;
@property (nonatomic ,copy)NSString *mobile;
@property (nonatomic ,copy)NSString *modifedTime;
@property (nonatomic ,copy)NSString *type;
@property (nonatomic ,copy)NSString *userId;
/**
 *  用户姓名
 */
@property (nonatomic ,copy)NSString *userName;
/**
 *  支付宝或者银行卡名
 */
@property (nonatomic ,copy)NSString *name;
@end
