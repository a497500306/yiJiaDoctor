//
//  MLJibenXinxiController.m
//  医家(医生端)
//
//  Created by 洛耳 on 15/7/20.
//  Copyright (c) 2015年 workorz. All rights reserved.
//

#import "MLJibenXinxiController.h"
#import "MLMyModel.h"
#import "UIImageView+WebCache.h"
#import "MLModifyingDataController.h"
#import "MJExtension.h"
#import "MLInterface.h"
#import "IWHttpTool.h"
#import "MLUserInfo.h"
#import "ASIFormDataRequest.h"
#import "MLDizhiModel.h"
#import "MLCoreDataTool.h"
#import "MBProgressHUD+MJ.h"
#import "NSDate+MJ.h"
#import "NewUser.h"
@interface MLJibenXinxiController ()<UITableViewDataSource,UITableViewDelegate,UIActionSheetDelegate,UINavigationControllerDelegate, UIImagePickerControllerDelegate>{
    //数据库文件
    NSManagedObjectContext *_context;
}
@property (nonatomic ,weak)UITableView *table;
@property (nonatomic ,weak)UIButton *btnNan;
@property (nonatomic ,weak)UIButton *btnNv;
@property (nonatomic ,weak)UILabel *xingmingText;
@property (nonatomic ,weak)UIImageView *imageView;
/**
 *  日期选择器的日期
 */
@property (nonatomic ,copy)NSString *riqi;
@property (nonatomic ,weak)UILabel *riqiLabel;
@end

@implementation MLJibenXinxiController

- (void)viewDidLoad {
    [super viewDidLoad];
    //标题
    self.title = @"个人信息";
    self.view.backgroundColor = [UIColor whiteColor];
    //设置右上角取消按钮
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"保存" style:UIBarButtonItemStylePlain target:self action:@selector(dianjibaocun)];
    //监听通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(addMessageNotify:) name:@"内容" object:nil];
    //初始化
    [self chushihua];
}
#pragma mark - 初始化
-(void)chushihua{
    UITableView *table = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, self.view.frame.size.height)];
    table.delegate = self;
    table.dataSource = self;
    table.backgroundColor = [UIColor colorWithRed:239/255.0 green:239/255.0 blue:239/255.0 alpha:1];
    //去除下划线
    table.separatorStyle = UITableViewCellSeparatorStyleNone;
    //设置分割线包含整个宽度
    [table setSeparatorInset:UIEdgeInsetsZero];
    [table setLayoutMargins:UIEdgeInsetsZero];
    self.table = table;
    [self.view addSubview:table];
}
#pragma mark - UITableView代理和数据源方法
//每组有多少行
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 4;
}
//每行显示什么内容
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{//设置静态数据
    UITableViewCell *cell = [[UITableViewCell alloc] init];
    //线
    UIView *shangxian = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 0.5)];
    shangxian.backgroundColor = [UIColor colorWithRed:224/255.0 green:224/255.0 blue:224/255.0 alpha:1];
    [cell.contentView addSubview:shangxian];
    cell.textLabel.font = [UIFont systemFontOfSize:15];
    if (indexPath.row == 0) {
        cell.textLabel.text = @"头像";
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(120, 5, 50, 50)];
        //圆角
        imageView.layer.cornerRadius = 25;
        imageView.layer.masksToBounds = YES;
        //上传头像
        NSString *str = [NSString stringWithFormat:@"http://rolle.cn:8080%@",self.mm.headImage];
        NSURL *url = [NSURL URLWithString:str];
        [imageView sd_setImageWithURL:url placeholderImage:[UIImage imageNamed:@"icon－默认头像"]];
        [cell.contentView addSubview:imageView];
        self.imageView = imageView;
    }else if (indexPath.row == 1){
        cell.textLabel.text = @"姓名";
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(120, 0, 200, 50)];
        label.text = self.mm.nickname;
        self.xingmingText = label;
        [cell.contentView addSubview:label];
    }else if (indexPath.row == 2){
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.textLabel.text = @"性别";
        UIButton *btnNan = [[UIButton alloc] initWithFrame:CGRectMake(120, 5, 50, 40)];
        //设置男
        [btnNan setTitle:@" 男" forState:UIControlStateNormal];
        [btnNan setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [btnNan setImage:[UIImage imageNamed:@"btn－选择"] forState:UIControlStateNormal];
        [btnNan setImage:[UIImage imageNamed:@"btn－选中"] forState:UIControlStateSelected];
        [btnNan addTarget:self action:@selector(dianjinan) forControlEvents:UIControlEventTouchUpInside];
        [cell.contentView addSubview:btnNan];
        btnNan.titleLabel.font = [UIFont systemFontOfSize:15];
        self.btnNan = btnNan;
        //设置女
        UIButton *btnNv = [[UIButton alloc] initWithFrame:CGRectMake(btnNan.frame.size.width + btnNan.frame.origin.x , 5, 50, 40)];
        [btnNv setTitle:@" 女" forState:UIControlStateNormal];
        [btnNv setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [btnNv setImage:[UIImage imageNamed:@"btn－选择"] forState:UIControlStateNormal];
        [btnNv setImage:[UIImage imageNamed:@"btn－选中"] forState:UIControlStateSelected];
        [btnNv addTarget:self action:@selector(dianjinv) forControlEvents:UIControlEventTouchUpInside];
        [cell.contentView addSubview:btnNv];
        btnNv.titleLabel.font = [UIFont systemFontOfSize:15];
        self.btnNv = btnNv;
        if ([self.mm.sex isEqualToString:@"0"]) {//女
            btnNv.selected = YES;
        }else{
            btnNan.selected = YES;
        }
    }else if (indexPath.row == 3){
        cell.textLabel.text = @"出生日期";
        //设置下线
        UIView *xiaxian = [[UIView alloc] initWithFrame:CGRectMake(0, 49, self.view.frame.size.width, 1)];
        xiaxian.backgroundColor = [UIColor colorWithRed:224/255.0 green:224/255.0 blue:224/255.0 alpha:1];
        [cell.contentView addSubview:xiaxian];
        //设置年龄滚动器
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(120, 0, 200, 50)];
        label.text = self.mm.birthday;
        self.riqiLabel = label;
        [cell.contentView addSubview:label];
    }
    return cell;
}
//点击每行做什么
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    //取消选择
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    if (indexPath.row == 0) {
        if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0){
            UIAlertController* alertVc=[UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:(UIAlertControllerStyleActionSheet)];
            UIAlertAction* ok=[UIAlertAction actionWithTitle:@"拍照" style:(UIAlertActionStyleDefault) handler:^(UIAlertAction *action) {
                UIImagePickerControllerSourceType sourceType = UIImagePickerControllerSourceTypeCamera;
                UIImagePickerController *picker = [[UIImagePickerController alloc] init];//初始化
                picker.delegate = self;
                //设置选择后的图片可被编辑
                picker.allowsEditing = YES;
                picker.sourceType = sourceType;
                [self presentViewController:picker animated:YES completion:nil];
            }];
            UIAlertAction* no=[UIAlertAction actionWithTitle:@"从手机相册中选择" style:(UIAlertActionStyleDefault) handler:^(UIAlertAction *action) {
                UIImagePickerController *picker = [[UIImagePickerController alloc] init];
                
                picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
                picker.delegate = self;
                //设置选择后的图片可被编辑
                picker.allowsEditing = YES;
                [self presentViewController:picker animated:YES completion:nil];
            }];
            UIAlertAction* quxiao=[UIAlertAction actionWithTitle:@"取消" style:(UIAlertActionStyleCancel) handler:nil];
            [alertVc addAction:ok];
            [alertVc addAction:no];
            [alertVc addAction:quxiao];
            [self presentViewController:alertVc animated:YES completion:nil];
        }else{
            UIDatePicker* datePicker=[[UIDatePicker alloc]init];
            [datePicker setDatePickerMode:UIDatePickerModeDate];
            [datePicker addTarget:self action:@selector(dataValueChanged:) forControlEvents:UIControlEventValueChanged];
            UIActionSheet *aler= [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"拍照" destructiveButtonTitle:@"从手机相册中选择" otherButtonTitles:@"取消", nil];
            aler.tag = 1;
            [aler addSubview:datePicker];
            [aler showInView:self.view];
        }
    }else if (indexPath.row == 1){//点击年龄
        MLModifyingDataController *mdc = [[MLModifyingDataController alloc] init];
        mdc.isJibenxinxi = YES;
        mdc.biaoti = @"姓名";
        mdc.neirong = self.mm.nickname;
        UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:mdc];
        nav.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStyleDone target:nil action:nil];
        [self presentViewController:nav animated:YES completion:nil];
        
    }else if (indexPath.row == 2){
        
    }else if (indexPath.row == 3){
        if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0){
            UIAlertController* alertVc=[UIAlertController alertControllerWithTitle:@"\n\n\n\n\n\n\n\n\n\n\n" message:nil preferredStyle:(UIAlertControllerStyleActionSheet)];
            UIDatePicker* datePicker=[[UIDatePicker alloc]init];
            [datePicker setMaximumDate:[NSDate date]];
            [datePicker setDatePickerMode:UIDatePickerModeDate];
            [datePicker addTarget:self action:@selector(dataValueChanged:) forControlEvents:UIControlEventValueChanged];
            UIAlertAction* ok=[UIAlertAction actionWithTitle:@"确认" style:(UIAlertActionStyleDefault) handler:^(UIAlertAction *action) {
                NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
                [formatter setDateFormat:@"yyyy-MM-dd"];
                //判断日期是否大于今天
                NSDate *destDate= [formatter dateFromString:self.riqi];
                if ([destDate isDayujintian]) {
                    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:nil message:@"请选择正确的日期" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
                    [alert show];
                    return ;
                }
                self.riqiLabel.text = self.riqi;
            }];
            UIAlertAction* no=[UIAlertAction actionWithTitle:@"取消" style:(UIAlertActionStyleDefault) handler:nil];
            [alertVc.view addSubview:datePicker];
            [alertVc addAction:ok];
            [alertVc addAction:no];
            [self presentViewController:alertVc animated:YES completion:nil];
        }else{
            UIDatePicker* datePicker=[[UIDatePicker alloc]init];
            [datePicker setMaximumDate:[NSDate date]];
            [datePicker setDatePickerMode:UIDatePickerModeDate];
            [datePicker addTarget:self action:@selector(dataValueChanged:) forControlEvents:UIControlEventValueChanged];
            UIActionSheet *aler= [[UIActionSheet alloc] initWithTitle:@"\n\n\n\n\n\n\n\n\n\n\n" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:@"确定" otherButtonTitles:nil, nil];
            aler.tag = 3;
            [aler addSubview:datePicker];
            [aler showInView:self.view];
        }
    }
}
#pragma mark 相机代理方法
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info{
    //取得图片
    UIImage *image = [info objectForKey:UIImagePickerControllerEditedImage];
    self.imageView.image = image;
    [picker dismissViewControllerAnimated:YES completion:^{
        
    }];
}
#pragma mark 姓名改变的通知
- (void)addMessageNotify:(NSNotification *)aNotification{
    NSDictionary *info = [aNotification userInfo];
    NSString *str = [info objectForKey:@"内容"];
    self.xingmingText.text = str;
}
#pragma mark 日期选择值改变
- (void) dataValueChanged:(UIDatePicker *)sender
{
    UIDatePicker *dataPicker_one = (UIDatePicker *)sender;
    NSDate *date_one = dataPicker_one.date;
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd"];
    NSString *str = [formatter stringFromDate:date_one];
    self.riqi = str;
    if ([date_one isDayujintian]) {
        return;
    }
    self.riqiLabel.text = self.riqi;
}
#pragma mark -IOS7时间选择代理方法
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (actionSheet.tag == 1) {//相机相册界面
        if (buttonIndex == 0) {//打开相册
            UIImagePickerControllerSourceType sourceType = UIImagePickerControllerSourceTypeCamera;
            UIImagePickerController *picker = [[UIImagePickerController alloc] init];//初始化
            picker.delegate = self;
            //设置选择后的图片可被编辑
            picker.allowsEditing = YES;
            picker.sourceType = sourceType;
            [self presentViewController:picker animated:YES completion:nil];
        }else if(buttonIndex == 1){//打开相机
            UIImagePickerController *picker = [[UIImagePickerController alloc] init];
            picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
            picker.delegate = self;
            //设置选择后的图片可被编辑
            picker.allowsEditing = YES;
            [self presentViewController:picker animated:YES completion:nil];
        }
    }else{
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        [formatter setDateFormat:@"yyyy-MM-dd"];
        self.riqi = [formatter  stringFromDate:[NSDate date]];
        self.riqiLabel.text = self.riqi;
    }
}
//没行有多高
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 0) {
        return 60;
    }
    return 50;
}
//设置分割线包含整个宽度
-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath

{
    [cell setSeparatorInset:UIEdgeInsetsZero];
    [cell setLayoutMargins:UIEdgeInsetsZero];
}
#pragma mark - 点击男或女
-(void)dianjinan{//点击男
    if (self.btnNan.selected == YES) {
        self.btnNan.selected = YES;
        
    }else{
        self.btnNan.selected = YES;
        self.btnNv.selected = NO;
    }
}
-(void)dianjinv{//点击女
    if (self.btnNv.selected == YES) {
        
    }else{
        self.btnNv.selected = YES;
        self.btnNan.selected = NO;
    }
}
#pragma mark - 点击保存
-(void)dianjibaocun{
    [MBProgressHUD showMessage:@"" toView:self.view];
    //网络上传数据
    NSString *url = [MLInterface sharedMLInterface].saveDoctor;
    [[MLUserInfo sharedMLUserInfo] loadUserInfoFromSanbox];
    NSString *xingbie = nil;
    if (self.btnNan.selected == YES) {
        xingbie = @"1";
    }else{
        xingbie = @"0";
    }
    NSDictionary *parameters = @{@"token":[MLUserInfo sharedMLUserInfo].token, @"typeId":@"3",@"nickname":self.xingmingText.text,@"sex":xingbie,@"birthday":self.riqiLabel.text};
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
                    fe.nickname = self.xingmingText.text;
                    fe.sex = xingbie;
                    fe.birthday = self.riqiLabel.text;
                }
                // 3.保存
                [_context save:nil];
            }
        }else{
            [MBProgressHUD hideHUDForView:self.view];
            [MBProgressHUD showError:model.message toView:self.view];
        }
    } failure:^(NSError *error) {
        [MBProgressHUD hideHUDForView:self.view];
        [MBProgressHUD showError:@"请检查网络" toView:self.view];
    }];
    //网络上传头像
    //imgae转Data
    NSData *data = UIImagePNGRepresentation(self.imageView.image);
//    //上传到服务器
    NSDictionary *dict = @{@"token":[MLUserInfo sharedMLUserInfo].token,@"typeId":@"71"};
    IWFormData *form = [[IWFormData alloc] init];
    form.data = data;
    form.name = @"file";
    form.filename = @"maogege.jpg";
    form.mimeType = @"image/png";
    NSArray *array = @[form];
    [IWHttpTool postWithURL:[MLInterface sharedMLInterface].uploadImage params:dict formDataArray:array success:^(id json) {
        [MBProgressHUD hideHUDForView:self.view];
        [MBProgressHUD showSuccess:@"保存成功" toView:self.view];
        //延时1秒
        [self performSelector:@selector(delayMethod) withObject:nil afterDelay:1.0f];
    } failure:^(NSError *error) {
        NSLog(@"失败 %@",error);
    }];
}
-(void)delayMethod{
    [self.navigationController popViewControllerAnimated:YES];
}
////界面消失完毕
//-(void)viewDidDisappear:(BOOL)animated
//{
//    [super viewDidDisappear:animated];
//    [[NSNotificationCenter defaultCenter] removeObserver:self];
//}
-(void)dealloc{
    //清空通知,防止内存泄露
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
@end
