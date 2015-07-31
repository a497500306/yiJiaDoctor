//
//  NSHuangzheShujuModel.h
//  医家(医生端)
//
//  Created by 洛耳 on 15/7/27.
//  Copyright (c) 2015年 workorz. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSHuangzheShujuModel : NSObject
@property (nonatomic ,copy)NSString *userName;
@property (nonatomic ,copy)NSString *typeId;
@property (nonatomic ,copy)NSString *token;
@property (nonatomic ,copy)NSString *tel;
@property (nonatomic ,copy)NSString *statusId;
@property (nonatomic ,copy)NSString *speciality;
/**
 *  性别
 */
@property (nonatomic ,copy)NSString *sex;
@property (nonatomic ,copy)NSString *regionId;
@property (nonatomic ,copy)NSString *qrCodeId;
@property (nonatomic ,copy)NSString *qrCode;
@property (nonatomic ,copy)NSString *photoId;
@property (nonatomic ,copy)NSString *patientDetail;
@property (nonatomic ,copy)NSString *password;
@property (nonatomic ,copy)NSString *openid;
@property (nonatomic ,copy)NSString *noteName;
/**
 *  称呼
 */
@property (nonatomic ,copy)NSString *nickname;
@property (nonatomic ,copy)NSString *mobile;
@property (nonatomic ,copy)NSString *level;
@property (nonatomic ,copy)NSString *lastContactTime;
@property (nonatomic ,copy)NSString *lastContactContent;
@property (nonatomic ,copy)NSString *isBind;
@property (nonatomic ,copy)NSString *isAudit;
@property (nonatomic ,copy)NSString *inviteCode;
@property (nonatomic ,copy)NSString *intro;
@property (nonatomic ,copy)NSString *idCardNo;
@property (nonatomic ,copy)NSString *ID;
/**
 *  头像图片
 */
@property (nonatomic ,copy)NSString *headImage;
@property (nonatomic ,copy)NSString *email;
@property (nonatomic ,copy)NSString *doctorDetail;
@property (nonatomic ,copy)NSString *disabled;
@property (nonatomic ,copy)NSString *departmentsName;
@property (nonatomic ,copy)NSString *createTime;
/**
 *  病情
 *  119 正常,120 轻微,121 严重
 */
@property (nonatomic ,copy)NSString *condition;
/**
 *  最小血糖
 */
@property (nonatomic ,copy)NSString *booldSugarMin;
/**
 *  最大血糖
 */
@property (nonatomic ,copy)NSString *booldSugarMax;
@property (nonatomic ,copy)NSString *birthday;
/**
 *  年龄
 */
@property (nonatomic ,copy)NSString *age;
@property (nonatomic ,copy)NSString *address;
@property (nonatomic ,copy)NSString *account;
@end
