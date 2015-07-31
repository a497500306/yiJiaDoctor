//
//  MLhuangzheZhuangtaiModel.h
//  医家(医生端)
//
//  Created by 洛耳 on 15/7/28.
//  Copyright (c) 2015年 workorz. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MLhuangzheZhuangtaiModel : NSObject
@property (nonatomic ,copy)NSString *code;
@property (nonatomic ,copy)NSString *highSum;
@property (nonatomic ,strong)NSArray *list;
@property (nonatomic ,copy)NSString *lowSum;
@property (nonatomic ,copy)NSString *message;
@property (nonatomic ,copy)NSString *normalSum;
@property (nonatomic ,copy)NSString *statusCode;
@end
