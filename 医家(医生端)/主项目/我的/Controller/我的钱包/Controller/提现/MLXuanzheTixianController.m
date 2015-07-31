//
//  MLXuanzheTixianController.m
//  医家(医生端)
//
//  Created by 洛耳 on 15/7/23.
//  Copyright (c) 2015年 workorz. All rights reserved.
//

#import "MLXuanzheTixianController.h"
#import "MLWalletXiangxiModel.h"
#import "MLXuanzheCell.h"
#import "MBProgressHUD+MJ.h"
#import "IWHttpTool.h"
#import "MLUserInfo.h"
#import "MJExtension.h"
#import "MLInterface.h"
#import "ZSDPaymentView.h"
#import "MLChongzhiMimaController.h"
#import "MLShoudongShuruController.h"
#import "MLDizhiModel.h"
#import "MD5Tool.h"
#import "MLTianjiaController.h"


@interface MLXuanzheTixianController ()<UITableViewDataSource,UITableViewDelegate,ZSDPaymentViewDelegate,UIAlertViewDelegate>
@property (nonatomic ,weak)UITableView *table;
@property (nonatomic ,strong)NSMutableArray *xuanzheArray;
@property (nonatomic ,strong)NSMutableArray *xuanzheM;
@property (nonatomic ,weak)ZSDPaymentView *payment;
@end

@implementation MLXuanzheTixianController
-(NSMutableArray *)xuanzheM{
    if (_xuanzheM == nil) {
        _xuanzheM = [NSMutableArray array];
        return _xuanzheM;
    }
    return _xuanzheM;
}
-(NSMutableArray *)xuanzheArray{
    if (_xuanzheArray == nil) {
        _xuanzheArray = [NSMutableArray array];
        return _xuanzheArray;
    }
    return _xuanzheArray;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"钱币提现";
    self.view.backgroundColor = [UIColor colorWithRed:239/255.0 green:239/255.0 blue:239/255.0 alpha:1];
    //设置右上角
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(dianjijiahao)];
    //初始化
    [self chushihua];
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    //监听通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(dianjichongzhi) name:@"点击重置" object:nil];
}
#pragma mark - 点击又上角加号
-(void)dianjijiahao{
    MLTianjiaController *tianjiaC = [[MLTianjiaController alloc] init];
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStyleDone target:nil action:nil];
    [self.navigationController pushViewController:tianjiaC animated:YES];
}
#pragma mark - 初始化
-(void)chushihua{
    for (int i = 0 ; i < self.array.count; i++) {
        NSString *str = @"否";
        [self.xuanzheArray addObject:str];
    }
    //显示table
    UITableView *table = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, self.view.frame.size.height - 64)];
    table.delegate = self;
    table.dataSource = self;
    table.rowHeight = 50;
    //设置分割线包含整个宽度
    [table setSeparatorInset:UIEdgeInsetsZero];
    [table setLayoutMargins:UIEdgeInsetsZero];
    table.backgroundColor = [UIColor colorWithRed:239/255.0 green:239/255.0 blue:239/255.0 alpha:1];
    //底部退出按钮
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 70)];
    UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(10, 10, [UIScreen mainScreen].bounds.size.width - 20, 40)];
    [btn setTitle:@"下一步" forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor colorWithRed:23/255.0 green:90/255.0 blue:240/255.0 alpha:1] forState:UIControlStateNormal];
    btn.backgroundColor = [UIColor whiteColor];
    //圆角
    btn.layer.cornerRadius = 3;
    btn.layer.masksToBounds = YES;
    [btn addTarget:self action:@selector(dianjixiayibu) forControlEvents:UIControlEventTouchUpInside];
    [view addSubview:btn];
    table.tableFooterView = view;
    self.table = table;
    //头部10间距
    UIView *jianju = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 100, 10)];
    table.tableHeaderView = jianju;
    [self.view addSubview:table];
}
#pragma mark - 点击下一步
-(void)dianjixiayibu{
    if (self.xuanzheM.count == 0) {
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:nil message:@"请选择银行/支付宝" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
        [alert show];
        return ;
    }
    //弹出输入密码界面
    ZSDPaymentView *payment = [[ZSDPaymentView alloc]init];
    payment.title = @"支付密码";
    payment.goodsName = @"提现";
    payment.amount = [self.jine floatValue];
    payment.delegate = self;
    self.payment = payment;
    [payment show];
    //网络获取
    NSString *url = [MLInterface sharedMLInterface].withdrawApply;
    MLWalletXiangxiModel *model = self.xuanzheM[0];
    [[MLUserInfo sharedMLUserInfo] loadUserInfoFromSanbox];
    NSDictionary *dict = @{@"token":[MLUserInfo sharedMLUserInfo].token,@"money":self.jine,@"password":@"123",@"type":model.type,@"id":model.ID};
    [IWHttpTool postWithURL:url params:dict success:^(id json) {
        NSLog(@"%@",json);
    } failure:^(NSError *error) {
        NSLog(@"失败");
    }];
}
#pragma mark - tableview代理数据源方法
//每组又多少行
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.array.count;
}
//每行显示什么内容
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *ID = @"cell";
    MLXuanzheCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        cell = [[MLXuanzheCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
    }
    MLWalletXiangxiModel *xiangxiM = self.array[indexPath.row];
    NSString *str = self.xuanzheArray[indexPath.row];
    BOOL is;
    if ([str isEqualToString:@"否"]) {
        is = NO;
    }else{
        is = YES;
    }
    [cell cellName:xiangxiM.name andImageURL:nil andHaoma:xiangxiM.account andBtn:is andBankOfZfb:xiangxiM.type];
    return cell;
}
//点击每行做什么事情
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    //取消选择
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    //线删除全部
    [self.xuanzheM removeAllObjects];
    //再添加
    [self.xuanzheM addObject:self.array[indexPath.row]];
    //先选择删除全部选择,在添加
    [self.xuanzheArray removeAllObjects];
    for (int i = 0 ; i < self.array.count; i++) {
        NSString *str = nil;
        if (i == indexPath.row) {
            str = @"是";
        }else{
            str = @"否";
        }
        [self.xuanzheArray addObject:str];
    }
    //刷新一行
    [tableView reloadData];
}
#pragma mark - 密码输入
-(void)mimashuruwangbi:(NSString *)str{
    [self.payment dismiss];
    //提现网络获取
    [MBProgressHUD showMessage:nil toView:self.view];
    NSString *url = [MLInterface sharedMLInterface].withdrawApply;
    [[MLUserInfo sharedMLUserInfo] loadUserInfoFromSanbox];
    MLWalletXiangxiModel *model = self.xuanzheM[0];
    NSString *passString = [MD5Tool md5:[str stringByAppendingString:@"rolle"]];
    NSDictionary *dict = @{@"token":[MLUserInfo sharedMLUserInfo].token,@"money":self.jine,@"password":passString,@"type":model.type,@"id":model.ID};
    [IWHttpTool postWithURL:url params:dict success:^(id json) {
        MLDizhiModel *dizi = [MLDizhiModel objectWithKeyValues:json];
        [MBProgressHUD hideHUDForView:self.view];
        if ([dizi.statusCode isEqualToString:@"200"]) {
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:nil message:dizi.message delegate:self cancelButtonTitle:@"继续提现" otherButtonTitles:@"退出",nil];
            [alert show];
        }else{
            [MBProgressHUD showError:dizi.message toView:self.view];
        }
    } failure:^(NSError *error) {
        [MBProgressHUD hideHUDForView:self.view];
        [MBProgressHUD showSuccess:@"请检查网络" toView:self.view];
    }];
}
-(void)mimashurucuowu{
    [self.payment dismiss];
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:nil message:@"密码错误" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
    [alert show];
}
-(void)dianjichongzhi{
    [self.payment dismiss];
    MLChongzhiMimaController *tianjiaC = [[MLChongzhiMimaController alloc] init];
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStyleDone target:nil action:nil];
    [self.navigationController pushViewController:tianjiaC animated:YES];
}
#pragma mark - 提现完成
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex == 1) {//退出
        [self.navigationController popToRootViewControllerAnimated:YES];
    }else{//继续提现
        [self.navigationController popViewControllerAnimated:YES];
    }
}
//界面消失完毕
-(void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
-(void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
@end
