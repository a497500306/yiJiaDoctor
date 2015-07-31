//
//  Zhan.h
//  医家(医生端)
//
//  Created by 洛耳 on 15/7/24.
//  Copyright (c) 2015年 workorz. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface Zhan : NSManagedObject

@property (nonatomic, retain) NSString * createTime;
@property (nonatomic, retain) NSString * headImage;
@property (nonatomic, retain) NSString * zhanID;
@property (nonatomic, retain) NSString * mainUserId;
@property (nonatomic, retain) NSString * minorUserId;
@property (nonatomic, retain) NSString * nickname;
@property (nonatomic, retain) NSString * post;
@property (nonatomic, retain) NSString * postId;
@property (nonatomic, retain) NSString * reply;
@property (nonatomic, retain) NSString * replyId;
@property (nonatomic, retain) NSString * typeId;

@end
