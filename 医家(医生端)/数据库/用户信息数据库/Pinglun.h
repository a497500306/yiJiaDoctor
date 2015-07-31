//
//  Pinglun.h
//  医家(医生端)
//
//  Created by 洛耳 on 15/7/23.
//  Copyright (c) 2015年 workorz. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface Pinglun : NSManagedObject

@property (nonatomic, retain) NSString * content;
@property (nonatomic, retain) NSString * createTime;
@property (nonatomic, retain) NSString * disabled;
@property (nonatomic, retain) NSString * displayOrder;
@property (nonatomic, retain) NSString * headImage;
@property (nonatomic, retain) NSString * pinglunid;
@property (nonatomic, retain) NSString * mainUserId;
@property (nonatomic, retain) NSString * minorUserId;
@property (nonatomic, retain) NSString * nickname;
@property (nonatomic, retain) NSString * typeId;
@property (nonatomic, retain) NSString * age;
@property (nonatomic, retain) NSString * sex;

@end
