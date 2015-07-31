//
//  NewUser.h
//  医家(医生端)
//
//  Created by 洛耳 on 15/7/30.
//  Copyright (c) 2015年 workorz. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface NewUser : NSManagedObject

@property (nonatomic, retain) NSString * headImage;
@property (nonatomic, retain) NSString * nickname;
@property (nonatomic, retain) NSString * qrCode;
@property (nonatomic, retain) NSString * intro;
@property (nonatomic, retain) NSString * workAddress;
@property (nonatomic, retain) NSString * hospitalName;
@property (nonatomic, retain) NSString * doctorTitle;
@property (nonatomic, retain) NSString * department;
@property (nonatomic, retain) NSString * specialty;
@property (nonatomic, retain) NSString * idImage;
@property (nonatomic, retain) NSString * businessLicense;
@property (nonatomic, retain) NSString * isAudit;
@property (nonatomic, retain) NSString * sex;
@property (nonatomic, retain) NSString * birthday;
@property (nonatomic, retain) NSString * age;

@end
