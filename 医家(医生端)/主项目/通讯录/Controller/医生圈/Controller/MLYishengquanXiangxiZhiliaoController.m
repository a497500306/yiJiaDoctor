//
//  MLYishengquanXiangxiZhiliaoController.m
//  医家(医生端)
//
//  Created by 洛耳 on 15/7/29.
//  Copyright (c) 2015年 workorz. All rights reserved.
//

#import "MLYishengquanXiangxiZhiliaoController.h"
#import "IWHttpTool.h"
#import "MLInterface.h"
#import "MJExtension.h"
#import "MLUserInfo.h"
#import "MBProgressHUD+MJ.h"
#import "MLDizhiModel.h"
#import "MJRefresh.h"
#import "MLYishengquanLBModel.h"
#import "MLUserZhuangtaiModel.h"
#import "MLDoctorDetailModel.h"
#import "MLGerenXinxiModel.h"
#import "MLMyModel.h"
#import "MLCoreDataTool.h"
#import "DoctorCircle.h"
#import "UIScrollView+PullScale.h"
#import "CorePullScaleImageView.h"
#import "UIImageView+WebCache.h"

@interface MLYishengquanXiangxiZhiliaoController ()<UITableViewDataSource,UITableViewDelegate>{
    //数据库文件
    NSManagedObjectContext *_context;
}
@property (nonatomic ,strong)MLMyModel *mm;
@property (nonatomic ,weak)UITableView *table;

@end

@implementation MLYishengquanXiangxiZhiliaoController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"详细资料";
    //初始化
    [self chushihua];
    [self quchushujuku];
    //网络
    [self wangluo];
}
#pragma mark - 初始化
-(void)chushihua{
    //创建table
    UITableView *table = [[UITableView alloc] initWithFrame:CGRectMake(0, -64, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height)];
    table.delegate = self;
    table.dataSource = self;
    //创建头部空间
    UIImageView *view = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 264)];
    NSString *str = [NSString stringWithFormat:@"http://rolle.cn:8080%@",self.mm.headImage];
    [view sd_setImageWithURL:[NSURL URLWithString:str] placeholderImage:[UIImage imageNamed:@"icon－默认头像"]];
    //设置模式
    view.contentMode=UIViewContentModeScaleAspectFill;
    //剪切
    view.clipsToBounds=YES;
    table.tableHeaderView = view;
    self.table = table;
    [self.view addSubview:table];
}
#pragma mark - 网络
-(void)wangluo{
    NSString *url = [MLInterface sharedMLInterface].getUserByMapqita;
    [[MLUserInfo sharedMLUserInfo] loadUserInfoFromSanbox];
    NSDictionary *dict = @{@"token":[MLUserInfo sharedMLUserInfo].token,@"userId":self.model.ID};
    __weak typeof(self) weakSelf = self;
    [IWHttpTool postWithURL:url params:dict success:^(id json) {
        NSLog(@"%@",json);
        MLUserZhuangtaiModel *userM = [MLUserZhuangtaiModel objectWithKeyValues:json];
        if ([userM.statusCode isEqualToString:@"200"]) {
            [MLGerenXinxiModel setupReplacedKeyFromPropertyName:^NSDictionary *{
                return @{@"ID":@"id"};
            }];
            MLGerenXinxiModel *gxM = [MLGerenXinxiModel objectWithKeyValues:userM.user];
            [MLDoctorDetailModel setupReplacedKeyFromPropertyName:^NSDictionary *{
                return @{@"ID":@"id"};
            }];
            MLDoctorDetailModel *ddM = [MLDoctorDetailModel objectWithKeyValues:gxM.doctorDetail];
            MLMyModel *mm = [[MLMyModel alloc] init];
            mm.headImage = gxM.headImage;
            mm.nickname = gxM.nickname;
            mm.qrCode = gxM.qrCode;
            mm.intro = gxM.intro;
            //地址需要拼接
            NSString *str = [NSString stringWithFormat:@"%@%@",ddM.jobAddress,ddM.workAddress];
            mm.workAddress = str;
            mm.hospitalName = ddM.hospitalName;
            mm.doctorTitle = ddM.doctorTitle;
            mm.department = ddM.department;
            mm.doctorTitle = ddM.doctorTitle;
            mm.department = ddM.department;
            mm.specialty =ddM.speciality;
            mm.idImage = ddM.idImage;
            mm.businessLicense = ddM.businessLicense;
            mm.isAudit = gxM.isAudit;
            mm.sex = gxM.sex;
            mm.birthday = gxM.birthday;
            mm.age = gxM.age;
            weakSelf.mm = mm;
            //刷新table
            [weakSelf.table reloadData];
            //刷新数据库(子线程刷新数据库)
            dispatch_group_t group = dispatch_group_create();
            dispatch_group_async(group, dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                //刷新数据库
                [weakSelf shuaxinshuju];
            });
        }else if ([userM.statusCode isEqualToString:@"310"]){
            //这里做注销操作
            [[MLUserInfo sharedMLUserInfo] loadUserInfoFromSanbox];
            [MLUserInfo sharedMLUserInfo].user = nil;
            [MLUserInfo sharedMLUserInfo].pwd = nil;
            [MLUserInfo sharedMLUserInfo].loginStatus = YES;
            [[MLUserInfo sharedMLUserInfo] saveUserInfoToSanbox];
            //跳转到登陆界面
            UIStoryboard *storayobard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
            weakSelf.view.window.rootViewController = storayobard.instantiateInitialViewController;
        }else{
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:nil message:userM.message delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
            [alert show];
        }
    } failure:^(NSError *error) {//提示检查网络
        [MBProgressHUD showError:@"请检查网络" toView:self.view];
    }];

}
#pragma mark - 数据库操作
//取出数据库保存的信息
-(void)quchushujuku{
    [[MLUserInfo sharedMLUserInfo] loadUserInfoFromSanbox];
    NSString *name =  [NSString stringWithFormat:@"%@User.sqlite",[MLUserInfo sharedMLUserInfo].user];
    _context = [MLCoreDataTool chuanjianCoreData:name];//查询数据
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"DoctorCircle"];
    NSPredicate *pre = [NSPredicate predicateWithFormat:@"iD = %@",
                        self.model.ID];
    request.predicate = pre;
    NSArray* items = [_context executeFetchRequest:request error:nil];
    if (items.count > 0) {
        //添加数据到模型
        for (DoctorCircle *fe in items) {
            MLMyModel *mm = [[MLMyModel alloc] init];
            mm.headImage = fe.headImage;
            mm.nickname = fe.nickName;
            mm.qrCode = fe.qrCode;
            mm.intro = fe.intro;
            mm.workAddress = fe.workAddress;
            mm.hospitalName = fe.hospitalName;
            mm.doctorTitle = fe.doctorTitle;
            mm.department = fe.department;
            mm.doctorTitle = fe.doctorTitle;
            mm.department = fe.department;
            mm.specialty = fe.specialty;
            mm.idImage = fe.idImage;
            mm.businessLicense = fe.businessLicense;
            mm.isAudit = fe.isAudit;
            mm.sex = fe.sex;
            mm.birthday = fe.birthday;
            mm.age = fe.age;
            self.mm = mm;
        }
        // 3.保存
        [_context save:nil];
    }
}
//刷新数据库
-(void)shuaxinshuju{
    //查询数据
    [[MLUserInfo sharedMLUserInfo] loadUserInfoFromSanbox];
    NSString *name =  [NSString stringWithFormat:@"%@User.sqlite",[MLUserInfo sharedMLUserInfo].user];
    _context = [MLCoreDataTool chuanjianCoreData:name];//查询数据
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"DoctorCircle"];
    NSPredicate *pre = [NSPredicate predicateWithFormat:@"iD = %@",
                        self.model.ID];
    request.predicate = pre;
    // 1.3执行请求
    NSArray *emps = [_context executeFetchRequest:request error:nil];
    // 2.更新身高
    for (DoctorCircle *fe in emps) {
        fe.headImage =  self.mm.headImage;
        fe.nickName = self.mm.nickname;
        fe.qrCode = self.mm.qrCode;
        fe.intro = self.mm.intro;
        fe.workAddress = self.mm.workAddress;
        fe.hospitalName = self.mm.hospitalName;
        fe.doctorTitle = self.mm.doctorTitle;
        fe.department = self.mm.department;
        fe.doctorTitle = self.mm.doctorTitle;
        fe.department = self.mm.department;
        fe.specialty = self.mm.specialty;
        fe.idImage = self.mm.idImage;
        fe.businessLicense = self.mm.businessLicense;
        fe.isAudit = self.mm.isAudit;
        fe.sex = self.mm.sex;
        fe.birthday = self.mm.birthday;
        fe.age = self.mm.age;
    }
    // 3.保存
    [_context save:nil];
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
#warning Potentially incomplete method implementation.
    // Return the number of sections.
    return 0;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
#warning Incomplete method implementation.
    // Return the number of rows in the section.
    return 0;
}
@end
