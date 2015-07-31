//
//  HuanzheLiebiao.h
//  医家(医生端)
//
//  Created by 洛耳 on 15/7/27.
//  Copyright (c) 2015年 workorz. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface HuanzheLiebiao : NSManagedObject

@property (nonatomic, retain) NSString * userName;
@property (nonatomic, retain) NSString * typeId;
@property (nonatomic, retain) NSString * token;
@property (nonatomic, retain) NSString * tel;
@property (nonatomic, retain) NSString * statusId;
@property (nonatomic, retain) NSString * speciality;
@property (nonatomic, retain) NSString * sex;
@property (nonatomic, retain) NSString * regionId;
@property (nonatomic, retain) NSString * qrCodeId;
@property (nonatomic, retain) NSString * qrCode;
@property (nonatomic, retain) NSString * photoId;
@property (nonatomic, retain) NSString * patientDetail;
@property (nonatomic, retain) NSString * password;
@property (nonatomic, retain) NSString * openid;
@property (nonatomic, retain) NSString * noteName;
@property (nonatomic, retain) NSString * nickname;
@property (nonatomic, retain) NSString * mobile;
@property (nonatomic, retain) NSString * level;
@property (nonatomic, retain) NSString * lastContactTime;
@property (nonatomic, retain) NSString * lastContactContent;
@property (nonatomic, retain) NSString * isBind;
@property (nonatomic, retain) NSString * isAudit;
@property (nonatomic, retain) NSString * inviteCode;
@property (nonatomic, retain) NSString * intro;
@property (nonatomic, retain) NSString * idCardNo;
@property (nonatomic, retain) NSString * iD;
@property (nonatomic, retain) NSString * headImage;
@property (nonatomic, retain) NSString * email;
@property (nonatomic, retain) NSString * doctorDetail;
@property (nonatomic, retain) NSString * disabled;
@property (nonatomic, retain) NSString * departmentsName;
@property (nonatomic, retain) NSString * createTime;
@property (nonatomic, retain) NSString * condition;
@property (nonatomic, retain) NSString * booldSugarMin;
@property (nonatomic, retain) NSString * booldSugarMax;
@property (nonatomic, retain) NSString * birthday;
@property (nonatomic, retain) NSString * age;
@property (nonatomic, retain) NSString * address;
@property (nonatomic, retain) NSString * account;

@end
