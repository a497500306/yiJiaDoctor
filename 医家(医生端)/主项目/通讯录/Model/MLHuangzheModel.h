//
//  MLHuangzheModel.h
//  医家(医生端)
//
//  Created by 洛耳 on 15/7/16.
//  Copyright (c) 2015年 workorz. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MLHuangzheModel : NSObject

@property (nonatomic ,copy)NSString *statusCode;
@property (nonatomic ,copy)NSString *code;
@property (nonatomic ,copy)NSString *message;
/**
 * 患者数目
 */
@property (nonatomic ,copy)NSString *friendSum;
@end
