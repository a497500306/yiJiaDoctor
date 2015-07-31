//
//  MLInterface.m
//  医家(医生端)
//
//  Created by 洛耳 on 15/7/7.
//  Copyright (c) 2015年 workorz. All rights reserved.
//

#import "MLInterface.h"

@implementation MLInterface

singleton_implementation(MLInterface)
//http://192.168.1.88:8080
//http://192.168.1.88:8080
-(NSString *)login{
    return @"http://192.168.1.88:8080/crm/user_sp/login.json";
}
-(NSString *)sendVerifycode{
    return @"http://192.168.1.88:8080/crm/send_sp/sendVerifycode.json";
}
-(NSString *)saveUser{
    return @"http://192.168.1.88:8080/crm/user_sp/saveUser.json";
}
-(NSString *)getCDByParentId{
    return @"http://192.168.1.88:8080/crm/cd_sp/getCDByParentId.json";
}
-(NSString *)getRegionByParentId{
    return @"http://192.168.1.88:8080/crm/region_sp/getRegionByParentId.json";
}
-(NSString *)updatePassword{
    return @"http://192.168.1.88:8080/crm/user_sp/updatePassword.json";
}
-(NSString *)getfriendList{
    return @"http://192.168.1.88:8080/crm/user_sp/getfriendList.json";
}
-(NSString *)getGlycemicDataByMap{
    return @"http://192.168.1.88:8080/crm/glycemic_sp/getGlycemicDataByMap.json";
}
-(NSString *)getUserByMap{
    return @"http://192.168.1.88:8080/crm/user_sp/getUserByMap.json";
}
-(NSString *)getInviteCodeByToken{
    return @"http://192.168.1.88:8080/crm/user_sp/getInviteCodeByToken.json";
}
-(NSString *)saveInvite{
    return @"http://192.168.1.88:8080/crm/invite_sp/saveInvite.json";
}
-(NSString *)getNewFriendList{
    return @"http://192.168.1.88:8080/crm/user_sp/getNewFriendList.json";
}
-(NSString *)addFriendRelation{
    return @"http://192.168.1.88:8080/crm/user_sp/addFriendRelation.json";
}
-(NSString *)saveRelationByUserId{
    return @"http://192.168.1.88:8080/crm/relation_sp/saveRelationByUserId.json";
}
-(NSString *)contactaddApproved{
    return @"http://192.168.1.88:8080/crm/relation_sp/contactaddApproved.json";
}
-(NSString *)getfriendSumDoctor{
    return @"http://192.168.1.88:8080/crm/user_sp/getfriendSum.json";
}
-(NSString *)getfriendListDoctor{
    return @"http://192.168.1.88:8080/crm/user_sp/getfriendList.json";
}
-(NSString *)getfriendSumPatient{
    return @"http://192.168.1.88:8080/crm/user_sp/getfriendSum.json";
}
-(NSString *)getfriendListPatient{
    return @"http://192.168.1.88:8080/crm/user_sp/getfriendList.json";
}
-(NSString *)getUserByToken{
    return @"http://192.168.1.88:8080/crm/user_sp/getUserByToken.json";
}
-(NSString *)uploadImage{
    return @"http://192.168.1.88:8080/crm/image_sp/uploadImage.json";
}
-(NSString *)saveDoctor{
    return @"http://192.168.1.88:8080/crm/user_sp/updateUser.json";
}
-(NSString *)saveDoctorDoctor{
    return @"http://192.168.1.88:8080/crm/user_sp/saveDoctorDetail.json";
    
}
-(NSString *)getWalletByToken{
    return @"http://192.168.1.88:8080/crm/wallet_sp/getWalletByToken.json";
}
-(NSString *)withdrawApply{
    return @"http://192.168.1.88:8080/crm/withdraw_sp/withdrawApply.json";
}
-(NSString *)saveAlipay{
    return @"http://192.168.1.88:8080/crm/alipay_sp/saveAlipay.json";
}
-(NSString *)withdrawLog{
    return @"http://192.168.1.88:8080/crm/withdraw_sp/withdrawLog.json";
}
-(NSString *)sendVerifycodeVerificationCode{
    return @"http://192.168.1.88:8080/crm/send_sp/sendVerifycode.json";
}
-(NSString *)updatePasswordWithdrawals{
    return @"http://192.168.1.88:8080/crm/wallet_sp/updatePassword.json";
}
-(NSString *)saveBankCard{
    return @"http://192.168.1.88:8080/crm/bankcard_sp /saveBankCard.json";
}
-(NSString *)setPassword{
    return @"http://192.168.1.88:8080/crm/wallet_sp/setPassword.json";
}
-(NSString *)getPraiseUserListByMap{
    return @"http://192.168.1.88:8080/crm/praise_sp/getPraiseUserListByMap.json";
}
-(NSString *)getMessageListByMap{
    return @"http://192.168.1.88:8080/crm/message_sp/getMessageListByMap.json";
}
-(NSString *)getMessageRecordByMap{
    return @"http://192.168.1.88:8080/crm/message_sp/getMessageRecordByMap.json";
}
-(NSString *)getMessageListByMapComplaint{
    return @"http://192.168.1.88:8080/crm/message_sp/getMessageListByMap.json";
}
-(NSString *)getMessageRecordByMapComplaint{
    return @"http://192.168.1.88:8080/crm/message_sp/getMessageRecordByMap.json";
}
-(NSString *)saveFeedback{
    return @"http://192.168.1.88:8080/crm/feedback_sp/saveFeedback.json";
}
-(NSString *)getVersionByMap{
    return @"http://192.168.1.88:8080/crm/version_sp /getVersionByMap.json";
}
-(NSString *)getUserByMapqita{
    return @"http://192.168.1.88:8080/crm/user_sp/getUserByMap.json";
}
@end
