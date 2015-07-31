//
//  MLSearchBox.h
//  医家(医生端)
//
//  Created by 洛耳 on 15/7/16.
//  Copyright (c) 2015年 workorz. All rights reserved.
//

#import <UIKit/UIKit.h>


@protocol  MLSearchBoxDelegate <NSObject>
@optional
-(void)dianjiquxiao;
-(void)jijiangdonghua;
@end

@interface MLSearchBox : UIView
@property (nonatomic ,weak)UITextField *text;
-(void)chuangjianSearchBox;
@property (nonatomic, weak) id<MLSearchBoxDelegate> delegate;
@end
