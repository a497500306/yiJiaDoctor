//
//  MLZhangdanController.m
//  医家(医生端)
//
//  Created by 洛耳 on 15/7/22.
//  Copyright (c) 2015年 workorz. All rights reserved.
//

#import "MLZhangdanController.h"
#import "MBProgressHUD+MJ.h"
#import "IWHttpTool.h"
#import "MLUserInfo.h"
#import "MJExtension.h"
#import "MLInterface.h"
#import "MLZhangdanModel.h"
#import "MLZhangdanXiangxiModel.h"
#import "MLZhangdanCell.h"
#import "NSDate+MLDate.h"
#import "NSDate+MJ.h"
@interface MLZhangdanController ()<UITableViewDataSource,UITableViewDelegate>
@property (nonatomic ,weak)UITableView *table;
@property (nonatomic ,strong)NSArray *array;
/**
 *  截取月份
 */
@property (nonatomic ,copy)NSString *yuefen;
/**
 *  组Array
 */
@property (nonatomic ,strong)NSMutableArray *zuArray;
/**
 *  月份Array
 */
@property (nonatomic ,strong)NSMutableArray *yueArray;
@end

@implementation MLZhangdanController
-(NSMutableArray *)zuArray{
    if (_zuArray == nil) {
        _zuArray = [NSMutableArray array];
        return _zuArray;
    }
    return _zuArray;
}
-(NSMutableArray *)yueArray{
    if (_yueArray == nil) {
        _yueArray = [NSMutableArray array];
        return _yueArray;
    }
    return _yueArray;
}
-(NSArray *)array{
    if (_array == nil) {
        _array = [NSArray array];
        return _array;
    }
    return _array;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"账单";
    //初始化
    [self chushihua];
}
-(void)chushihua{
    UITableView *table = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, self.view.frame.size.height - 64) style:UITableViewStyleGrouped];
    table.delegate = self;
    table.dataSource = self;
    //设置分割线包含整个宽度
    [table setSeparatorInset:UIEdgeInsetsZero];
    [table setLayoutMargins:UIEdgeInsetsZero];
    table.rowHeight = 50;
    self.table = table;
    [self.view addSubview:table];
    //网络获取
    [self wangluo];
}
#pragma mark - 网络获取数据
-(void)wangluo{
    [MBProgressHUD showMessage:@"" toView:self.view];
    [[MLUserInfo sharedMLUserInfo] loadUserInfoFromSanbox];
    NSString *url = [MLInterface sharedMLInterface].withdrawLog;
    NSDictionary *dict = @{@"token":[MLUserInfo sharedMLUserInfo].token};
    [IWHttpTool postWithURL:url params:dict success:^(id json) {
        [MBProgressHUD hideHUDForView:self.view];
        MLZhangdanModel *model = [MLZhangdanModel objectWithKeyValues:json];
        if ([model.statusCode isEqualToString:@"200"]) {
            [MLZhangdanXiangxiModel setupReplacedKeyFromPropertyName:^NSDictionary *{
                return @{@"ID":@"id"};
            }];
            NSArray *zhangdan = [MLZhangdanXiangxiModel objectArrayWithKeyValuesArray:model.list];
            self.array = zhangdan;
            dispatch_group_t group = dispatch_group_create();
            dispatch_group_async(group, dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                [self huoquyuefenhezuArray];
                //回到主线程刷新UI
                dispatch_group_notify(group, dispatch_get_main_queue(), ^{
                    [self.table reloadData];
                });
            });
        }else{
            [MBProgressHUD showError:model.message toView:self.view];
        }
    } failure:^(NSError *error) {
        [MBProgressHUD hideHUDForView:self.view];
        [MBProgressHUD showError:@"请检查网络" toView:self.view];
    }];
}
#pragma mark - 获取月份组和zuArray
-(void)huoquyuefenhezuArray{
    //遍历出月份
    for (int i = 0; i < self.array.count; i++) {
        MLZhangdanXiangxiModel *zhangdanM = self.array[i];
        double aNumber = [zhangdanM.tradingTime doubleValue];
        NSDate *date = [NSDate dateWithTimeIntervalInMilliSecondSince1970:aNumber];
        NSString *str = [date nayiyue];
        NSMutableArray *linshiYuefens = [NSMutableArray array];
        NSMutableArray *array = [NSMutableArray array];
        linshiYuefens = self.yueArray;
        NSMutableArray *linshiyueArray = [NSMutableArray array];
        for (int i = 0; i < self.array.count; i ++) {
            if (self.yueArray.count == 0) {//如果月份为空,则添加
                [self.yueArray addObject:str];
                [array addObject:zhangdanM];
            }else{
                linshiyueArray = self.yueArray;
                BOOL is = NO;
                for (int j = 0; j < self.yueArray.count; j++) {
                    NSString *yue = self.yueArray[j];
                    if ([yue isEqualToString:str]) {
                        is = YES;
                        continue;
                    }
                }
                if (is == NO) {
                    NSMutableArray *array = [NSMutableArray array];
                    [array addObject:zhangdanM];
                    [linshiyueArray addObject:str];
                }
                self.yueArray = linshiyueArray;
            }
        }
    }
    //遍历出组
    for (int g = 0; g < self.yueArray.count; g++) {
        NSMutableArray *array = [NSMutableArray array];
        NSString *yuefen = self.yueArray[g];
        for (int h = 0; h < self.array.count; h++) {
            MLZhangdanXiangxiModel *zhangdanM = self.array[h];
            double aNumber = [zhangdanM.tradingTime doubleValue];
            NSDate *date = [NSDate dateWithTimeIntervalInMilliSecondSince1970:aNumber];
            NSString *str = [date nayiyue];
            if ([yuefen isEqualToString:str]) {
                [array addObject:self.array];
            }
        }
        [self.zuArray addObject:array];
    }
}
#pragma mark - UITableView代理数据源方法
//多少组
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.yueArray.count;
}
//每组又多少行
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    NSMutableArray *array = self.zuArray[section];
    return array.count;
}
//每组显示什么内容
-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    NSString *str =[NSString stringWithFormat:@"  %@",self.yueArray[section]];
    return str;
}
//每行显示什么内容
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *ID = @"cell";
    MLZhangdanCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        cell = [[MLZhangdanCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
    }
    MLZhangdanXiangxiModel *modle = self.array[indexPath.row];
    double aNumber = [modle.tradingTime doubleValue];
    NSDate *date = [NSDate dateWithTimeIntervalInMilliSecondSince1970:aNumber];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd"];
    NSString *str = [formatter stringFromDate:date];
#warning 不知道是加钱还是减钱,不知道状态
    [cell cellNeirong:modle.codeName andShijian:str andQian:modle.accountAmountChange andZhuangtai:modle.frozenAmount];
    return cell;
}
//section头部间距
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 25;//section头部高度
}
//section底部间距
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 1;
}
//设置分割线包含整个宽度
-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath

{
    [cell setSeparatorInset:UIEdgeInsetsZero];
    [cell setLayoutMargins:UIEdgeInsetsZero];
}
@end
