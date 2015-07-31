//
//  MLPersonalDataController.m
//  医家(医生端)
//
//  Created by 洛耳 on 15/7/17.
//  Copyright (c) 2015年 workorz. All rights reserved.
//

#import "MLPersonalDataController.h"
#import "MLImageNameCell.h"
#import "UIImageView+WebCache.h"
#import "MLMyModel.h"
#import "MLPersonalDataModel.h"
#import "MLAddressController.h"
#import "MLModifyingDataController.h"
#import "MLInterface.h"
#import "MLJibenXinxiController.h"
#import "MBProgressHUD+MJ.h"
#import "IWHttpTool.h"
#import "MLUserInfo.h"
#import "MJExtension.h"
#import "MLDizhiModel.h"
#import "MLCoreDataTool.h"
#import "MLGerenXinxiModel.h"
#import "MLUserZhuangtaiModel.h"
#import "MLDoctorDetailModel.h"
#import "NewUser.h"
#import "MLXuanzheController.h"

#define zhiti 15
@interface MLPersonalDataController ()<UITableViewDataSource,UITableViewDelegate>{
    //数据库文件
    NSManagedObjectContext *_context;
}
@property (nonatomic ,strong)NSArray *diyizhuArray;
@property (nonatomic ,strong)NSArray *dierzhuArray;
@property (nonatomic ,assign)BOOL shifoukedian;
@end

@implementation MLPersonalDataController
-(NSArray *)diyizhuArray{
    if (_diyizhuArray == nil) {
        _diyizhuArray = [NSArray array];
        return _diyizhuArray;
    }
    return _diyizhuArray;
}
-(NSArray *)dierzhuArray {
    if (_dierzhuArray == nil) {
        _dierzhuArray = [NSArray array];
        return _dierzhuArray;
    }
    return _dierzhuArray;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    //设置头部标题
    self.title = @"个人资料";
    //初始化
    [self chushihua];
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [[MLUserInfo sharedMLUserInfo] loadUserInfoFromSanbox];
    //网络获取数据
    NSDictionary *parameters = @{@"token":[MLUserInfo sharedMLUserInfo].token};
    NSString *url = [MLInterface sharedMLInterface].getUserByToken;
    [IWHttpTool postWithURL:url params:parameters success:^(id json) {
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
            mm.workAddress = ddM.workAddress;
            mm.hospitalName = ddM.hospitalName;
            mm.doctorTitle = ddM.doctorTitle;
            mm.department = ddM.department;
            mm.doctorTitle = ddM.doctorTitle;
            mm.department = ddM.department;
            mm.specialty = ddM.specialty;
            mm.idImage = ddM.idImage;
            mm.businessLicense = ddM.businessLicense;
            mm.isAudit = gxM.isAudit;
            mm.sex = gxM.sex;
            mm.birthday = gxM.birthday;
            mm.age = gxM.age;
            self.mm = mm;
            [self.table reloadData];
        }else if ([userM.statusCode isEqualToString:@"310"]){
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
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:nil message:userM.message delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
            [alert show];
        }
    } failure:^(NSError *error) {//提示检查网络
        [MBProgressHUD showError:@"请检查网络" toView:self.view];
    }];
}
#pragma mark - 初始化
-(void)chushihua{
    //创建TbaleView
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector (dizhi:) name:@"地址" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector (jianjie:) name:@"内容" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector (xuanzhe:) name:@"xuanzhe" object:nil];
    UITableView *table = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, self.view.frame.size.height) style:UITableViewStyleGrouped];
    table.backgroundColor = [UIColor colorWithRed:239/255.0 green:239/255.0 blue:239/255.0 alpha:1];
    table.delegate = self;
    table.dataSource = self;
    //设置分割线包含整个宽度
    [table setSeparatorInset:UIEdgeInsetsZero];
    [table setLayoutMargins:UIEdgeInsetsZero];
    self.table = table;
    [self.view addSubview:table];
    //设置右上角的按钮
//    UIBarButtonItem *youBtnBarItem = [[UIBarButtonItem alloc] initWithTitle:@"编辑" style:UIBarButtonItemStyleDone target:self action:@selector(dianjibianji:)];
//    self.navigationItem.rightBarButtonItem = youBtnBarItem;
    //设置数据
    MLPersonalDataModel *model1 = [[MLPersonalDataModel alloc] initWithName:@"简介" andNeirong:self.mm.intro];
    MLPersonalDataModel *model2 = [[MLPersonalDataModel alloc] initWithName:@"工作地址" andNeirong:self.mm.workAddress];
    MLPersonalDataModel *model3 = [[MLPersonalDataModel alloc] initWithName:@"所在医院" andNeirong:self.mm.hospitalName];
    MLPersonalDataModel *model4 = [[MLPersonalDataModel alloc] initWithName:@"医生职称" andNeirong:self.mm.doctorTitle];
    MLPersonalDataModel *model5 = [[MLPersonalDataModel alloc] initWithName:@"所在科室" andNeirong:self.mm.department];
    MLPersonalDataModel *model6 = [[MLPersonalDataModel alloc] initWithName:@"专长" andNeirong:self.mm.specialty];
    NSArray *diyizhuArray = @[model1];
    NSArray *dierzhuArray = @[model2,model3,model4,model5,model6];
    self.diyizhuArray = diyizhuArray;
    self.dierzhuArray = dierzhuArray;
}
#pragma mark - 地址通知
-(void)dizhi:(NSNotification *)aNotification{
    NSDictionary *info = [aNotification userInfo];
    NSString *str = [info objectForKey:@"地址"];
    NSString *ID = [info objectForKey:@"ID"];
    NSString *xiangxi = [info objectForKey:@"详细地址"];
    //设置工作地址模型
    MLPersonalDataModel *model = self.dierzhuArray[0];
    NSString *dizhi = [NSString stringWithFormat:@"%@%@",str,xiangxi];
    model.neirong = dizhi;
    //网络保存地址
    NSString *url = [MLInterface sharedMLInterface].saveDoctorDoctor;
    [[MLUserInfo sharedMLUserInfo] loadUserInfoFromSanbox];
    NSDictionary *parameters = @{@"token":[MLUserInfo sharedMLUserInfo].token,@"workRegionId":ID,@"workAddress":xiangxi};
    [IWHttpTool postWithURL:url params:parameters success:^(id json) {
        MLDizhiModel *model = [MLDizhiModel objectWithKeyValues:json];
        if ([model.statusCode isEqualToString:@"200"]) {
            [MBProgressHUD showSuccess:model.message toView:self.view];
        }
    } failure:^(NSError *error) {
        [MBProgressHUD showError:@"请检查网络" toView:self.view];
    }];

    [self.table reloadData];
    
}
#pragma mark - 选择界面
-(void)xuanzhe:(NSNotification *)aNotification{
    NSDictionary *info = [aNotification userInfo];
    NSString *ID = [info objectForKey:@"ID"];
    NSString *name = [info objectForKey:@"name"];
    NSString *viewName = [info objectForKey:@"ViewName"];
    //网络保存地址
    NSString *url = [MLInterface sharedMLInterface].saveDoctorDoctor;
    [[MLUserInfo sharedMLUserInfo] loadUserInfoFromSanbox];
    NSDictionary *parameters = nil;
    if ([viewName isEqualToString:@"所在科室"]) {
        MLPersonalDataModel *keshi = self.dierzhuArray[3];
        keshi.neirong = name;
        parameters = @{@"token":[MLUserInfo sharedMLUserInfo].token,@"departmentsId":ID};
    }else {
        MLPersonalDataModel *zhicheng = self.dierzhuArray[2];
        zhicheng.neirong = name;
        parameters = @{@"token":[MLUserInfo sharedMLUserInfo].token,@"jobId":ID};
    }
    [IWHttpTool postWithURL:url params:parameters success:^(id json) {
        MLDizhiModel *model = [MLDizhiModel objectWithKeyValues:json];
        if ([model.statusCode isEqualToString:@"200"]) {
            [MBProgressHUD showSuccess:model.message toView:self.view];
        }
    } failure:^(NSError *error) {
        [MBProgressHUD showError:@"请检查网络" toView:self.view];
    }];
    
    [self.table reloadData];
}
#pragma mark - 简介通知
-(void)jianjie:(NSNotification *)aNotification{
    NSDictionary *info = [aNotification userInfo];
    NSString *str = [info objectForKey:@"内容"];
    self.mm.intro = str;
    [self.table reloadData];
    //网络上传数据
    NSString *url = [MLInterface sharedMLInterface].saveDoctor;
    [[MLUserInfo sharedMLUserInfo] loadUserInfoFromSanbox];
    NSDictionary *parameters = @{@"token":[MLUserInfo sharedMLUserInfo].token, @"typeId":@"3",@"intro":self.mm.intro};
    [IWHttpTool postWithURL:url params:parameters success:^(id json) {
        MLDizhiModel *model = [MLDizhiModel objectWithKeyValues:json];
        if ([model.statusCode isEqualToString:@"200"]) {
            [MBProgressHUD showSuccess:model.message toView:self.view];
        }
    } failure:^(NSError *error) {
        
    }];
}
#pragma mark - table代理和数据源方法
//有多少组
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}
//每组有多少行
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section == 0) {
        return 2;
    }else{
        return 5;
    }
}
//每行显示什么内容
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0 && indexPath.row == 0) {//显示个人基本信息
        MLImageNameCell *iamgNmageCell = [[MLImageNameCell alloc] init];
        //取出年龄和性别
        NSString *xingbie = nil;
        if ([self.mm.sex isEqualToString:@"1"]) {//性别
            xingbie = @"男";
        }else{
            xingbie = @"女";
        }
        //两个日期之间相隔多少秒
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat: @"yyyy-MM-dd"];
        NSDate *destDate= [dateFormatter dateFromString:self.mm.birthday];
        NSTimeInterval secondsInterval= [[NSDate date] timeIntervalSinceDate:destDate];
        NSTimeInterval nian = secondsInterval / 60 / 60 /24 / 365;
        NSInteger nianling = nian / 1;
        NSString *nianlingStr = [NSString stringWithFormat:@"%ld",(long)nianling];
        if (self.mm.birthday == nil) {
            [iamgNmageCell image:[UIImage imageNamed:@"icon－默认头像"] andName:self.mm.nickname andZhengjian:[UIImage imageNamed:@"btn－上传图"] andNianling:@"0" andXingbie:xingbie];
        }else{
            [iamgNmageCell image:[UIImage imageNamed:@"icon－默认头像"] andName:self.mm.nickname andZhengjian:[UIImage imageNamed:@"btn－上传图"] andNianling:nianlingStr andXingbie:xingbie];
        }
        //上传头像
        NSString *str = [NSString stringWithFormat:@"http://rolle.cn:8080%@",self.mm.headImage];
        NSURL *url = [NSURL URLWithString:str];
        [iamgNmageCell.touxiang sd_setImageWithURL:url placeholderImage:[UIImage imageNamed:@"icon－默认头像"]];
        //上传的证件
        NSString *str1 = [NSString stringWithFormat:@"http://rolle.cn:8080%@",self.mm.businessLicense];
        NSURL *url1 = [NSURL URLWithString:str1];
        [iamgNmageCell.zhengjian sd_setImageWithURL:url1 placeholderImage:[UIImage imageNamed:@"btn－上传图"]];
//        if (self.shifoukedian == NO) {
//            iamgNmageCell.userInteractionEnabled = NO;
//        }else{
//            iamgNmageCell.userInteractionEnabled = YES;
//        }
        return iamgNmageCell;
    }else{
        UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:nil];
        cell.textLabel.font = [UIFont systemFontOfSize:zhiti];
        cell.detailTextLabel.font = [UIFont systemFontOfSize:zhiti];
//        if (self.shifoukedian == NO) {
//            cell.userInteractionEnabled = NO;
//        }else{
//            cell.userInteractionEnabled = YES;
//        }
        if (indexPath.section == 0 && indexPath.row == 1) {//第一组第二个
            MLPersonalDataModel *model = self.diyizhuArray[0];
            cell.textLabel.text = model.name;
            if (model.neirong != nil && model.neirong.length > 0) {
                cell.detailTextLabel.text = model.neirong;
            }else{
                cell.detailTextLabel.text = @"点击设置";
            }
        }else{
            MLPersonalDataModel *model = self.dierzhuArray[indexPath.row];
            cell.textLabel.text = model.name;
            if (model.neirong != nil && model.neirong.length > 0) {
                cell.detailTextLabel.text = model.neirong;
            }else{
                cell.detailTextLabel.text = @"点击设置";
            }
        }
        return cell;
    }
}
//点击每行做什么
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    //取消选择
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    if (indexPath.section == 0 && indexPath.row == 0) {
        MLJibenXinxiController *jiben = [[MLJibenXinxiController alloc] init];
        jiben.mm = self.mm;
        [self.navigationController pushViewController:jiben animated:YES];
        self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStyleDone target:nil action:nil];
    }else{
        MLPersonalDataModel *model = nil;
        if (indexPath.section == 0 && indexPath.row == 1) {
            model = self.diyizhuArray[0];
        }else {
            model = self.dierzhuArray[indexPath.row];
            if ([model.name isEqualToString:@"工作地址"]) {//显示工作地址
                MLAddressController *mdc = [[MLAddressController alloc] init];
                UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:mdc];
                nav.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStyleDone target:nil action:nil];
                [self presentViewController:nav animated:YES completion:nil];
                return;
            }else if ([model.name isEqualToString:@"医生职称"]) {
                MLXuanzheController *mdc = [[MLXuanzheController alloc] init];
                mdc.name = @"医生职称";
                mdc.ID = @"65";
                UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:mdc];
                nav.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStyleDone target:nil action:nil];
                [self presentViewController:nav animated:YES completion:nil];
                return;
            }else if ([model.name isEqualToString:@"所在科室"]) {
                MLXuanzheController *mdc = [[MLXuanzheController alloc] init];
                mdc.name = @"所在科室";
                mdc.ID = @"44";
                UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:mdc];
                nav.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStyleDone target:nil action:nil];
                [self presentViewController:nav animated:YES completion:nil];
                return;
            }
        }
        MLModifyingDataController *mdc = [[MLModifyingDataController alloc] init];
        if (indexPath.section == 0 && indexPath.row == 1) {//点击简介
            mdc.isJibenxinxi = YES;
            mdc.neirong = self.mm.intro;
            mdc.biaoti = @"简介";
        }
        mdc.array = self.dierzhuArray;
        UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:mdc];
        nav.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStyleDone target:nil action:nil];
        mdc.model = model;
        mdc.pdc = self;
        [self presentViewController:nav animated:YES completion:nil];
    }
}
//没行有多高
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0 && indexPath.row == 0) {
        return 60;
    }
    return 40;
}
//section头部间距
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        return 10;
    }else{
        return 9;
    }
}
//section底部间距
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    if (section == 0) {
        return 1;
    }else{
        return 9;
    }
}
//设置分割线包含整个宽度
-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath

{
    [cell setSeparatorInset:UIEdgeInsetsZero];
    [cell setLayoutMargins:UIEdgeInsetsZero];
}
#pragma mark - 网络保存完成,数据保存到数据库
-(void)baochundaoshujuku{
    NSString *url = [MLInterface sharedMLInterface].saveDoctorDoctor;
    MLPersonalDataModel *dizhi = self.dierzhuArray[0];
    if (dizhi.neirong == nil) {
        dizhi.neirong = @"";
    }
    MLPersonalDataModel *yiyuan = self.dierzhuArray[1];
    if (yiyuan.neirong == nil) {
        yiyuan.neirong = @"";
    }
    MLPersonalDataModel *zhicheng = self.dierzhuArray[2];
    if (zhicheng.neirong == nil) {
        zhicheng.neirong = @"";
    }
    MLPersonalDataModel *keshi = self.dierzhuArray[3];
    if (keshi.neirong == nil) {
        keshi.neirong = @"";
    }
    MLPersonalDataModel *zhuangchang = self.dierzhuArray[4];
    if (zhuangchang.neirong == nil) {
        zhuangchang.neirong = @"";
    }
    [[MLUserInfo sharedMLUserInfo] loadUserInfoFromSanbox];
    NSDictionary *parameters = @{@"token":[MLUserInfo sharedMLUserInfo].token,@"hospitalName":yiyuan.neirong,@"jobId":zhicheng.neirong,@"departmentsId":keshi.neirong,@"speciality":zhuangchang.neirong};
   [IWHttpTool postWithURL:url params:parameters success:^(id json) {
       MLDizhiModel *model = [MLDizhiModel objectWithKeyValues:json];
       if ([model.statusCode isEqualToString:@"200"]) {
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
           [MBProgressHUD showSuccess:model.message toView:self.view];
       }
   } failure:^(NSError *error) {
       [MBProgressHUD showError:@"请检查网络" toView:self.view];
   }];
    
}
-(void)dealloc{
    //清空通知,防止内存泄露
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
@end
