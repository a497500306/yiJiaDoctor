//
//  MLDoctorDetailModel.h
//  医家(医生端)
//
//  Created by 洛耳 on 15/7/17.
//  Copyright (c) 2015年 workorz. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MLDoctorDetailModel : NSObject
@property (nonatomic ,strong)NSDate *createTime;
/**
 *  所在科室
 */
@property (nonatomic ,copy)NSString *department;
@property (nonatomic ,copy)NSString *departmentsId;
@property (nonatomic ,copy)NSString *disabled;
/**
 *  医生职称
 */
@property (nonatomic ,copy)NSString *doctorTitle;
/**
 *  简介
 */
@property (nonatomic ,copy)NSString *describe;
/**
 *  所在医院
 */
@property (nonatomic ,copy)NSString *hospitalAddress;
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
@property (nonatomic ,copy)NSString *hospitalName;
@property (nonatomic ,copy)NSString *ID;
/**
 *  工作地址
 */
@property (nonatomic ,copy)NSString *jobAddress;
@property (nonatomic ,copy)NSString *jobId;
/**
 *  专长
 */
@property (nonatomic ,copy)NSString *speciality;
@property (nonatomic ,copy)NSString *userId;
@property (nonatomic ,copy)NSString *workAddress;
@property (nonatomic ,copy)NSString *workRegionId;

@end
