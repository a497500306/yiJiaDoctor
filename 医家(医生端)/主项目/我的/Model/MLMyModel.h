//
//  MLMyModel.h
//  医家(医生端)
//
//  Created by 洛耳 on 15/7/17.
//  Copyright (c) 2015年 workorz. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MLMyModel : NSObject
/**
 *  头像地址
 */
@property (nonatomic ,copy)NSString *headImage;
/**
 *  名称
 */
@property (nonatomic ,copy)NSString *nickname;
/**
 *  二维码信息
 */
@property (nonatomic ,copy)NSString *qrCode;
/**
 *  简介
 */
@property (nonatomic ,copy)NSString *intro;
/**
 *  工作地址
 */
@property (nonatomic ,copy)NSString *workAddress;
/**
 *  所在医院
 */
@property (nonatomic ,copy)NSString *hospitalName;
/**
 *  医生职称
 */
@property (nonatomic ,copy)NSString *doctorTitle;
/**
 *  所在科室
 */
@property (nonatomic ,copy)NSString *department;
/**
 *  专长
 */
@property (nonatomic ,copy)NSString *specialty;
/**
 *  身份证图片地址
 */
@property (nonatomic ,copy)NSString *idImage;
/**
 *  营业执照图片地址
 */
@property (nonatomic ,copy)NSString *businessLicense;
/**
 *  时候审核(认证)
 */
@property (nonatomic ,copy)NSString *isAudit;
/**
 *  性别
 */
@property (nonatomic ,copy)NSString *sex;
/**
 *  生日
 */
@property (nonatomic ,copy)NSString *birthday;
/**
 *  年龄
 */
@property (nonatomic ,copy)NSString *age;
/**
 *  ID
 */
@property (nonatomic ,copy)NSString *ID;
@end
