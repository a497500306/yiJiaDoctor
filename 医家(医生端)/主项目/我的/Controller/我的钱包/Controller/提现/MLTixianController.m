//
//  MLTixianController.m
//  医家(医生端)
//
//  Created by 洛耳 on 15/7/23.
//  Copyright (c) 2015年 workorz. All rights reserved.
//

#import "MLTixianController.h"
#import "MLWalletModel.h"
#import "MLZhangdanController.h"
#import "MLShuruJingeController.h"
#import "MBProgressHUD+MJ.h"
#import "IWHttpTool.h"
#import "MLUserInfo.h"
#import "MJExtension.h"
#import "MLInterface.h"
@interface MLTixianController ()
@property (nonatomic ,weak)UILabel *yue;
@property (nonatomic ,weak)UIButton *btn;

@end

@implementation MLTixianController
-(NSMutableArray *)array{
    if (_array == nil) {
        _array = [NSMutableArray array];
        return _array;
    }
    return _array;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"提现";
    //设置右上角取消按钮
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"账单" style:UIBarButtonItemStylePlain target:self action:@selector(dianjizhandan)];
    //初始化
    [self chushihua];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    //网络获取数据
    NSString *url = [MLInterface sharedMLInterface].getWalletByToken;
    [[MLUserInfo sharedMLUserInfo] loadUserInfoFromSanbox];
    NSDictionary *dict = @{@"token":[MLUserInfo sharedMLUserInfo].token};
    [MBProgressHUD showMessage:@"刷新最新金额" toView:self.view];
    [IWHttpTool postWithURL:url params:dict success:^(id json) {
        [MBProgressHUD hideHUDForView:self.view];
        MLWalletModel *model = [MLWalletModel objectWithKeyValues:json];
        self.wallerM = model;
        NSString *str = [NSString stringWithFormat:@"￥%@",self.wallerM.accountAmount];
        self.yue.text = str;
        double i = [self.wallerM.accountAmount doubleValue];
        if (i == 0) {
            [self.btn setTitle:@"不可提现" forState:UIControlStateNormal];
            self.btn.backgroundColor = [UIColor colorWithRed:190/255.0 green:190/255.0 blue:190/255.0 alpha:1];
            self.btn.enabled = NO;
        }else{
            [self.btn setTitle:@"提现" forState:UIControlStateNormal];
            self.btn.backgroundColor = [UIColor colorWithRed:35/255.0 green:120/255.0 blue:240/255.0 alpha:1];
            self.btn.enabled = YES;
        }

    } failure:^(NSError *error) {
        [MBProgressHUD hideHUDForView:self.view];
        [MBProgressHUD showError:@"请检查网络" toView:self.view];
    }];
}
#pragma mark - 初始化
-(void)chushihua{
    self.view.backgroundColor = [UIColor colorWithRed:239/255.0 green:239/255.0 blue:239/255.0 alpha:1];
    //创建图标
    UIImageView *image = [[UIImageView alloc] initWithFrame:CGRectMake(([UIScreen mainScreen].bounds.size.width / 2 ) - 40, 20, 80, 80)];
    image.image = [UIImage imageNamed:@"icon－总额"];
    [self.view addSubview:image];
    //钱包总额
    UILabel *lable = [[UILabel alloc] initWithFrame:CGRectMake(0, image.frame.size.height + image.frame.origin.y , [UIScreen mainScreen].bounds.size.width, 30)];
    lable.font  = [UIFont systemFontOfSize:14];
    lable.textColor = [UIColor colorWithRed:188/255.0 green:188/255.0 blue:188/255.0 alpha:1];
    lable.textAlignment = NSTextAlignmentCenter;
    lable.text = @"钱包总额(元)";
    [self.view addSubview:lable];
    //余额
    UILabel *yue = [[UILabel alloc] initWithFrame:CGRectMake(lable.frame.origin.x, lable.frame.size.height + lable.frame.origin.y, lable.frame.size.width, 50)];
    yue.textAlignment = NSTextAlignmentCenter;
    NSString *str = [NSString stringWithFormat:@"￥%@",self.wallerM.accountAmount];
    yue.text = str;
    yue.font = [UIFont systemFontOfSize:30];
    self.yue = yue;
    [self.view addSubview:yue];
    //创建提现按钮
    UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(20, yue.frame.origin.y + yue.frame.size.height + 10, [UIScreen mainScreen].bounds.size.width - 40, 40)];
    double i = [self.wallerM.accountAmount doubleValue];
    if (i == 0) {
        [btn setTitle:@"不可提现" forState:UIControlStateNormal];
        btn.backgroundColor = [UIColor colorWithRed:190/255.0 green:190/255.0 blue:190/255.0 alpha:1];
        btn.enabled = NO;
    }else{
        [btn setTitle:@"提现" forState:UIControlStateNormal];
        btn.backgroundColor = [UIColor colorWithRed:35/255.0 green:120/255.0 blue:240/255.0 alpha:1];
        btn.enabled = YES;
    }
    [btn addTarget:self action:@selector(dianjitixian) forControlEvents:UIControlEventTouchUpInside];
    btn.layer.cornerRadius = 3;
    btn.layer.masksToBounds = YES;
    self.btn = btn;
    [self.view addSubview:btn];
}
#pragma mark - 点击提现
-(void)dianjitixian{
    MLShuruJingeController *tianjiaC = [[MLShuruJingeController alloc] init];
    tianjiaC.walletM = self.wallerM;
    tianjiaC.array =self.array;
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
