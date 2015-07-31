//
//  MLZhangdanXiangxiModel.h
//  医家(医生端)
//
//  Created by 洛耳 on 15/7/22.
//  Copyright (c) 2015年 workorz. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MLZhangdanXiangxiModel : NSObject
@property (nonatomic ,copy)NSString *accountAmount;
/**
 *  金额
 */
@property (nonatomic ,copy)NSString *accountAmountChange;
/**
 *  交易类型
 */
@property (nonatomic ,copy)NSString *codeName;
@property (nonatomic ,copy)NSString *frozenAmount;
@property (nonatomic ,copy)NSString *frozenAmountChange;
@property (nonatomic ,copy)NSString *ID;
@property (nonatomic ,copy)NSString *remark;
/**
 *  交易说明
 */
@property (nonatomic ,copy)NSString *tradingExplain;
/**
 *  交易时间
 */
@property (nonatomic ,copy)NSString *tradingTime;
@property (nonatomic ,copy)NSString *tradingUserId;
@property (nonatomic ,copy)NSString *typeId;
@property (nonatomic ,copy)NSString *userId;
@end
