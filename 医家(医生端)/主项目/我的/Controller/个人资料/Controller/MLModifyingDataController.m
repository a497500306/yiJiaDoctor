//
//  MLModifyingDataController.m
//  医家(医生端)
//
//  Created by 洛耳 on 15/7/20.
//  Copyright (c) 2015年 workorz. All rights reserved.
//

#import "MLModifyingDataController.h"
#import "MLInterface.h"
#import "MLUserInfo.h"
#import "IWHttpTool.h"
#import "MLDizhiModel.h"
#import "MJExtension.h"
#import "MLCoreDataTool.h"
#import "NewUser.h"
#import "MBProgressHUD+MJ.h"

@interface MLModifyingDataController (){
    //数据库文件
    NSManagedObjectContext *_context;
}
@property (nonatomic ,weak)UITextField *field;
@end

@implementation MLModifyingDataController

- (void)viewDidLoad {
    [super viewDidLoad];
    //标题
    self.title = self.model.name;
    if (self.isJibenxinxi == YES) {
        self.title = self.biaoti;
    }
    //设置右上角完成按钮
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"完成" style:UIBarButtonItemStylePlain target:self action:@selector(dianjiwangcheng)];
    //设置左上角取消按钮
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"取消" style:UIBarButtonItemStylePlain target:self action:@selector(dianjiquxiao)];
    self.view.backgroundColor = [UIColor whiteColor];
    //创建text
    UITextField *field = [[UITextField alloc] initWithFrame:CGRectMake(10, 84, [UIScreen mainScreen].bounds.size.width - 20, 44)];
    //设置清除按钮
    field.clearButtonMode = UITextFieldViewModeAlways;
    if (self.model.neirong == nil || self.model.neirong.length == 0) {
        //设置提示文字
        NSMutableDictionary *attrs1 = [NSMutableDictionary dictionary];
        attrs1[NSForegroundColorAttributeName] = [UIColor colorWithRed:196/255.0 green:196/255.0 blue:196/255.0 alpha:1];
        field.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"点击输入" attributes:attrs1];
    }else{
        field.text = self.model.neirong;
    }
    field.textColor = [UIColor blackColor];
    if (self.isJibenxinxi == YES) {
        if (self.neirong == nil || self.neirong.length == 0) {
            //设置提示文字
            NSMutableDictionary *attrs1 = [NSMutableDictionary dictionary];
            attrs1[NSForegroundColorAttributeName] = [UIColor colorWithRed:196/255.0 green:196/255.0 blue:196/255.0 alpha:1];
            field.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"点击输入" attributes:attrs1];
        }else{
            field.text = self.neirong;
        }
    }
    self.field = field;
    [self.view addSubview:field];
    //创建两根线
    UIView *xian1 = [[UIView alloc] initWithFrame:CGRectMake(0, 83, self.view.frame.size.width, 0.5)];
    xian1.backgroundColor = [UIColor colorWithRed:211/255.0 green:211/255.0 blue:211/255.0 alpha:1];
    [self.view addSubview:xian1];
    //创建两根线
    UIView *xian2 = [[UIView alloc] initWithFrame:CGRectMake(0, 84 + 44 + 1, self.view.frame.size.width, 0.5)];
    xian2.backgroundColor = [UIColor colorWithRed:211/255.0 green:211/255.0 blue:211/255.0 alpha:1];
    [self.view addSubview:xian2];
}

#pragma mark - 点击完成
-(void)dianjiwangcheng{
    self.model.neirong = self.field.text;
    [self.pdc.table reloadData];
    //网络刷新数据
    NSString *url = [MLInterface sharedMLInterface].saveDoctorDoctor;
    MLPersonalDataModel *dizhi = self.array[0];
    if (dizhi.neirong == nil) {
        dizhi.neirong = @"";
    }
    MLPersonalDataModel *yiyuan = self.array[1];
    if (yiyuan.neirong == nil) {
        yiyuan.neirong = @"";
    }
    MLPersonalDataModel *zhicheng = self.array[2];
    if (zhicheng.neirong == nil) {
        zhicheng.neirong = @"";
    }
    MLPersonalDataModel *keshi = self.array[3];
    if (keshi.neirong == nil) {
        keshi.neirong = @"";
    }
    MLPersonalDataModel *zhuangchang = self.array[4];
    if (zhuangchang.neirong == nil) {
        zhuangchang.neirong = @"";
    }
    if (self.isJibenxinxi == YES) {//基本信息
        //通知
        NSNotificationCenter *center = [NSNotificationCenter defaultCenter];
        NSDictionary *dict = @{@"内容":self.field.text};
        [center postNotificationName:@"内容" object:self userInfo:dict];
        [self dismissViewControllerAnimated:YES completion:nil];
    }else{//医生扩展信息
        [[MLUserInfo sharedMLUserInfo] loadUserInfoFromSanbox];
        NSDictionary *parameters = @{@"token":[MLUserInfo sharedMLUserInfo].token,@"hospitalName":yiyuan.neirong,@"speciality":zhuangchang.neirong};
        [IWHttpTool postWithURL:url params:parameters success:^(id json) {
            MLDizhiModel *model = [MLDizhiModel objectWithKeyValues:json];
            if ([model.statusCode isEqualToString:@"200"]) {
                [MBProgressHUD showSuccess:@"更新完成" toView:self.view];
                //数据保存到数据库
                NSString *name =  [NSString stringWithFormat:@"%@User.sqlite",[MLUserInfo sharedMLUserInfo].user];
                NSLog(@"%@",name);
                _context = [MLCoreDataTool chuanjianCoreData:name];//查询数据
                NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"NewUser"];
                NSArray* items = [_context executeFetchRequest:request error:nil];
                if (items.count > 0) {
                    //添加数据到模型
                    for (NewUser *fe in items) {
                        fe.workAddress = dizhi.neirong;
                        fe.hospitalName = yiyuan.neirong;
                        fe.doctorTitle = zhicheng.neirong;
                        fe.department = keshi.neirong;
                        fe.specialty = zhuangchang.neirong;
                    }
                    // 3.保存
                    [_context save:nil];
                }
            }
        } failure:^(NSError *error) {
            
        }];
    }
    [self dismissViewControllerAnimated:YES completion:nil];
}
#pragma mark - 点击取消
-(void)dianjiquxiao{
    [self dismissViewControllerAnimated:YES completion:nil];
}

//界面消失完毕
-(void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
-(void)dealloc{
    //清空通知,防止内存泄露
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
@end
