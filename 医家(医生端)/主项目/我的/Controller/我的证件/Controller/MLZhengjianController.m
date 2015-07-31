//
//  MLZhengjianController.m
//  医家(医生端)
//
//  Created by 洛耳 on 15/7/21.
//  Copyright (c) 2015年 workorz. All rights reserved.
//

#import "MLZhengjianController.h"
#import "UIImageView+WebCache.h"
#import "IWHttpTool.h"
#import "MLUserInfo.h"
#import "MLInterface.h"
#import "MBProgressHUD+MJ.h"

@interface MLZhengjianController ()<UITableViewDelegate,UITableViewDataSource,UIActionSheetDelegate,UINavigationControllerDelegate, UIImagePickerControllerDelegate>
@property (nonatomic ,weak)UIImageView *chongyiImage;
@property (nonatomic ,weak)UIImageView *shengfenImage;
@property (nonatomic ,weak)UIImageView *imageView;
@property (nonatomic ,assign)BOOL isShengfen;
/**
 *  是否选择了身份证图片
 */
@property (nonatomic ,assign)BOOL isShengfenImage;
/**
 *  是否选择了从医图片
 */
@property (nonatomic ,assign)BOOL isChongyiImage;
@end

@implementation MLZhengjianController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"证件";
    //不透明
    self.navigationController.navigationBar.translucent = NO;
    self.view.backgroundColor = [UIColor colorWithRed:239/255.0 green:239/255.0 blue:239/255.0 alpha:1];
    UITableView *table = [[UITableView alloc] initWithFrame:CGRectMake(0, 10, [UIScreen mainScreen].bounds.size.width, self.view.frame.size.height)];
    table.delegate = self;
    table.dataSource = self;
    table.rowHeight = 70;
    table.scrollEnabled = NO;
    table.separatorStyle = UITableViewCellSeparatorStyleNone;
    //底部提交按钮
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 100)];
    UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(10, 10, [UIScreen mainScreen].bounds.size.width - 20, 40)];
    [btn setTitle:@"提交认证" forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    btn.backgroundColor = [UIColor colorWithRed:34/255.0 green:120/255.0 blue:240/255.0 alpha:1];
    //圆角
    btn.layer.cornerRadius = 3;
    btn.layer.masksToBounds = YES;
    [btn addTarget:self action:@selector(dianjitijiao) forControlEvents:UIControlEventTouchUpInside];
    [view addSubview:btn];
    table.tableFooterView = view;
    table.backgroundColor = [UIColor colorWithRed:239/255.0 green:239/255.0 blue:239/255.0 alpha:1];
    [self.view addSubview:table];
}
//每组又多少行
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 2;
}
//每行显示什么内容
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:nil];
    cell.textLabel.font = [UIFont systemFontOfSize:14];
    cell.detailTextLabel.textColor = [UIColor colorWithRed:111/255.0 green:111/255.0 blue:111/255.0 alpha:1];
    cell.textLabel.textColor = [UIColor blackColor];
    if (indexPath.row == 0) {
        //线
        UIView *xian1 = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 1)];
        xian1.backgroundColor = [UIColor colorWithRed:231/255.0 green:231/255.0 blue:231/255.0 alpha:1];
        [cell.contentView addSubview:xian1];
        UIView *xian2 = [[UIView alloc] initWithFrame:CGRectMake(0, 69, self.view.frame.size.width, 1)];
        xian2.backgroundColor = [UIColor colorWithRed:231/255.0 green:231/255.0 blue:231/255.0 alpha:1];
        [cell.contentView addSubview:xian2];
        cell.textLabel.text = @"从医证件照";
        UIImageView *chongyiBtn = [[UIImageView alloc] initWithFrame:CGRectMake(self.view.frame.size.width - 60, 10, 50, 50)];
        NSString *str = [NSString stringWithFormat:@"http://rolle.cn:8080%@",self.mm.businessLicense];
        NSURL *url = [NSURL URLWithString:str];
        [chongyiBtn sd_setImageWithURL:url placeholderImage:[UIImage imageNamed:@"btn－上传图"]];
        [cell.contentView addSubview:chongyiBtn];
        self.chongyiImage = chongyiBtn;
    }else{
        UIView *xian2 = [[UIView alloc] initWithFrame:CGRectMake(0, 69, self.view.frame.size.width, 1)];
        xian2.backgroundColor = [UIColor colorWithRed:231/255.0 green:231/255.0 blue:231/255.0 alpha:1];
        [cell.contentView addSubview:xian2];
        cell.textLabel.text = @"身份证照片(正面)";
        UIImageView *shengfenBtn = [[UIImageView alloc] initWithFrame:CGRectMake(self.view.frame.size.width - 60, 10, 50, 50)];
        NSString *str = [NSString stringWithFormat:@"http://rolle.cn:8080%@",self.mm.idImage];
        NSURL *url = [NSURL URLWithString:str];
        [shengfenBtn sd_setImageWithURL:url placeholderImage:[UIImage imageNamed:@"btn－上传图"]];
        [cell.contentView addSubview:shengfenBtn];
        self.shengfenImage = shengfenBtn;
    }
    return cell;
}
//点击每行做什么事情
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    //取消选择
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0){
        UIAlertController* alertVc=[UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:(UIAlertControllerStyleActionSheet)];
        UIAlertAction* ok=[UIAlertAction actionWithTitle:@"拍照" style:(UIAlertActionStyleDefault) handler:^(UIAlertAction *action) {
            UIImagePickerControllerSourceType sourceType = UIImagePickerControllerSourceTypeCamera;
            UIImagePickerController *picker = [[UIImagePickerController alloc] init];//初始化
            picker.delegate = self;
            picker.sourceType = sourceType;
            [self presentViewController:picker animated:YES completion:nil];
        }];
        UIAlertAction* no=[UIAlertAction actionWithTitle:@"从手机相册中选择" style:(UIAlertActionStyleDefault) handler:^(UIAlertAction *action) {
            UIImagePickerController *picker = [[UIImagePickerController alloc] init];
            
            picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
            picker.delegate = self;
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
    //弹出对话框
    if (indexPath.row == 0) {//点击从医证
        self.isShengfen = NO;
    }else{//点击身份证
        self.isShengfen = YES;
    }
}
#pragma mark 相机代理方法
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info{
    //取得图片
    UIImage *image = [info objectForKey:UIImagePickerControllerOriginalImage];
    self.imageView.image = image;
    if (self.isShengfen) {//判断是否真的选择到了照片
        self.isShengfenImage = YES;
        self.shengfenImage.image = image;
    }else{
        self.isChongyiImage = YES;
        self.chongyiImage.image = image;
    }
    [picker dismissViewControllerAnimated:YES completion:^{
        
    }];
}
#pragma mark - 点击按钮
-(void)dianjitijiao{
    //网络上传头像
    //imgae转Data
    [MBProgressHUD showMessage:nil toView:self.view];
    if (self.isShengfenImage) {//身份证
        NSMutableArray *array = [NSMutableArray array];
        IWFormData *form = [[IWFormData alloc] init];
        NSData *data = UIImagePNGRepresentation(self.shengfenImage.image);
        form.data = data;
        form.name = @"file";
        form.filename = @"maogege.jpg";
        form.mimeType = @"image/png";
        [array addObject:form];
        //上传到服务器
        NSDictionary *dict = @{@"token":[MLUserInfo sharedMLUserInfo].token,@"typeId":@"24"};
        [IWHttpTool postWithURL:[MLInterface sharedMLInterface].uploadImage params:dict formDataArray:array success:^(id json) {
            [MBProgressHUD hideHUDForView:self.view];
            [MBProgressHUD showSuccess:@"保存成功" toView:self.view];
            NSLog(@"%@",json[@"message"]);
        } failure:^(NSError *error) {
            [MBProgressHUD hideHUDForView:self.view];
            [MBProgressHUD showError:@"请检查网络" toView:self.view];
            NSLog(@"失败 %@",error);
        }];
    }
    if (self.isChongyiImage) {
        NSMutableArray *array = [NSMutableArray array];
        NSData *data = UIImagePNGRepresentation(self.chongyiImage.image);
        IWFormData *form = [[IWFormData alloc] init];
        form.data = data;
        form.name = @"file";
        form.filename = @"maogege.jpg";
        form.mimeType = @"image/png";
        [array addObject:form];
        //上传到服务器
        NSDictionary *dict = @{@"token":[MLUserInfo sharedMLUserInfo].token,@"typeId":@"26"};
        [IWHttpTool postWithURL:[MLInterface sharedMLInterface].uploadImage params:dict formDataArray:array success:^(id json) {
            [MBProgressHUD hideHUDForView:self.view];
            [MBProgressHUD showSuccess:@"保存成功" toView:self.view];
            NSLog(@"%@",json[@"message"]);
        } failure:^(NSError *error) {
            [MBProgressHUD hideHUDForView:self.view];
            [MBProgressHUD showError:@"请检查网络" toView:self.view];
            NSLog(@"失败 %@",error);
        }];
    }
    if ((self.isChongyiImage == NO) && (self.isShengfenImage == NO)) {
        [MBProgressHUD hideHUDForView:self.view];
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:nil message:@"请选择图片" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
        [alert show];
        return;
    }
}
@end
