//
//  MLQianbaoController.m
//  医家(医生端)
//
//  Created by 洛耳 on 15/7/21.
//  Copyright (c) 2015年 workorz. All rights reserved.
//

#import "MLQianbaoController.h"
#import "MBProgressHUD+MJ.h"
#import "IWHttpTool.h"
#import "MLUserInfo.h"
#import "MJExtension.h"
#import "MLInterface.h"
#import "MLWalletModel.h"
#import "MLWalletXiangxiModel.h"
#import "MLBangdingCell.h"
#import "MLTianjiaController.h"
#import "MLZhangdanController.h"
#import "MLTixianController.h"
#import "ZSDPaymentView.h"

@interface MLQianbaoController ()<UITableViewDataSource,UITableViewDelegate,ZSDPaymentViewDelegate>
@property (nonatomic ,strong)NSMutableArray *array;
@property (nonatomic ,weak)UITableView *table;
@property (nonatomic ,strong)MLWalletModel *wanlletM;
@property (nonatomic ,weak)ZSDPaymentView *payment;
@end

@implementation MLQianbaoController
-(NSMutableArray *)array{
    if (_array == nil) {
        _array = [NSMutableArray array];
        return _array;
    }
    return _array;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    //不透明
    self.navigationController.navigationBar.translucent = NO;
    //设置右上角取消按钮
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"账单" style:UIBarButtonItemStylePlain target:self action:@selector(dianjizhandan)];
    self.title = @"钱包";
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    self.view.backgroundColor = [UIColor colorWithRed:239/255.0 green:239/255.0 blue:239/255.0 alpha:1];
    //显示table
    UITableView *table = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, self.view.frame.size.height - 64)];
    table.delegate = self;
    table.dataSource = self;
    table.rowHeight = 60;
    //设置分割线包含整个宽度
    [table setSeparatorInset:UIEdgeInsetsZero];
    [table setLayoutMargins:UIEdgeInsetsZero];
    table.backgroundColor = [UIColor colorWithRed:239/255.0 green:239/255.0 blue:239/255.0 alpha:1];
    //添加底部按钮
    UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 60)];
    btn.backgroundColor = [UIColor whiteColor];
    [btn addTarget:self action:@selector(dianjitianjia) forControlEvents:UIControlEventTouchUpInside];
    //线
    UIView *xian1 = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 0.5)];
    xian1.backgroundColor = [UIColor colorWithRed:188/255.0 green:186/255.0 blue:193/255.0 alpha:1];
    [btn addSubview:xian1];
    UIView *xian2 = [[UIView alloc] initWithFrame:CGRectMake(0, 59, self.view.frame.size.width, 0.5)];
    xian2.backgroundColor = [UIColor colorWithRed:188/255.0 green:186/255.0 blue:193/255.0 alpha:1];
    [btn addSubview:xian2];
    //添加加号
    UIImageView *iamge = [[UIImageView alloc]initWithFrame:CGRectMake(25, 20, 20, 20)];
    iamge.image = [UIImage imageNamed:@"btn－添加卡"];
    [btn addSubview:iamge];
    //添加文字
    UILabel *lable = [[UILabel alloc] initWithFrame:CGRectMake(iamge.frame.origin.x + iamge.frame.size.width + 25, 0, self.view.frame.size.width - iamge.frame.size.width, 60)];
    lable.text = @"添加支付宝/银行卡";
    [btn addSubview:lable];
    table.tableFooterView = btn;
    self.table = table;
    [self.view addSubview:table];
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [MBProgressHUD showMessage:nil toView:self.view];
    //网络获取数据
    NSString *url = [MLInterface sharedMLInterface].getWalletByToken;
    [[MLUserInfo sharedMLUserInfo] loadUserInfoFromSanbox];
    NSDictionary *dict = @{@"token":[MLUserInfo sharedMLUserInfo].token};
    [IWHttpTool postWithURL:url params:dict success:^(id json) {
        [MBProgressHUD hideHUDForView:self.view];
        MLWalletModel *model = [MLWalletModel objectWithKeyValues:json];
        self.wanlletM = model;
        if ([model.statusCode isEqualToString:@"200"]) {
            if ([model.password isEqualToString:@"password"]) {
            }else{
                //弹出输入密码界面
                ZSDPaymentView *payment = [[ZSDPaymentView alloc]init];
                payment.title = @"支付密码";
                payment.goodsName = @"设置6位数的提现密码";
                payment.isChongzhi = NO;
                //                payment.amount = [self.jine floatValue];
                payment.delegate = self;
                self.payment = payment;
                [payment show];
            }
            //ID转换
            [MLWalletXiangxiModel setupReplacedKeyFromPropertyName:^NSDictionary *{
                return @{@"ID":@"id"};
            }];
            NSMutableArray *array = [MLWalletXiangxiModel objectArrayWithKeyValuesArray:model.list];
            self.array = array;
            [self.table reloadData];
        }else if ([model.statusCode isEqualToString:@"310"]) {
            //这里做注销操作
            [[MLUserInfo sharedMLUserInfo] loadUserInfoFromSanbox];
            [MLUserInfo sharedMLUserInfo].user = nil;
            [MLUserInfo sharedMLUserInfo].pwd = nil;
            [MLUserInfo sharedMLUserInfo].loginStatus = YES;
            [[MLUserInfo sharedMLUserInfo] saveUserInfoToSanbox];
            //跳转到登陆界面
            UIStoryboard *storayobard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
            self.view.window.rootViewController = storayobard.instantiateInitialViewController;
        }else {
            [MBProgressHUD showError:model.message toView:self.view];
        }
        NSLog(@"%@,%@",json,json[@"message"]);
    } failure:^(NSError *error) {
        NSLog(@"失败");
        [MBProgressHUD hideHUDForView:self.view];
        [MBProgressHUD showError:@"请检查网络" toView:self.view];
    }];
}
//每组又多少行
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.array.count + 1;
}
//每行显示什么内容
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row > 0) {
        static NSString *MLID = @"MLCell";
        MLBangdingCell *cell = [tableView dequeueReusableCellWithIdentifier:MLID];
        if (cell == nil) {
            cell = [[MLBangdingCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:MLID];
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        MLWalletXiangxiModel *xiangxiM = self.array[indexPath.row - 1];
        [cell cellName:xiangxiM.name andHaoma:xiangxiM.account andImageURL:nil andUserNmae:xiangxiM.userName andBankOfZfb:xiangxiM.type];
        return cell;
    }else{
        UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:nil];
        UIImageView *image = [[UIImageView alloc] initWithFrame:CGRectMake(10, 5, 50, 50)];
        image.image = [UIImage imageNamed:@"icon－总额"];
        [cell.contentView addSubview:image];
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(self.view.frame.size.width - 165, 0, 150, 60)];
        if (self.wanlletM != nil) {
            label.text =[NSString stringWithFormat:@"￥%@",self.wanlletM.accountAmount];
        }
        label.font = [UIFont systemFontOfSize:25];
        label.textColor = [UIColor colorWithRed:34/255.0 green:120/255.0 blue:240/255.0 alpha:1];
        label.textAlignment = NSTextAlignmentRight;
        [cell.contentView addSubview:label];
        return cell;
    }
}
//点击每行做什么事情
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    //取消选择
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    if (indexPath.row == 0) {//点击余额
        MLTixianController *tianjiaC = [[MLTixianController alloc] init];
        tianjiaC.wallerM = self.wanlletM;
        tianjiaC.array = self.array;
        self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStyleDone target:nil action:nil];
        [self.navigationController pushViewController:tianjiaC animated:YES];
    }else{
    
    }
}
#pragma mark - 设置密码代理
-(void)mimashuruwangbi:(NSString *)str{
    [self.payment dismiss];
    //网络设置密码
    NSString *url =  [MLInterface sharedMLInterface].setPassword;
    [[MLUserInfo sharedMLUserInfo] loadUserInfoFromSanbox];
    NSDictionary *dict = @{@"tokem":[MLUserInfo sharedMLUserInfo].token,@"password":str};
    [IWHttpTool postWithURL:url params:dict success:^(id json) {
        NSLog(@"%@",json[@"message"]);
    } failure:^(NSError *error) {
        
    }];
}
-(void)mimashurucuowu{
    [self.payment dismiss];
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:nil message:@"密码错误" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
    [alert show];
}
//设置分割线包含整个宽度
-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath

{
    [cell setSeparatorInset:UIEdgeInsetsZero];
    [cell setLayoutMargins:UIEdgeInsetsZero];
}
#pragma mark - 点击添加按钮
-(void)dianjitianjia{
    MLTianjiaController *tianjiaC = [[MLTianjiaController alloc] init];
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStyleDone target:nil action:nil];
    [self.navigationController pushViewController:tianjiaC animated:YES];
}
#pragma mark - 点击账单
-(void)dianjizhandan{
    MLZhangdanController *tianjiaC = [[MLZhangdanController alloc] init];
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStyleDone target:nil action:nil];
    [self.navigationController pushViewController:tianjiaC animated:YES];

}
@end
