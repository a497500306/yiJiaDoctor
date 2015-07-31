//
//  MLHuangzheXiangxiModel.h
//  医家(医生端)
//
//  Created by 洛耳 on 15/7/28.
//  Copyright (c) 2015年 workorz. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MLHuangzheXiangxiModel : NSObject
/**
 *  偏低次数
 */
@property (nonatomic ,copy)NSString *lowSum;
@property (nonatomic ,copy)NSString *ID;
/**
 *  偏高次数
 */
@property (nonatomic ,copy)NSString *highSum;
/**
 *  晚餐前
 */
@property (nonatomic ,copy)NSString *dinnerStart;
/**
 *  晚餐后
 */
@property (nonatomic ,copy)NSString *dinnerEnd;
@property (nonatomic ,copy)NSString *dbp;
@property (nonatomic ,copy)NSString *createUserId;
/**
 *  日期
 */
@property (nonatomic ,copy)NSString *createTime;
/**
 *  中餐前
 */
@property (nonatomic ,copy)NSString *chineseFoodStart;
/**
 *  中餐后
 */
@property (nonatomic ,copy)NSString *chineseFoodEnd;
/**
 *  早餐前
 */
@property (nonatomic ,copy)NSString *breakfastStart;
/**
 *  早餐后
 */
@property (nonatomic ,copy)NSString *breakfastEnd;
@property (nonatomic ,copy)NSString *beforeGoingToBed;
@property (nonatomic ,copy)NSString *mood;
/**
 *  凌晨
 */
@property (nonatomic ,copy)NSString *morningNum;
/**
 *  正常次数
 */
@property (nonatomic ,copy)NSString *normalSum;
@property (nonatomic ,copy)NSString *pharmacy;
@property (nonatomic ,copy)NSString *remark;
@property (nonatomic ,copy)NSString *sbp;
@property (nonatomic ,copy)NSString *sport;
@property (nonatomic ,copy)NSString *timeBucket;
@property (nonatomic ,copy)NSString *value;
@end
