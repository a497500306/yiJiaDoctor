//
//  MLUserZhuangtaiModel.h
//  医家(医生端)
//
//  Created by 洛耳 on 15/7/17.
//  Copyright (c) 2015年 workorz. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MLUserZhuangtaiModel : NSObject
@property (nonatomic ,copy)NSString *code;
@property (nonatomic ,copy)NSString *message;
@property (nonatomic ,copy)NSString *statusCode;
@property (nonatomic ,strong)NSDictionary *user;
@end
