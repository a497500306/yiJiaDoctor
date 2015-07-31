//
//  MLAddressController.m
//  医家(医生端)
//
//  Created by 洛耳 on 15/7/20.
//  Copyright (c) 2015年 workorz. All rights reserved.
//

#import "MLAddressController.h"
#import "IWHttpTool.h"
#import "MLInterface.h"
#import "MLDizhiModel.h"
#import "MJExtension.h"
#import "MLDizhiXiangxiModel.h"
#import "MBProgressHUD+MJ.h"
#import "MLUserInfo.h"
#import "MLXianxiDizhiController.h"

@interface MLAddressController ()<UITableViewDataSource,UITableViewDelegate>
@property (nonatomic ,strong)NSMutableArray *array;
@property (nonatomic ,weak)UITableView *table;
@end

@implementation MLAddressController
-(NSMutableArray *)array{
    if (_array == nil) {
        _array = [NSMutableArray array];
        return _array;
    }
    return _array;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"工作地址";
    self.view.backgroundColor = [UIColor whiteColor];
    //设置右上角取消按钮
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"取消" style:UIBarButtonItemStylePlain target:self action:@selector(dianjiquxiao)];
    //初始化
    [self chushihua];
    //网络获取
    [self wangluo];
}
-(void)wangluo{
    NSString *url = [MLInterface sharedMLInterface].getRegionByParentId;
    NSDictionary *parameters =  nil;
    if (self.ID == nil || self.ID.length == 0) {
        parameters = @{@"parentId":@"1"};
    }else{
        parameters = @{@"parentId":self.ID};
    }
    [MBProgressHUD showMessage:nil toView:self.view];
    [IWHttpTool postWithURL:url params:parameters success:^(id json) {
        //取消等待
        [MBProgressHUD hideHUDForView:self.view];
        MLDizhiModel *model = [MLDizhiModel objectWithKeyValues:json];
        if ([model.statusCode isEqualToString:@"200"]) {
            [MLDizhiXiangxiModel setupReplacedKeyFromPropertyName:^NSDictionary *{
                return @{@"ID":@"id"};
            }];
            NSMutableArray *array = [MLDizhiXiangxiModel objectArrayWithKeyValuesArray:model.list];
            self.array = array;
            [self.table reloadData];
        }else if ([model.statusCode isEqualToString:@"310"]){
            //这里做注销操作
            [[MLUserInfo sharedMLUserInfo] loadUserInfoFromSanbox];
            [MLUserInfo sharedMLUserInfo].user = nil;
            [MLUserInfo sharedMLUserInfo].pwd = nil;
            [MLUserInfo sharedMLUserInfo].loginStatus = YES;
            [[MLUserInfo sharedMLUserInfo] saveUserInfoToSanbox];
            //跳转到登陆界面
            UIStoryboard *storayobard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
            self.view.window.rootViewController = storayobard.instantiateInitialViewController;
        }else{
            [MBProgressHUD showError:model.message toView:self.view];
        }
    } failure:^(NSError *error) {
        //取消等待
        [MBProgressHUD hideHUDForView:self.view];
        //检查网络
        [MBProgressHUD showError:@"请检查网络" toView:self.view];
        
    }];
}
#pragma mark - 初始化
-(void)chushihua{
    UITableView *table = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, self.view.frame.size.height)];
    table.delegate = self;
    table.dataSource = self;
    self.table = table;
    [self.view addSubview:table];
}
#pragma mark - UITableView代理和数据源方法
//多少行
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.array.count;
}
//每行显示什么内容
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *ID = @"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
    }
    MLDizhiXiangxiModel *dizhi = self.array[indexPath.row];
    cell.textLabel.text = dizhi.name;
    return cell;
}
//点击每行做什么事情
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    MLDizhiXiangxiModel *model = self.array[indexPath.row];
    if (self.jibie == 2) {
        //设置完成,发送通知
        MLXianxiDizhiController *nf = [[MLXianxiDizhiController alloc] init];
        nf.dizhi = self.dizhi;
        nf.ID = model.ID;
        nf.hidesBottomBarWhenPushed=YES;
        [self.navigationController pushViewController:nf animated:YES];
        self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStyleDone target:nil action:nil];
        return;
    }
    MLAddressController *mdc = [[MLAddressController alloc] init];
    if (self.dizhi == nil) {
        mdc.dizhi = [NSString stringWithFormat:@"%@",model.name];
    }else{
        mdc.dizhi = [NSString stringWithFormat:@"%@%@",self.dizhi,model.name];
    }
    mdc.jibie = self.jibie + 1;
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStyleDone target:nil action:nil];
    mdc.ID = model.ID;
    [self.navigationController pushViewController:mdc animated:YES];
}
#pragma mark - 点击取消
-(void)dianjiquxiao{
    [self dismissViewControllerAnimated:YES completion:nil];
}
@end
