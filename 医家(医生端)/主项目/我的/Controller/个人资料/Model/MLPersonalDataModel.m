//
//  MLPersonalDataModel.m
//  医家(医生端)
//
//  Created by 洛耳 on 15/7/20.
//  Copyright (c) 2015年 workorz. All rights reserved.
//

#import "MLPersonalDataModel.h"

@implementation MLPersonalDataModel
-(instancetype)initWithName:(NSString *)name andNeirong:(NSString *)neirong{
    if ( self = [super init] )
    {
        self.neirong = neirong;
        self.name = name;
    }
    return self;
}
@end
