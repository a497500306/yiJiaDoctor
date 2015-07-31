//
//  MLGerenXinxiModel.h
//  医家(医生端)
//
//  Created by 洛耳 on 15/7/17.
//  Copyright (c) 2015年 workorz. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MLGerenXinxiModel : NSObject
@property (nonatomic ,copy)NSString *account;
@property (nonatomic ,copy)NSString *address;
@property (nonatomic ,copy)NSString *age;
@property (nonatomic ,copy)NSString *birthday;
@property (nonatomic ,copy)NSString *booldSugarMax;
@property (nonatomic ,copy)NSString *booldSugarMin;
@property (nonatomic ,copy)NSString *condition;
@property (nonatomic ,strong)NSDate *createTime;
@property (nonatomic ,copy)NSString *departmentsName;
@property (nonatomic ,copy)NSString *disabled;
@property (nonatomic ,copy)NSString *email;
@property (nonatomic ,strong)NSDictionary *doctorDetail;
/**
 *  简介
 */
@property (nonatomic ,copy)NSString *describe;
/**
 *  所在医院
 */
@property (nonatomic ,copy)NSString *hospitalAddress;
/**
 *  身份证图片地址
 */
@property (nonatomic ,copy)NSString *idImage;
/**
 *  营业执照图片地址
 */
@property (nonatomic ,copy)NSString *businessLicense;
/**
 *  专长
 */
@property (nonatomic ,copy)NSString *specialty;
/**
 *  头像地址
 */
@property (nonatomic ,copy)NSString *headImage;
@property (nonatomic ,copy)NSString *ID;
@property (nonatomic ,copy)NSString *idCardNo;
/**
 *  简介
 */
@property (nonatomic ,copy)NSString *intro;
@property (nonatomic ,copy)NSString *inviteCode;
@property (nonatomic ,copy)NSString *isAudit;
@property (nonatomic ,copy)NSString *isBind;
@property (nonatomic ,copy)NSString *lastContactContent;
@property (nonatomic ,strong)NSDate *lastContactTime;
@property (nonatomic ,copy)NSString *mobile;
/**
 *  名称
 */
@property (nonatomic ,copy)NSString *nickname;
@property (nonatomic ,copy)NSString *noteName;
@property (nonatomic ,copy)NSString *openid;
@property (nonatomic ,copy)NSString *password;
@property (nonatomic ,copy)NSString *patientDetail;
@property (nonatomic ,copy)NSString *photoId;
/**
 *  二维码信息
 */
@property (nonatomic ,copy)NSString *qrCode;
@property (nonatomic ,copy)NSString *qrCodeId;
@property (nonatomic ,copy)NSString *regionId;
@property (nonatomic ,copy)NSString *sex;
@property (nonatomic ,copy)NSString *speciality;
@property (nonatomic ,copy)NSString *statusId;
@property (nonatomic ,copy)NSString *token;
@property (nonatomic ,copy)NSString *typeId;
@property (nonatomic ,copy)NSString *userName;
@end
