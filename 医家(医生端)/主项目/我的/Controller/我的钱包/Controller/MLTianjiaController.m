//
//  MLTianjiaController.m
//  医家(医生端)
//
//  Created by 洛耳 on 15/7/22.
//  Copyright (c) 2015年 workorz. All rights reserved.
//  支付宝TableView.tag = 0;
//  银行卡TableView.tag = 1;
//  开户银行TableView.tag = 2;

#import "MLTianjiaController.h"
#import "MLSlidingAroundView.h"
#import "MBProgressHUD+MJ.h"
#import "IWHttpTool.h"
#import "MLUserInfo.h"
#import "MJExtension.h"
#import "MLInterface.h"
#import "MLDizhiModel.h"
#import "MLDizhiXiangxiModel.h"
#define gaodu 50
@interface MLTianjiaController ()<UITableViewDataSource,UITableViewDelegate,UIPickerViewDelegate,UIPickerViewDataSource,UIActionSheetDelegate>
/**
 *  支付宝View
 */
@property (nonatomic ,weak)UIView *zfbView;
/**
 *  银行卡View
 */
@property (nonatomic ,weak)UIView *yhkView;
/**
 *  支付宝账户
 */
@property (nonatomic ,weak)UITextField *zfbZhanghu;
/**
 *  支付宝姓名
 */
@property (nonatomic ,weak)UITextField *zfbName;
/**
 *  银行卡账户
 */
@property (nonatomic ,weak)UITextField *yhkZhanghu;
/**
 *  银行卡开户银行按钮
 */
@property (nonatomic ,weak)UIButton *yhkName;
/**
 *  支付宝table
 */
@property (nonatomic ,weak)UITableView *zfbTable;
/**
 *  银行卡table
 */
@property (nonatomic ,weak)UITableView *yhkTable;
/**
 *  开户银行table
 */
@property (nonatomic ,weak)UITableView *khyhTable;
/**
 *  开户银行Array
 */
@property (nonatomic, strong)NSArray *khyhArray;
/**
 *  开户银行ID
 */
@property (nonatomic, copy)NSString *ID;
@end

@implementation MLTianjiaController
-(NSArray *)khyhArray{
    if (_khyhArray == nil) {
        _khyhArray = [NSArray array];
        return _khyhArray;
    }
    return _khyhArray;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"添加账号";
    //添加单击退出键盘
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] init];
    tap.numberOfTapsRequired = 1;
    [tap addTarget:self action:@selector(danji)];
    [self.view addGestureRecognizer:tap];
    //初始化
    [self chushihua];
}
#pragma mark - 初始化
-(void)chushihua{
    self.view.backgroundColor = [UIColor whiteColor];
    //创建支付宝和银行卡界面
    MLSlidingAroundView *sa = [[MLSlidingAroundView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, self.view.frame.size.height)];
    NSArray *array = @[@"添加支付宝账户",@"添加银行卡"];
    sa.backgroundColor = [UIColor colorWithRed:239/255.0 green:239/255.0 blue:239/255.0 alpha:1];
    [sa slidingAroundBtnNumber:array];
    [self.view addSubview:sa];
    //取出每一个界面
    self.zfbView = sa.views[0];
    self.yhkView = sa.views[1];
    //设置支付宝控件
    self.zfbView.backgroundColor = [UIColor colorWithRed:239/255.0 green:239/255.0 blue:239/255.0 alpha:1];
    UITableView *table = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 200)];
    table.delegate = self;
    table.dataSource = self;
    table.rowHeight = gaodu;
    table.backgroundColor = [UIColor colorWithRed:239/255.0 green:239/255.0 blue:239/255.0 alpha:1];
    //设置头部控件
    UIView *touview = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 30)];
    UILabel *lable = [[UILabel alloc] initWithFrame:CGRectMake(10, 10, self.view.frame.size.width, 20)];
    lable.font = [UIFont systemFontOfSize:12];
    lable.textColor = [UIColor colorWithRed:190/255.0 green:190/255.0 blue:190/255.0 alpha:1];
    lable.text = @"请绑定本人的支付宝";
    [touview addSubview:lable];
    table.tableHeaderView = touview;
    //设置底部控件
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 70)];
    UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(10, 10, [UIScreen mainScreen].bounds.size.width - 20, 50)];
    [btn setTitle:@"确认" forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor colorWithRed:0/255.0 green:95/255.0 blue:240/255.0 alpha:1] forState:UIControlStateNormal];
    btn.backgroundColor = [UIColor whiteColor];
    //圆角
    btn.layer.cornerRadius = 3;
    btn.layer.masksToBounds = YES;
    [btn addTarget:self action:@selector(dianjiqueren) forControlEvents:UIControlEventTouchUpInside];
    [view addSubview:btn];
    table.tableFooterView = view;
    //不可滚动
    table.scrollEnabled = NO;
    //设置分割线包含整个宽度
    [table setSeparatorInset:UIEdgeInsetsZero];
    [table setLayoutMargins:UIEdgeInsetsZero];
    [self.zfbView addSubview:table];
    //设置银行卡界面
    [self yinhanka];
}
#pragma mark - 设置银行卡界面
-(void)yinhanka{
    UITableView *table = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 200)];
    table.delegate = self;
    table.dataSource = self;
    table.rowHeight = gaodu;
    table.backgroundColor = [UIColor colorWithRed:239/255.0 green:239/255.0 blue:239/255.0 alpha:1];
    //设置头部控件
    UIView *touview = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 30)];
    UILabel *lable = [[UILabel alloc] initWithFrame:CGRectMake(10, 10, self.view.frame.size.width, 20)];
    lable.font = [UIFont systemFontOfSize:12];
    lable.textColor = [UIColor colorWithRed:190/255.0 green:190/255.0 blue:190/255.0 alpha:1];
    lable.text = @"请绑定本人银行卡,持卡人默认是认证的真实姓名";
    [touview addSubview:lable];
    table.tableHeaderView = touview;
    //设置底部控件
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 70)];
    UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(10, 10, [UIScreen mainScreen].bounds.size.width - 20, 50)];
    [btn setTitle:@"确认" forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor colorWithRed:0/255.0 green:95/255.0 blue:240/255.0 alpha:1] forState:UIControlStateNormal];
    btn.backgroundColor = [UIColor whiteColor];
    //圆角
    btn.layer.cornerRadius = 3;
    btn.layer.masksToBounds = YES;
    [btn addTarget:self action:@selector(yhkDianjiqueren) forControlEvents:UIControlEventTouchUpInside];
    [view addSubview:btn];
    table.tableFooterView = view;
    table.tag = 1;
    //不可滚动
    table.scrollEnabled = NO;
    //设置分割线包含整个宽度
    [table setSeparatorInset:UIEdgeInsetsZero];
    [table setLayoutMargins:UIEdgeInsetsZero];
    [self.yhkView addSubview:table];
}
#pragma mark - UITableView代理数据源方法
//每组又多少行
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 2;
}
//每行显示什么内容
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [[UITableViewCell alloc] init];
    cell.textLabel.font = [UIFont systemFontOfSize:16];
    //输入框
    UITextField *field = [[UITextField alloc] initWithFrame:CGRectMake(110, 0, 250, gaodu)];
    field.font = [UIFont systemFontOfSize:14];
    field.tintColor = [UIColor colorWithRed:0/255.0 green:95/255.0 blue:240/255.0 alpha:1];
    if (tableView.tag == 1) {//设置银行卡
        if (indexPath.row == 0) {//账户
            cell.textLabel.text = @"卡号";
            field.frame = CGRectMake(65, 0, 300, gaodu);
            //弹出数字键盘
            field.keyboardType = UIKeyboardTypeNumberPad;
            //设置提示文字
            NSMutableDictionary *attrs = [NSMutableDictionary dictionary];
            attrs[NSForegroundColorAttributeName] = [UIColor colorWithRed:196/255.0 green:196/255.0 blue:196/255.0 alpha:1];
            field.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"银行卡号" attributes:attrs];
            self.yhkZhanghu = field;
            [cell.contentView addSubview:field];
        }else if (indexPath.row == 1) {//姓名
            cell.textLabel.text = @"银行";
            UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(65, 0, 300, gaodu)];
            [btn addTarget:self action:@selector(dianjiyinhang) forControlEvents:UIControlEventTouchUpInside];
            [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            [cell.contentView addSubview:btn];
            btn.titleLabel.font = [UIFont systemFontOfSize:14];
            btn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
            self.yhkName = btn;
        }
    }else{//设置支付宝
        [cell.contentView addSubview:field];
        if (indexPath.row == 0) {//账户
            cell.textLabel.text = @"账户";
            //设置提示文字
            NSMutableDictionary *attrs = [NSMutableDictionary dictionary];
            attrs[NSForegroundColorAttributeName] = [UIColor colorWithRed:196/255.0 green:196/255.0 blue:196/255.0 alpha:1];
            field.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"支付宝账户" attributes:attrs];
            self.zfbZhanghu = field;
        }else if (indexPath.row == 1) {//姓名
            cell.textLabel.text = @"支付宝姓名";
            //设置提示文字
            NSMutableDictionary *attrs = [NSMutableDictionary dictionary];
            attrs[NSForegroundColorAttributeName] = [UIColor colorWithRed:196/255.0 green:196/255.0 blue:196/255.0 alpha:1];
            field.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"为确保安却,必须实名认证" attributes:attrs];
            self.zfbName = field;
        }
    }
    return cell;
}
//设置分割线包含整个宽度
-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath

{
    [cell setSeparatorInset:UIEdgeInsetsZero];
    [cell setLayoutMargins:UIEdgeInsetsZero];
}
#pragma mark - 点击银行
-(void)dianjiyinhang{
    [self.view endEditing:YES];
    [MBProgressHUD showMessage:nil toView:self.view];
    NSString *str = [MLInterface sharedMLInterface].getCDByParentId;
    NSDictionary *dict = @{@"parentId":@"97"};
    [IWHttpTool postWithURL:str params:dict success:^(id json) {
        [MBProgressHUD hideHUDForView:self.view animated:NO];
        MLDizhiModel *dizhi = [MLDizhiModel objectWithKeyValues:json];
        [MLDizhiXiangxiModel setupReplacedKeyFromPropertyName:^NSDictionary *{
            return @{@"ID":@"id"};
        }];
        NSArray *array = [MLDizhiXiangxiModel objectArrayWithKeyValuesArray:dizhi.list];
        self.khyhArray = array;
        [self.khyhTable reloadData];
        [self chuanjianxuanzheqi];
    } failure:^(NSError *error) {
        [MBProgressHUD hideHUDForView:self.view animated:NO];
        [MBProgressHUD showError:@"请检查网络" toView:self.view];
    }];
}
#pragma mark - 创建银行选择器
-(void)chuanjianxuanzheqi{
    //默认银行BTN
    MLDizhiXiangxiModel *xiangxi = self.khyhArray[0];
    self.ID = xiangxi.ID;
    [self.yhkName setTitle:xiangxi.name forState:UIControlStateNormal];
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0){
        UIAlertController* alertVc=[UIAlertController alertControllerWithTitle:@"\n\n\n\n\n\n\n\n\n\n\n" message:nil preferredStyle:(UIAlertControllerStyleActionSheet)];
        UIPickerView *pick = [[UIPickerView alloc]initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width - 20, 216)];
        pick.delegate = self;
        pick.dataSource = self;
        UIAlertAction* ok=[UIAlertAction actionWithTitle:@"确认" style:(UIAlertActionStyleDefault) handler:^(UIAlertAction *action) {
        }];
        UIAlertAction* no=[UIAlertAction actionWithTitle:@"取消" style:(UIAlertActionStyleDestructive) handler:^(UIAlertAction *action) {
            [self.yhkName setTitle:@"" forState:UIControlStateNormal];
        }];
        [alertVc.view addSubview:pick];
        [alertVc addAction:ok];
        [alertVc addAction:no];
        [self presentViewController:alertVc animated:YES completion:nil];
    }else{
        UIPickerView *pick = [[UIPickerView alloc]initWithFrame:CGRectMake(0, 0, 375, 216)];
        pick.delegate = self;
        pick.dataSource = self;
        UIActionSheet *aler= [[UIActionSheet alloc] initWithTitle:@"\n\n\n\n\n\n\n\n\n\n\n" delegate:self cancelButtonTitle:nil destructiveButtonTitle:@"确定" otherButtonTitles:nil, nil];
        aler.tag = 3;
        [aler addSubview:pick];
        [aler showInView:self.view];
    }
}
#pragma mark - 代理方法
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    
}
#pragma mark - UIPickerViewDataSource
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    return self.khyhArray.count;
}
#pragma mark - UIPickerViewDelegate
// 返回第component列的第row行需要显示的视图
// 当一个view进入视野范围内的时候调用
// 当系统调用该方法的时候会自动传入可重用的view
- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view
{
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, pickerView.frame.size.width, 44)];
    MLDizhiXiangxiModel *xianxi = self.khyhArray[row];
    label.text = xianxi.name;
    label.textAlignment = NSTextAlignmentCenter;
    return label;
}

// 返回第component列每一行的高度
- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component{
    //    return 54;
    
    return 44;
}
// 只有通过手指选中某一行的时候才会调用
- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    MLDizhiXiangxiModel *xiangxi = self.khyhArray[row];
    NSString *str = xiangxi.name;
    self.ID = xiangxi.ID;
    [self.yhkName setTitle:str forState:UIControlStateNormal];
}
#pragma mark - 点击支付宝确认
-(void)dianjiqueren{
    if (self.zfbName.text.length == 0 && self.zfbZhanghu.text.length == 0) {
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:nil message:@"请输入正确的信息" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
        [alert show];
        return ;
    }
    //网络请求
    [[MLUserInfo sharedMLUserInfo] loadUserInfoFromSanbox];
    NSString *url = [MLInterface sharedMLInterface].saveAlipay;
    NSDictionary *dict = @{@"token":[MLUserInfo sharedMLUserInfo].token,@"alipayNo":self.zfbZhanghu.text,@"zfbUserName":self.zfbName.text};
    [MBProgressHUD showMessage:@"正在添加" toView:self.view];
    [IWHttpTool postWithURL:url params:dict success:^(id json) {
        MLDizhiModel *model = [MLDizhiModel objectWithKeyValues:json];
        if ([model.statusCode isEqualToString:@"200"]) {
            [MBProgressHUD hideHUDForView:self.view];
            [MBProgressHUD showSuccess:@"添加成功" toView:self.view];
            //延时1秒
            [self performSelector:@selector(delayMethod) withObject:nil afterDelay:1.0f];
        }else{
            [MBProgressHUD hideHUDForView:self.view];
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:nil message:model.message delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
            [alert show];
        }
    } failure:^(NSError *error) {
        [MBProgressHUD hideHUDForView:self.view];
    }];
}
#pragma mark - 退出
-(void)delayMethod{
    [self.navigationController popViewControllerAnimated:YES];
}
#pragma mark - 点击银行卡确认
-(void)yhkDianjiqueren{
    if (self.yhkName.titleLabel.text.length == 0 && self.yhkZhanghu.text.length == 0) {
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:nil message:@"请输入正确的信息" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
        [alert show];
        return ;
    }
    //网络请求
    [[MLUserInfo sharedMLUserInfo] loadUserInfoFromSanbox];
    NSString *url = [MLInterface sharedMLInterface].saveBankCard;
    NSDictionary *dict = @{@"token":[MLUserInfo sharedMLUserInfo].token,@"openingAccount":self.yhkZhanghu.text,@"bankId":self.ID};
    [MBProgressHUD showMessage:@"正在添加" toView:self.view];
    [IWHttpTool postWithURL:url params:dict success:^(id json) {
        MLDizhiModel *model = [MLDizhiModel objectWithKeyValues:json];
        if ([model.statusCode isEqualToString:@"200"]) {
            [MBProgressHUD hideHUDForView:self.view];
            [MBProgressHUD showSuccess:@"添加成功" toView:self.view];
        }else{
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:nil message:model.message delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
            [alert show];
        }
    } failure:^(NSError *error) {
        [MBProgressHUD hideHUDForView:self.view];
    }];
}
#pragma mark - 单击退出键盘
-(void)danji{
    [self.view endEditing:YES];
}
@end
