//
//  IWTextView.m
//  ItcastWeibo
//
//  Created by apple on 14-5-19.
//  Copyright (c) 2014年 itcast. All rights reserved.
//

#import "IWTextView.h"

@interface IWTextView()
@end

@implementation IWTextView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // 1.添加提示文字
        UILabel *placeholderLabel = [[UILabel alloc] init];
//        [placeholderLabel sizeToFit];
        placeholderLabel.textColor = [UIColor lightGrayColor];
        placeholderLabel.hidden = YES;
        placeholderLabel.numberOfLines = 0;
        placeholderLabel.backgroundColor = [UIColor clearColor];
        placeholderLabel.font = self.font;
        [self insertSubview:placeholderLabel atIndex:0];
        self.placeholderLabel = placeholderLabel;
        // 2.监听textView文字改变的通知
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textDidChange) name:UITextViewTextDidChangeNotification object:self];
        self.font = [UIFont systemFontOfSize:17];
        
    }
    return self;
}
-(UIView *)wenzi
{
    //3.添加文本输入了多少文字
    UIView *view = [[UIView alloc] init];
    view.backgroundColor = [UIColor yellowColor];
    view.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y + self.frame.size.height, self.frame.size.width, 25);
    UILabel *label = [[UILabel alloc] init];
    label.text = @"123";
    label.frame = CGRectMake(view.frame.origin.x, view.frame.origin.y, view.frame.size.width - 10, view.frame.size.height);
    [view addSubview:label];
    [self addSubview:view];
    return view;
}

- (void)setPlaceholder:(NSString *)placeholder
{
    _placeholder = [placeholder copy];
    self.placeholderLabel.text = placeholder;
    if (placeholder.length) { // 需要显示
        self.placeholderLabel.hidden = NO;
        // 计算frame
        CGFloat placeholderX = 5;
        CGFloat placeholderY = 7;
        CGFloat maxW = self.frame.size.width - 2 * placeholderX;
        CGFloat maxH = self.frame.size.height - 2 * placeholderY;
        CGSize placeholderSize = [placeholder sizeWithFont:self.placeholderLabel.font constrainedToSize:CGSizeMake(maxW, maxH)];
        self.placeholderLabel.frame = CGRectMake(placeholderX, placeholderY, placeholderSize.width, placeholderSize.height);
    } else {
        self.placeholderLabel.hidden = YES;
    }
//    self.placeholderLabel.hidden = (placeholder.length == 0);
}

- (void)setPlaceholderColor:(UIColor *)placeholderColor
{
    _placeholderColor = placeholderColor;
    
    self.placeholderLabel.textColor = placeholderColor;
}

- (void)setFont:(UIFont *)font
{
    [super setFont:font];
    
    self.placeholderLabel.font = font;
    self.placeholder = self.placeholder;
}

- (void)textDidChange
{
    self.placeholderLabel.hidden = (self.text.length != 0);
    [self.delegate shuruleduoshaowenzi:self.text];

}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
