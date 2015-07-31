//
//  ZSDPaymentView.h
//  demo
//
//  Created by shaw on 15/4/11.
//  Copyright (c) 2015年 shaw. All rights reserved.
//

#import <UIKit/UIKit.h>
@class ZSDSetPasswordView;
@protocol  ZSDPaymentViewDelegate <NSObject>

@optional
/**
 *  密码输入完毕
 */
-(void)mimashuruwangbi:(NSString *)str;
/**
 *  密码输入错误
 */
-(void)mimashurucuowu;
@end
@interface ZSDPaymentView : UIView

@property (nonatomic,copy) NSString *title;
@property (nonatomic,copy) NSString *goodsName;
@property (nonatomic,assign) CGFloat amount;
@property (nonatomic,assign) BOOL isChongzhi;

@property (nonatomic, weak)id<ZSDPaymentViewDelegate> delegate;

-(void)show;
-(void)dismiss;

@end
