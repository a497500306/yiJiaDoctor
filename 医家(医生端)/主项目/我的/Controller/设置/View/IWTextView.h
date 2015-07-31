//
//  IWTextView.h
//  ItcastWeibo
//
//  Created by apple on 14-5-19.
//  Copyright (c) 2014年 itcast. All rights reserved.
//

#import <UIKit/UIKit.h>

@class IWTextView;

@protocol  IWTextViewDelegate <NSObject>

@optional
-(void)shuruleduoshaowenzi:(NSString *)wenzi;
@end

@interface IWTextView : UITextView
@property (nonatomic, weak) UILabel *placeholderLabel;
@property (nonatomic, copy) NSString *placeholder;
@property (nonatomic, strong) UIColor *placeholderColor;
@property (nonatomic, weak)UIView *wenzi;


@property (nonatomic, weak)id<IWTextViewDelegate> delegate;
@end
