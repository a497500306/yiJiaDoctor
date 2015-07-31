//
//  MLHuangzheCell.h
//  医家(医生端)
//
//  Created by 洛耳 on 15/7/27.
//  Copyright (c) 2015年 workorz. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MLHuangzheCell : UITableViewCell
/**
 *  患者界面Cell
 */
-(void)cellTouxiangURL:(NSString *)url andName:(NSString *)name andNianling:(NSString *)nianling andXingbie:(NSString *)xingbie andZuigaoXuetang:(NSString *)zuigao andZuidiXuetang:(NSString *)zuidi andYanzhong:(NSString *)yanzhong;

/**
 *  医生圈界面Cell
 */
-(void)cellTouxiangURL:(NSString *)url andName:(NSString *)name andNianling:(NSString *)nianling andXingbie:(NSString *)xingbie andKeshi:(NSString *)keshi;
@end
