//
//  MLCollectionViewFlowLayout.m
//  医家(医生端)
//
//  Created by 洛耳 on 15/7/29.
//  Copyright (c) 2015年 workorz. All rights reserved.
//

#import "MLCollectionViewFlowLayout.h"

@implementation MLCollectionViewFlowLayout
-(BOOL)shouldInvalidateLayoutForBoundsChange:(CGRect)newBounds{
    return YES;
}
//初始化
-(void)prepareLayout{
    [super prepareLayout];
    self.itemSize = CGSizeMake([UIScreen mainScreen].bounds.size.width / 9, [UIScreen mainScreen].bounds.size.width / 9);
    self.sectionInset = UIEdgeInsetsMake(0, 0, 0, 0);
    self.minimumLineSpacing = 0;
    self.minimumInteritemSpacing = 0;
}
@end
