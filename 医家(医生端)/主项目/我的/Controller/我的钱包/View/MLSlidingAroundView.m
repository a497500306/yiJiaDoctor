//
//  MLSlidingAroundView.m
//  医家(医生端)
//
//  Created by 洛耳 on 15/7/22.
//  Copyright (c) 2015年 workorz. All rights reserved.
//

#import "MLSlidingAroundView.h"

@interface MLSlidingAroundView()<UIScrollViewDelegate>
@property (nonatomic ,weak)UIView *xiahuaxian;
@property (nonatomic ,weak)UIScrollView *scroll;
/**
 *  选中的按钮
 */
@property (nonatomic ,weak)UIButton *btn;
@end

@implementation MLSlidingAroundView
- (instancetype)init
{
    self = [super init];
    if (self) {
        
    }
    return self;
}
-(NSMutableArray *)boundarys{
    if (_boundarys == nil) {
        _boundarys = [NSMutableArray array];
        return _boundarys;
    }
    return _boundarys;
}
-(NSMutableArray *)btnNumber{
    if (_btnNumber == nil) {
        _btnNumber = [NSMutableArray array];
        return _btnNumber;
    }
    return _btnNumber;
}
-(NSMutableArray *)views{
    if (_views == nil) {
        _views = [[NSMutableArray alloc] init];
        return _views;
    }
    return _views;
}
//自定义普通颜色
-(void)setTextColor:(UIColor *)textColor{
    for (UIButton *btn in self.btnNumber) {
        [btn setTitleColor:textColor forState:UIControlStateNormal];
    }
}
//自定义选中颜色
-(void)setSelectedTextColor:(UIColor *)selectedTextColor{
    for (UIButton *btn in self.btnNumber) {
        [btn setTitleColor:selectedTextColor forState:UIControlStateSelected];
    }
    [self dianjianniu:self.btn];
}
-(void)slidingAroundBtnNumber:(NSArray *)btnNumber{
    CGFloat w = [UIScreen mainScreen].bounds.size.width / btnNumber.count;
    CGFloat h = 43;
    CGFloat y = 0;
    //创建下划线
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 43, w, 1)];
    view.backgroundColor = [UIColor colorWithRed:0/255.0 green:95/255.0 blue:240/255.0 alpha:1];
    self.xiahuaxian = view;
    [self addSubview:view];
    //创建滚动模块
    UIScrollView *scroll = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 44, [UIScreen mainScreen].bounds.size.width, self.frame.size.height - 44)];
    scroll.backgroundColor = [UIColor colorWithRed:239/255.0 green:239/255.0 blue:239/255.0 alpha:1];
    //滚动范围
    scroll.contentSize = CGSizeMake([UIScreen mainScreen].bounds.size.width * btnNumber.count, self.frame.size.height - 44);
    //隐藏滚动条
//    scroll.showsHorizontalScrollIndicator = NO;
//    scroll.showsVerticalScrollIndicator = NO;
    //分页
    scroll.pagingEnabled = YES;
    scroll.delegate = self;
    self.scroll = scroll;
    [self addSubview:scroll];
    for (int i = 0; i < btnNumber.count; i++) {
        //创建按钮
        CGFloat x = w * i;
        //创建头部按钮
        UIButton *btn = [[UIButton alloc] init];
        btn.frame = CGRectMake(x, y, w, h);
        NSString *name = btnNumber[i];
        [btn setTitle:name forState:UIControlStateNormal];
        btn.tag = i;
        [btn addTarget:self action:@selector(dianjianniu:) forControlEvents:UIControlEventTouchUpInside];
        btn.backgroundColor = [UIColor whiteColor];
        //默认选中颜色
        [btn setTitleColor:[UIColor colorWithRed:0/255.0 green:95/255.0 blue:240/255.0 alpha:1] forState:UIControlStateSelected];
        //默认普通颜色
        [btn setTitleColor:[UIColor colorWithRed:150/255.0 green:150/255.0 blue:150/255.0 alpha:1] forState:UIControlStateNormal];
        if (i == 0) {
            self.btn = btn;
            btn.selected = YES;
        }
        [self.btnNumber addObject:btn];
        [self addSubview:btn];
        //创建view
        UIView *jiemian =[[UIView alloc] initWithFrame:CGRectMake([UIScreen mainScreen].bounds.size.width * i, 0, [UIScreen mainScreen].bounds.size.width, scroll.frame.size.height - 64)];
        [self.views addObject:jiemian];
        [self.boundarys addObject:jiemian];
        [scroll addSubview:jiemian];
    }
}
#pragma mark - 点击按钮
-(void)dianjianniu:(UIButton *)btn{
    self.btn.selected = NO;
    self.btn = btn;
    self.btn.selected = YES;
    CGFloat x = [UIScreen mainScreen].bounds.size.width * btn.tag;
    CGFloat y = 0;
    CGPoint offset = CGPointMake(x, y);
    //下划线滚动
    [UIView animateWithDuration:0.2 animations:^{
        self.xiahuaxian.frame = CGRectMake(btn.frame.origin.x, self.xiahuaxian.frame.origin.y, self.xiahuaxian.frame.size.width, 1);
        self.scroll.contentOffset = offset;
    }];
}
#pragma mark - UIScrollViewDelegate
// scrollView滚动时执行
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    CGPoint offset = self.scroll.contentOffset;
    CGFloat offsetX = offset.x / self.btnNumber.count;
    self.xiahuaxian.frame = CGRectMake(offsetX, self.xiahuaxian.frame.origin.y, self.xiahuaxian.frame.size.width, 1);
}
//减速停止了时执行，手触摸时执行执行
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView;

{
    CGPoint offset = self.scroll.contentOffset;
    CGFloat offsetX = offset.x;
    int i = (offsetX + [UIScreen mainScreen].bounds.size.width) / [UIScreen mainScreen].bounds.size.width;
    i = i - 1;
    if (i<0) {
        return;
    }
    UIButton *btn = self.btnNumber[i];
    self.btn.selected = NO;
    self.btn = btn;
    self.btn.selected = YES;
}
@end
