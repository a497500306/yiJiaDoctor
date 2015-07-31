//
//  MLModifyingDataController.h
//  医家(医生端)
//
//  Created by 洛耳 on 15/7/20.
//  Copyright (c) 2015年 workorz. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MLPersonalDataModel.h"
#import "MLPersonalDataController.h"
@interface MLModifyingDataController : UIViewController
@property (nonatomic ,strong)MLPersonalDataModel *model;
@property (nonatomic ,strong)MLPersonalDataController *pdc;
@property (nonatomic ,strong)NSArray *array;
@property (nonatomic ,assign)BOOL isJibenxinxi;
/********基本信息属性***********/
/**
 *  修改的内容
 */
@property (nonatomic ,copy)NSString *neirong;
/**
 *  修改的标题
 */
@property (nonatomic ,copy)NSString *biaoti;
@end
