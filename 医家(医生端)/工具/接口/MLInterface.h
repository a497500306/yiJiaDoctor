//
//  MLInterface.h
//  医家(医生端)
//
//  Created by 洛耳 on 15/7/7.
//  Copyright (c) 2015年 workorz. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Singleton.h"


@interface MLInterface : NSObject
singleton_interface(MLInterface);
/**
 *  登陆
 *  mobie:手机号
 *  password:密码MD5加密
 *  typeid:医生版:3  用户版:5
 */
@property (nonatomic, copy)NSString * login;
/**
 *  注册获取验证码接口
 *  mobie:手机号
 *  typeid:注册短信82   找回密码短信84
 */
@property (nonatomic, copy)NSString * sendVerifycodeVerificationCode;
/**
 *  注册、校验验证码、登录
 *  mobie:手机号
 *  typeid:医生3 营养师4 患者5
 *  verifycode : 验证码
 *  password : 密码
 */
@property (nonatomic, copy)NSString * saveUser;
/**
 *  获取职称
 *  parentid : 父ID
 */
@property (nonatomic, copy)NSString * getCDByParentId;
/**
 *  获取省市区
 *  parentid : 父ID 
 *  获取全国省份1
 */
@property (nonatomic, copy)NSString * getRegionByParentId;
/**
 *  找回密码获取验证码接口
 *  mobile : 手机号
 *  typeId : 注册短信83   找回密码短信84
 */
@property (nonatomic, copy)NSString * sendVerifycode;
/**
 *  修改密码
 *  mobile : 手机号
 *  verifycode
 *  password
 */
@property (nonatomic, copy)NSString * updatePassword;
/**
 *  消息首页
 *  token
 *  noteName : 备注名  搜索时用
 */
@property (nonatomic, copy)NSString * getfriendList;
/**
 *  血糖记录
 *  token
 *  userId : 用户Id
 *  startTime : 开始时间
 *  endTime : 结束时间
 */
@property (nonatomic, copy)NSString * getGlycemicDataByMap;
/**
 *  个人信息
 *  token
 *  userId : 用户Id
 */
@property (nonatomic, copy)NSString * getUserByMap;
/**
 *  我的邀请码接口
 *  token
 */
@property (nonatomic, copy)NSString * getInviteCodeByToken;

/**
 *  填写邀请码
 *  token
 *  inviteCode
 */
@property (nonatomic, copy)NSString * saveInvite;
/**
 *  新朋友
 *  token
 *  list : Mobile,nickname
 */
@property (nonatomic, copy)NSString * getNewFriendList;
/**
 *  手机号添加好友
 *  token
 *  Mobile
 *  nickname : 备注名
 */
@property (nonatomic, copy)NSString * addFriendRelation;
/**
 *  UserId添加好友
 *  token
 *  userId
 *  nickname : 备注名
 */
@property (nonatomic, copy)NSString * saveRelationByUserId;
/**
 *  同意添加
 *  token
 *  mobile
 */
@property (nonatomic, copy)NSString * contactaddApproved;
/**
 *  获取医生数目
 *  token
 *  typeid
 */
@property (nonatomic, copy)NSString * getfriendSumDoctor;
/**
 *  获取医生数据列表
 *  token
 *  typeid
 */
@property (nonatomic, copy)NSString * getfriendListDoctor;
/**
 *  获取患者数目
 *  token
 *  typeid
 */
@property (nonatomic, copy)NSString * getfriendSumPatient;
/**
 *  获取患者数据列表
 *  token
 *  typeid
 */
@property (nonatomic, copy)NSString * getfriendListPatient;
/**
 *  获取个人信息
 *  token
 */
@property (nonatomic, copy)NSString * getUserByToken;

/**
 *  上传图片
 *  token
 *  typeId : 二维码17 身份证正面24 身份证反面25 执照26 头像27
 *  file : 文件
 */
@property (nonatomic, copy)NSString * uploadImage;
/**
 *  提交用户基本信息
 *  token
 *  typeId : 医生3  营养师4
 *  nickname : 昵称
 *  email : 邮箱
 *  tel : 电话
 *  yserName : 姓名(真实姓名)
 *  sex : 性别
 *  photoId : 用户头像(image_id)
 *  idCardNo : 身份证号
 *  intro : 简介
 *  address : 详细地址
 *  regionId : 地区
 *  birthday : 生日
 *  age : 年龄
 */
@property (nonatomic, copy)NSString * saveDoctor;
/**
 *  提交医生扩展信息
 *  token
 *  workAddress : 工作地址
 *  workRegionId : 地区
 *  hospitalName : 所在医院
 *  jobId : 医生职称
 *  departmentsId : 所在科室
 *  speciality : 专长
 */
@property (nonatomic, copy)NSString * saveDoctorDoctor;
/**
 *  钱包
 *  token
 */
@property (nonatomic, copy)NSString * getWalletByToken;
/**
 *  提现
 *  token
 *  money
 *  password
 */
@property (nonatomic, copy)NSString * withdrawApply;

/**
 *  添加支付宝帐号(待测试)
 *  token
 *  alipayNo : 支付宝账号
 *  zfbUserName
 */
@property (nonatomic, copy)NSString * saveAlipay;

/**
 *  账单
 *  token
 */
@property (nonatomic, copy)NSString * withdrawLog;
/**
 *  获取验证码
 *  token
 */
@property (nonatomic, copy)NSString * getVerificationCode;
/**
 *  修改提现密码
 *  token
 *  password
 *  verifycode
 */
@property (nonatomic, copy)NSString * updatePasswordWithdrawals;
/**
 *  添加银行卡
 *  token
 *  bankId : 银行
 *  openingAccount : 卡号
 */
@property (nonatomic, copy)NSString * saveBankCard;
/**
 *  设置提现密码
 *  token
 *  password
 */
@property (nonatomic, copy)NSString * setPassword;
/**
 *  赞
 *  token
 */
@property (nonatomic, copy)NSString * getPraiseUserListByMap;
/**
 *  评论列表
 *  token
 *  typeId : 评论22
 */
@property (nonatomic, copy)NSString * getMessageListByMap;
/**
 *  评论记录
 *  token
 *  typeId : 评论22
 */
@property (nonatomic, copy)NSString * getMessageRecordByMap;
/**
 *  投诉列表
 *  token
 *  typeId : 投诉23
 */
@property (nonatomic, copy)NSString * getMessageListByMapComplaint;

/**
 *  投诉记录
 *  token
 *  typeId : 投诉23
 */
@property (nonatomic, copy)NSString * getMessageRecordByMapComplaint;
/**
 *  反馈
 *  token
 *  content
 */
@property (nonatomic, copy)NSString * saveFeedback;
/**
 *  获取版本信息
 *  token
 *  wayNo : 渠道号
 *  typeId : 版本类型  医生版116  用户版117
 */
@property (nonatomic, copy)NSString * getVersionByMap;
/**
 *  其他医生详细信息获取
 */
@property (nonatomic, copy)NSString * getUserByMapqita;

@end
