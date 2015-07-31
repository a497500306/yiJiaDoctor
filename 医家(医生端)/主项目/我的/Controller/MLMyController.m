//
//  MLMyController.m
//  医家(医生端)
//
//  Created by 洛耳 on 15/7/9.
//  Copyright (c) 2015年 workorz. All rights reserved.
//

#import "MLMyController.h"
#import "MLUserInfo.h"
#import "MLIndividualCell.h"
#import "MLMyPromptCell.h"
#import "UIButton+Badge.h"
#import "MLMyPromptModel.h"
#import "MLPersonalDataController.h"
#import "IWHttpTool.h"
#import "MLInterface.h"
#import "MLUserZhuangtaiModel.h"
#import "MLDoctorDetailModel.h"
#import "MLGerenXinxiModel.h"
#import "MJExtension.h"
#import "MBProgressHUD+MJ.h"
#import "MLCoreDataTool.h"
#import "NewUser.h"
#import "MLMyModel.h"
#import "MLYaoqingmaModel.h"
#import "UIImageView+WebCache.h"
#import "MLSetUpController.h"
#import "MLQianbaoController.h"
#import "MLZhengjianController.h"
#import "MLShoudaoPinglunController.h"
#import "MLErweimaView.h"
#import "MLZhanController.h"

@interface MLMyController ()<UITableViewDataSource,UITableViewDelegate,MLIndividualCellDelegate>{
    //数据库文件
    NSManagedObjectContext *_context;
}
@property (nonatomic ,strong)MLYaoqingmaModel *yaoqingma;
@property (nonatomic ,weak)UITableView *table;
@property (nonatomic ,strong)NSArray *dierzhuArray;
@property (nonatomic ,strong)NSArray *disanzhuArray;
@property (nonatomic ,strong)MLMyModel *mm;
@end

@implementation MLMyController
-(NSArray *)dierzhuArray{
    if (_dierzhuArray == nil) {
        _dierzhuArray = [[NSArray alloc] init];
        return _dierzhuArray;
    }
    return _dierzhuArray;
}
-(NSArray *)disanzhuArray{
    if (_disanzhuArray == nil) {
        _disanzhuArray = [[NSArray alloc] init];
        return _disanzhuArray;
    }
    return _disanzhuArray;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    //不透明
    self.navigationController.navigationBar.translucent = NO;
    UITabBarItem* item = [self.tabBarController.tabBar.items objectAtIndex:2];
    item.selectedImage = [UIImage imageNamed:@"btn－我的选中"];
    //初始化
    [self chushihua];
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    __weak typeof(self) weakSelf = self;
    //刷新数据库(子线程刷新数据库)
    dispatch_group_t group = dispatch_group_create();
    dispatch_group_async(group, dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        //取出数据库保存的信息
        [weakSelf quchushujuku];
        //主线程中刷新UI
        [[NSOperationQueue mainQueue] addOperationWithBlock:^{
            [weakSelf.table reloadData];
        }];
    });
    //网络获取数据
    [self wangluo];
}
#pragma mark - 初始化
-(void)chushihua{
    UITableView *table = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height) style:UITableViewStyleGrouped];
    table.delegate = self;
    table.dataSource = self;
    table.backgroundColor = [UIColor colorWithRed:239/255.0 green:239/255.0 blue:239/255.0 alpha:1];
    //设置分割线包含整个宽度
    [table setSeparatorInset:UIEdgeInsetsZero];
    [table setLayoutMargins:UIEdgeInsetsZero];
    self.table = table;
    [self.view addSubview:table];
    //设置数据
    MLMyPromptModel *pModel = [[MLMyPromptModel alloc] init];
    pModel.imageStr = @"icon－认证";
    pModel.nameStr = @"我的证件";
    pModel.jiaobiao = 0;
    MLMyPromptModel *pModel0 = [[MLMyPromptModel alloc] init];
    pModel0.imageStr = @"icon－钱包";
    pModel0.nameStr = @"我的钱包";
    pModel0.jiaobiao = 11;
    MLMyPromptModel *pModel1 = [[MLMyPromptModel alloc] init];
    pModel1.imageStr = @"icon－爱心";
    pModel1.nameStr = @"收到的赞";
    pModel1.jiaobiao = 111;
    MLMyPromptModel *pModel2 = [[MLMyPromptModel alloc] init];
    pModel2.imageStr = @"icon－留言";
    pModel2.nameStr = @"收到的评论";
    pModel2.jiaobiao = 0;
    MLMyPromptModel *pModel3 = [[MLMyPromptModel alloc] init];
    pModel3.imageStr = @"icon－预约";
    pModel3.nameStr = @"预约处理";
    pModel3.jiaobiao = 13;
    MLMyPromptModel *pModel4 = [[MLMyPromptModel alloc] init];
    pModel4.imageStr = @"icon－邀请";
    pModel4.nameStr = @"邀请好友";
    pModel4.jiaobiao = 13;
    self.dierzhuArray = @[pModel,pModel0];
    self.disanzhuArray = @[pModel1,pModel2,pModel3,pModel4];
}
#pragma mark - 网络获取数据
-(void)wangluo{
    [[MLUserInfo sharedMLUserInfo] loadUserInfoFromSanbox];
    //网络获取数据
    NSDictionary *parameters = @{@"token":[MLUserInfo sharedMLUserInfo].token};
    NSString *url = [MLInterface sharedMLInterface].getUserByToken;
    __weak typeof(self) weakSelf = self;
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
    //获取邀请码
    NSDictionary *parameters1 = @{@"token":[MLUserInfo sharedMLUserInfo].token};
    NSString *yaoqingmaurl = [MLInterface sharedMLInterface].getInviteCodeByToken;
    [IWHttpTool postWithURL:yaoqingmaurl params:parameters1 success:^(id json) {
        MLYaoqingmaModel* yaoqingma = [MLYaoqingmaModel objectWithKeyValues:json];
        if ([yaoqingma.statusCode isEqualToString:@"200"]) {
            weakSelf.yaoqingma = yaoqingma;
            [weakSelf.table reloadData];
        }else{
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:nil message:yaoqingma.message delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
            [alert show];
        
        }
    } failure:^(NSError *error) {
        
    }];
}
#pragma mark - 数据库
//取出数据库保存的信息
-(void)quchushujuku{
    [[MLUserInfo sharedMLUserInfo] loadUserInfoFromSanbox];
    NSString *name =  [NSString stringWithFormat:@"%@User.sqlite",[MLUserInfo sharedMLUserInfo].user];
    _context = [MLCoreDataTool chuanjianCoreData:name];//查询数据
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"NewUser"];
    NSArray* items = [_context executeFetchRequest:request error:nil];
    if (items.count > 0) {
        //添加数据到模型
        for (NewUser *fe in items) {
            MLMyModel *mm = [[MLMyModel alloc] init];
            mm.headImage = fe.headImage;
            mm.nickname = fe.nickname;
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
    //删除数据
    //查询数据
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"NewUser"];
    NSArray *emps = [_context executeFetchRequest:request error:nil];
    if (emps.count > 0) {
        //删除数据
        for (NewUser *fe in emps) {
            [_context deleteObject:fe];
        }
        // 3.保存
        [_context save:nil];
        [self tianjiashuju];
    }else{
        //添加数据
        [self tianjiashuju];
    }
}
//添加数据到数据库
-(void)tianjiashuju{
    NewUser *fe = [NSEntityDescription insertNewObjectForEntityForName:@"NewUser" inManagedObjectContext:_context];
    fe.headImage =  self.mm.headImage;
    fe.nickname = self.mm.nickname;
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
    NSError *error = nil;
    [_context save:&error];
    if (error) {
        NSLog(@"%@",error);
    }
}
#pragma mark - 点击二维码
-(void)dianjierweima{
    MLErweimaView *view = [[MLErweimaView alloc] init];
    view.frame = [UIScreen mainScreen].bounds;
    [view erweimaURL:self.mm];
    view.alpha = 0;
    [self.view.window addSubview:view];
    [UIView animateWithDuration:0.3 animations:^{
        view.alpha = 1;
    }];
}
#pragma mark - tableView代理和数据源方法
//有多少组
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 3;
}
//每组有多少行
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section == 0) {
        return 1;
    }else if (section == 1){
        return self.dierzhuArray.count;
    }else if (section == 2){
        return self.disanzhuArray.count;
    }
    return 0;
}
//每行显示什么内容
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {//第一组
        MLIndividualCell *cell = [[MLIndividualCell alloc] init];
        NSArray *nibs = [[NSBundle mainBundle]loadNibNamed:@"MLIndividualCell" owner:nil options:nil];
        cell = [nibs lastObject];
        NSString *str = [NSString stringWithFormat:@"http://rolle.cn:8080%@",self.mm.headImage];
        NSURL *url = [NSURL URLWithString:str];
        [cell.image sd_setImageWithURL:url placeholderImage:[UIImage imageNamed:@"icon－默认头像"]];
        cell.name.text = self.mm.nickname;
        cell.delegate = self;
        NSString *name = nil;
        if (self.yaoqingma.inviteCode == nil) {
            name = @"邀请码";
        }else{
            name = [NSString stringWithFormat:@"邀请码:%@",self.yaoqingma.inviteCode];
        }
        cell.yaoqingma.text = name;
        return cell;
    }else if (indexPath.section == 1){//第二组
        MLMyPromptModel * pModel = self.dierzhuArray[indexPath.row];
        MLMyPromptCell *cell = [[MLMyPromptCell alloc] init];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        NSArray *nibs = [[NSBundle mainBundle]loadNibNamed:@"MLMyPromptCell" owner:nil options:nil];
        cell = [nibs lastObject];
        cell.text.text = pModel.nameStr;
        cell.jiaobiaoInt = pModel.jiaobiao;
        UIImageView *image = [[UIImageView alloc] initWithFrame:CGRectMake(23, 11.5, 22, 27)];
        if (indexPath.row == 0) {
            image.image = [UIImage imageNamed:pModel.imageStr];
        }else{
            cell.imageIcon.image = [UIImage imageNamed:pModel.imageStr];
        }
        [cell.contentView addSubview:image];
        return cell;
    }else if (indexPath.section == 2){//第三组
        MLMyPromptModel * pModel = self.disanzhuArray[indexPath.row];
        MLMyPromptCell *cell = [[MLMyPromptCell alloc] init];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        NSArray *nibs = [[NSBundle mainBundle]loadNibNamed:@"MLMyPromptCell" owner:nil options:nil];
        cell = [nibs lastObject];
//        cell.imageIcon.image = [UIImage imageNamed:pModel.imageStr];
        UIImageView *image = [[UIImageView alloc] initWithFrame:CGRectMake(11 + 10, 7 + 10, 24, 18)];
        if (indexPath.row == 2) {
            image.frame = CGRectMake(11 + 10, 14, 24, 24);
        }
        image.image = [UIImage imageNamed:pModel.imageStr];
        [cell.contentView addSubview:image];
        cell.text.text = pModel.nameStr;
        cell.jiaobiaoInt = pModel.jiaobiao;
        return cell;
    }
    return nil;
}
//点击每行做什么
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    //取消选择
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    if (indexPath.section == 0 && indexPath.row == 0) {//第一组第一行
        MLPersonalDataController *nf = [[MLPersonalDataController alloc] init];
        nf.mm = self.mm;
        nf.hidesBottomBarWhenPushed=YES;
        [self.navigationController pushViewController:nf animated:YES];
        self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStyleDone target:nil action:nil];
    }else if (indexPath.section == 1){//第二组
        if (indexPath.row == 0) {//第二组第一行(证件)
            MLZhengjianController *nf = [[MLZhengjianController alloc] init];
            nf.mm = self.mm;
            nf.hidesBottomBarWhenPushed=YES;
            self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStyleDone target:nil action:nil];
            [self.navigationController pushViewController:nf animated:YES];
        }else if (indexPath.row == 1) {//第二组第二行
            MLQianbaoController *nf = [[MLQianbaoController alloc] init];
            nf.hidesBottomBarWhenPushed=YES;
            self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStyleDone target:nil action:nil];
            [self.navigationController pushViewController:nf animated:YES];
        }
    }else if (indexPath.section == 2) {//第三组
        if (indexPath.row == 0) {//第三组第一个
            MLZhanController *nf = [[MLZhanController alloc] init];
            nf.hidesBottomBarWhenPushed=YES;
            self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStyleDone target:nil action:nil];
            [self.navigationController pushViewController:nf animated:YES];
            
        }else if (indexPath.row == 1) {//第三组第二个
            MLShoudaoPinglunController *nf = [[MLShoudaoPinglunController alloc] init];
            nf.hidesBottomBarWhenPushed=YES;
            self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStyleDone target:nil action:nil];
            [self.navigationController pushViewController:nf animated:YES];
           
        }else if (indexPath.row == 2) {//第三组第三个
        
        }else if (indexPath.row == 3) {//第三组第四个
        
        }
    }
}
//没行有多高
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        return 60;
    }else{
        return 50;
    }
}
//section头部间距
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        return 10;
    }else if (section == 1){
        return 9;
    }else{
        return 1;
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
#pragma mark - 点击设置
- (IBAction)dianjishezhi:(UIButton *)sender {
    MLSetUpController *nf = [[MLSetUpController alloc] init];
    nf.hidesBottomBarWhenPushed=YES;
    [self.navigationController pushViewController:nf animated:YES];
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStyleDone target:nil action:nil];
//    //这里做注销操作
//    [[MLUserInfo sharedMLUserInfo] loadUserInfoFromSanbox];
//    [MLUserInfo sharedMLUserInfo].user = nil;
//    [MLUserInfo sharedMLUserInfo].pwd = nil;
//    [MLUserInfo sharedMLUserInfo].loginStatus = YES;
//    [[MLUserInfo sharedMLUserInfo] saveUserInfoToSanbox];
//    //跳转到登陆界面
//    UIStoryboard *storayobard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
//    self.view.window.rootViewController = storayobard.instantiateInitialViewController;
    /*************************/
}
-(void)dealloc{

}
@end
