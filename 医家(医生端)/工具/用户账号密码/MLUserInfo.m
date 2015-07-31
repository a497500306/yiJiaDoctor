//
//  MLUserInfo.m
//  医家(医生端)
//
//  Created by 洛耳 on 15/7/9.
//  Copyright (c) 2015年 workorz. All rights reserved.
//

#import "MLUserInfo.h"

#define UserKey @"user"
#define LoginStatusKey @"LoginStatus"
#define PwdKey @"pwd"
#define Token @"token"

@implementation MLUserInfo

singleton_implementation(MLUserInfo)

-(void)saveUserInfoToSanbox{
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:self.user forKey:UserKey];
    [defaults setBool:self.loginStatus forKey:LoginStatusKey];
    [defaults setObject:self.pwd forKey:PwdKey];
    [defaults setObject:self.token forKey:Token];
    [defaults synchronize];
    
}

-(void)loadUserInfoFromSanbox{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    self.user = [defaults objectForKey:UserKey];
    self.loginStatus = [defaults boolForKey:LoginStatusKey];
    self.pwd = [defaults objectForKey:PwdKey];
    self.token = [defaults objectForKey:Token];
}

-(void)zhuxiaoyonghu{
    self.user = nil;
    self.loginStatus = nil;
    self.token = nil;
    [self saveUserInfoToSanbox];
}

@end
