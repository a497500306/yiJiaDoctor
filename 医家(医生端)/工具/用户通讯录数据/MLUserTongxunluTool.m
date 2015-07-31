//
//  MLUserTongxunluTool.m
//  医家(医生端)
//
//  Created by 洛耳 on 15/7/16.
//  Copyright (c) 2015年 workorz. All rights reserved.
//

#import "MLUserTongxunluTool.h"

@implementation MLUserTongxunluTool
singleton_implementation(MLUserTongxunluTool)

-(void)saveUserInfoToSanbox{
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:self.huanzheshu forKey:@"huanzheshu"];
    [defaults setObject:self.huanzhejiaobiao forKey:@"huanzhejiaobiao"];
    [defaults setObject:self.xinpengyoushu forKey:@"xinpengyoushu"];
    [defaults setObject:self.xinpengyoujiaobiao forKey:@"xinpengyoujiaobiao"];
    [defaults setObject:self.pengyouquanjiaobiao forKey:@"pengyouquanjiaobiao"];
    [defaults setObject:self.pengyouquanshu forKey:@"pengyouquanshu"];
    [defaults synchronize];
}

-(void)loadUserInfoFromSanbox{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    self.huanzhejiaobiao = [defaults objectForKey:@"huanzhejiaobiao"];
    self.huanzheshu = [defaults objectForKey:@"huanzheshu"];
    self.pengyouquanshu = [defaults objectForKey:@"pengyouquanshu"];
    self.pengyouquanjiaobiao = [defaults objectForKey:@"pengyouquanjiaobiao"];
    self.xinpengyoujiaobiao = [defaults objectForKey:@"xinpengyoujiaobiao"];
    self.xinpengyoushu = [defaults objectForKey:@"xinpengyoushu"];
}

@end
