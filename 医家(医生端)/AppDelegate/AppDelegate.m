//
//  AppDelegate.m
//  医家(医生端)
//
//  Created by 洛耳 on 15/7/7.
//  Copyright (c) 2015年 workorz. All rights reserved.
//

#import "AppDelegate.h"
#import "MLUserInfo.h"


#import "UMSocial.h"
#import "UMSocialWechatHandler.h"
#import "UMSocialQQHandler.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    //友盟分享KEY
    [UMSocialData setAppKey:@"55b5bcc5e0f55aa9ac0033ff"];
    //打开调试log的开关
    [UMSocialData openLog:YES];
    //设置微信AppId，设置分享url，默认使用友盟的网址
    [UMSocialWechatHandler setWXAppId:@"wx61795232350e45ae" appSecret:@"2f3e420d96d904d27a83b931f473d79c" url:@"http://www.umeng.com/social"];
    //设置分享到QQ空间的应用Id，和分享url 链接
    [UMSocialQQHandler setQQWithAppId:@"100424468" appKey:@"c7394704798a158208a74ab60104f0ba" url:@"http://www.umeng.com/social"];
    //设置全局光标的颜色
    [[UITextField appearance] setTintColor:[UIColor whiteColor]];
    // Override point for customization after application launch.
    //判断沙盒是否保存了用户账号和密码信息
    [[MLUserInfo sharedMLUserInfo] loadUserInfoFromSanbox];
    if ([MLUserInfo sharedMLUserInfo].user.length != 11) {//没有保存正确的用户信息
        return YES;
    }else{//保存了正确的用户信息
        UIStoryboard *storayobard = [UIStoryboard storyboardWithName:@"Project" bundle:nil];
        self.window.rootViewController = storayobard.instantiateInitialViewController;
    }
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}
/*********微信回调*********/
- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url
{
    return  [UMSocialSnsService handleOpenURL:url];
}
- (BOOL)application:(UIApplication *)application
            openURL:(NSURL *)url
  sourceApplication:(NSString *)sourceApplication
         annotation:(id)annotation
{
    return  [UMSocialSnsService handleOpenURL:url];
}
@end
