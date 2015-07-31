//
//  MLBingshiController.m
//  医家(医生端)
//
//  Created by 洛耳 on 15/7/28.
//  Copyright (c) 2015年 workorz. All rights reserved.
//  结束ios7 时间选择器Tag == 1;

#import "MLBingshiController.h"
#import "IWHttpTool.h"
#import "MLInterface.h"
#import "MJExtension.h"
#import "MLUserInfo.h"
#import "MBProgressHUD+MJ.h"
#import "MLSlidingAroundView.h"
#import "NSHuangzheShujuModel.h"
#import "NSDate+MJ.h"
#import "SRMonthPicker.h"
#import "MLhuangzheZhuangtaiModel.h"
#import "MLHuangzheXiangxiModel.h"
#import "PCPieChart.h"
#import "MLCollectionViewFlowLayout.h"
#import "MLHuangzheXuetangCell.h"
#import "NSDate+MLDate.h"
#define yanshe [UIColor colorWithRed:230/255.0 green:230/255.0 blue:230/255.0 alpha:1]
#define hongse [UIColor colorWithRed:250/255.0 green:72/255.0 blue:10/255.0 alpha:1]
#define lvshe [UIColor colorWithRed:159/255.0 green:234/255.0 blue:17/255.0 alpha:1]
#define lanse [UIColor colorWithRed:121/255.0 green:183/255.0 blue:245/255.0 alpha:1]
@interface MLBingshiController ()<SRMonthPickerDelegate,UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout>
@property (nonatomic ,weak)UIView *yingchang;
/**
 *  血糖记录View
 */
@property (nonatomic ,weak)UIView *xuetanView;
/**
 *  个人信息View
 */
@property (nonatomic ,weak)UIView *gerenView;
/**
 *  临时选择的时间记录
 */
@property (nonatomic ,copy)NSString *riqi;
/**
 *  最初的开始时间
 */
@property (nonatomic ,strong)NSDate *kaishiDate;
@property (nonatomic ,copy)NSString *kaishiriqi;
/**
 *  选择按钮
 */
@property (nonatomic ,weak)UIButton *btn;
/**
 *  消息数组
 */
@property (nonatomic ,strong)NSArray *array;
@property (nonatomic ,strong)MLhuangzheZhuangtaiModel *zhuangtaiModel;
/**
 *  饼状图
 */
@property (nonatomic ,weak)PCPieChart *pieChart;
/**
 *  发消息
 */
@property (nonatomic ,weak)UIButton *faxiaoxiBtn;
/**
 *  血糖UICollectionView
 */
@property (nonatomic ,weak)UICollectionView *collectionView;
@end

@implementation MLBingshiController
-(NSArray *)array{
    if (_array == nil) {
        _array = [NSArray array];
        return _array;
    }
    return _array;
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    //隐藏黑线,在界面退出时消除
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 63, [UIScreen mainScreen].bounds.size.width, 2)];
    view.backgroundColor = [UIColor whiteColor];
    self.yingchang = view;
    [self.navigationController.view addSubview:view];
    [self.navigationController.view bringSubviewToFront:view];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] init];
    tap.numberOfTapsRequired = 1;
    [tap addTarget:self action:@selector(danji)];
    [self.view addGestureRecognizer:tap];
    //标题
    NSString *str = [NSString stringWithFormat:@"%@病史",self.model.nickname];
    self.title = str;
    //初始化
    [self chushihua];
    //网络获取数据
    [self wangluo];
}
#pragma mark - 单击退出聊天
-(void)danji{
    // 3.执行动画
    [UIView animateWithDuration:0.3 animations:^{
        if (self.faxiaoxiBtn.transform.ty == 44) {
            self.faxiaoxiBtn.transform = CGAffineTransformMakeTranslation(0, 0);
        }else {
            self.faxiaoxiBtn.transform = CGAffineTransformMakeTranslation(0, 44);
        }
    }];
}
#pragma mark - 网络获取
-(void)wangluo{
    NSString *url = [MLInterface sharedMLInterface].getGlycemicDataByMap;
    [[MLUserInfo sharedMLUserInfo] loadUserInfoFromSanbox];
    //获取本月信息
    NSTimeZone *zone = [NSTimeZone systemTimeZone];
    NSInteger interval = [zone secondsFromGMTForDate:[NSDate date]];
    NSDate *localeDate = [[NSDate date]  dateByAddingTimeInterval: interval];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init] ;
    [formatter setDateFormat:@"yyyy-MM"];
    NSString *destDateString = [formatter stringFromDate:localeDate];
    NSDictionary *dict = @{@"token":[MLUserInfo sharedMLUserInfo].token,@"userId":self.model.ID,@"startTime":destDateString};
    [IWHttpTool postWithURL:url params:dict success:^(id json) {
        MLhuangzheZhuangtaiModel *model = [MLhuangzheZhuangtaiModel objectWithKeyValues:json];
        self.zhuangtaiModel = model;
        if ([model.statusCode isEqualToString:@"200"]) {
            [self bingzhuangtu];
            NSArray *array = [MLHuangzheXiangxiModel objectArrayWithKeyValuesArray:model.list];
            self.array = array;
            [self.collectionView reloadData];
        }
    } failure:^(NSError *error) {
        [MBProgressHUD showError:@"请检查网络" toView:self.view];
    }];
}
#pragma mark - 初始化
-(void)chushihua{
    //创建血糖记录View内容
    [self chuangjianXuetanjiluView];
    //创建个人信息View内容
    [self chuangjiangerenxinxiView];
    //创建发送消息按钮
    UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(0, self.xuetanView.frame.size.height , [UIScreen mainScreen].bounds.size.width , 44)];
    btn.backgroundColor = [UIColor whiteColor];
    btn.alpha = 0.8;
    [btn setTitle:@"发消息" forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [btn setImage:[UIImage imageNamed:@"btn－消息选中"] forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(dianjiBtn) forControlEvents:UIControlEventTouchUpInside];
    self.faxiaoxiBtn = btn;
    [self.view addSubview:btn];
}
#pragma mark - 创建个人信息View
-(void)chuangjiangerenxinxiView{
    
}
#pragma mark - 创建血糖记录View
-(void)chuangjianXuetanjiluView{
    //创建滑动模块
    MLSlidingAroundView *sa = [[MLSlidingAroundView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, self.view.frame.size.height)];
    NSArray *array = @[@"血糖记录",@"个人信息"];
    sa.backgroundColor = [UIColor colorWithRed:239/255.0 green:239/255.0 blue:239/255.0 alpha:1];
    [sa slidingAroundBtnNumber:array];
    UIButton *btn1 = sa.btnNumber[0];
    [btn1 setImage:[UIImage imageNamed:@"btn－血糖"] forState:UIControlStateNormal];
    [btn1 setImage:[UIImage imageNamed:@"btn－血糖选中"] forState:UIControlStateSelected];
    UIButton *btn2 = sa.btnNumber[1];
    [btn2 setImage:[UIImage imageNamed:@"btn－个人"] forState:UIControlStateNormal];
    [btn2 setImage:[UIImage imageNamed:@"btn－个人选中"] forState:UIControlStateSelected];
    [self.view addSubview:sa];
    self.xuetanView = sa.views[0];
    self.xuetanView.backgroundColor = [UIColor colorWithRed:239/255.0 green:239/255.0 blue:239/255.0 alpha:1];
    self.gerenView = sa.views[1];
    self.gerenView.backgroundColor = [UIColor colorWithRed:239/255.0 green:239/255.0 blue:239/255.0 alpha:1];
    //血糖记录View设置
    //添加日期选择
    UIView *riqiView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 44)];
    riqiView.backgroundColor = [UIColor whiteColor];
    [self.xuetanView addSubview:riqiView];
    //添加两个日期选择按钮
    UIButton *kaishibtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width , 44)];
    // 1.获得当前时间的年月日
    NSString *diyi =[[NSDate date] fanghui1ri];
    NSString *str1 = [NSString stringWithFormat:@"%@",diyi];
    //时间转date
    NSDate *date1 = [[[NSDate alloc] init] strZhuangDate:diyi];
    self.kaishiDate = date1;
    self.kaishiriqi = str1;
    [kaishibtn setTitle:str1 forState:UIControlStateNormal];
    [kaishibtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [kaishibtn addTarget:self action:@selector(dianjikaishi:) forControlEvents:UIControlEventTouchUpInside];
    [riqiView addSubview:kaishibtn];
    //设置向下箭头
    UIImageView *jiantou1 = [[UIImageView alloc] initWithFrame:CGRectMake([UIScreen mainScreen].bounds.size.width - 13 - 10,( 44 - 9 )/ 2, 13, 9)];
    jiantou1.image = [UIImage imageNamed:@"btn－下拉"];
    [kaishibtn addSubview:jiantou1];
    //设置文字
    [self shezhiwenzi];
    //创建记录
    [self chuangjianbuju];
    //设置线
    CGFloat w = [UIScreen mainScreen].bounds.size.width / 9;
    CGFloat y = [self.view bounds].size.width/4*2 + 25;
    UIView *xian = [[UIView alloc] initWithFrame:CGRectMake(0, y - 0.5, [UIScreen mainScreen].bounds.size.width, 0.5)];
    xian.backgroundColor = [UIColor colorWithRed:220/255.0 green:220/255.0 blue:220/255.0 alpha:1];
    [self.xuetanView addSubview:xian];
    UIView *xiaxian = [[UIView alloc] initWithFrame:CGRectMake(0, y + w * 2, [UIScreen mainScreen].bounds.size.width, 0.5)];
    xiaxian.backgroundColor = [UIColor colorWithRed:220/255.0 green:220/255.0 blue:220/255.0 alpha:1];
    [self.xuetanView addSubview:xiaxian];
}
#pragma mark -创建流水布局
-(void)chuangjianbuju{
    UICollectionView *collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, [self.view bounds].size.width/4*2 + 25 + ([UIScreen mainScreen].bounds.size.width / 9) * 2, [UIScreen mainScreen].bounds.size.width, self.xuetanView.bounds.size.height - ([self.view bounds].size.width/4*2 + 25) - ([UIScreen mainScreen].bounds.size.width / 9 * 2 )) collectionViewLayout:[[MLCollectionViewFlowLayout alloc] init]];
    collectionView.delegate = self;
    collectionView.dataSource = self;
    collectionView.backgroundColor = [UIColor colorWithRed:239/255.0 green:239/255.0 blue:239/255.0 alpha:1];
    self.collectionView = collectionView;
    //注册CELL
    static NSString *ID = @"cell";
    [collectionView registerClass:[MLHuangzheXuetangCell class] forCellWithReuseIdentifier:ID];
    [self.xuetanView addSubview:collectionView];
}
#pragma mark - 设置文字
-(void)shezhiwenzi{
    CGFloat w = [UIScreen mainScreen].bounds.size.width / 9;
    CGFloat h = w;
    CGFloat y = [self.view bounds].size.width/4*2 + 25;
    UILabel *riqi = [self chanjianLableName:@"日\n期" andCGRect:CGRectMake(0, y, w, h * 2)];
    [self.xuetanView addSubview:riqi];
    UILabel *lingcheng = [self chanjianLableName:@"凌\n晨" andCGRect:CGRectMake(riqi.frame.size.width, y, w, h * 2)];
    [self.xuetanView addSubview:lingcheng];
    UILabel *zaochang = [self chanjianLableName:@"早餐" andCGRect:CGRectMake(lingcheng.frame.size.width + lingcheng.frame.origin.x, y, w * 2, h)];
    [self.xuetanView addSubview:zaochang];
    
    UILabel *zaochangqian = [self chanjianLableName:@"前" andCGRect:CGRectMake(lingcheng.frame.origin.x + lingcheng.frame.size.width, y + w , w , h)];    [self.xuetanView addSubview:zaochangqian];
    UILabel *zaochanghou = [self chanjianLableName:@"后" andCGRect:CGRectMake(zaochangqian.frame.origin.x + zaochangqian.frame.size.width, y + w, w, h)];
    [self.xuetanView addSubview:zaochanghou];
    UILabel *zhongchang = [self chanjianLableName:@"中餐" andCGRect:CGRectMake(zaochanghou.frame.origin.x + zaochanghou.frame.size.width, y , w * 2, h)];
    [self.xuetanView addSubview:zhongchang];
    UILabel *zhongchangqian = [self chanjianLableName:@"前" andCGRect:CGRectMake(zaochanghou.frame.origin.x + zaochanghou.frame.size.width, y + w, w, h)];
    [self.xuetanView addSubview:zhongchangqian];
    UILabel *zhongchanghou = [self chanjianLableName:@"后" andCGRect:CGRectMake(zhongchangqian.frame.origin.x + zhongchangqian.frame.size.width, y + w, w,h )];
    [self.xuetanView addSubview:zhongchanghou];
    UILabel *wangchang = [self chanjianLableName:@"晚餐" andCGRect:CGRectMake(zhongchang.frame.origin.x + zhongchang.frame.size.width, y, w * 2, h)];
    [self.xuetanView addSubview:wangchang];
    UILabel *wangchangqian = [self chanjianLableName:@"前" andCGRect:CGRectMake(zhongchanghou.frame.origin.x + zhongchanghou.frame.size.width, y + w, w, h)];
    [self.xuetanView addSubview:wangchangqian];
    UILabel *wangchanghou = [self chanjianLableName:@"后" andCGRect:CGRectMake(wangchangqian.frame.origin.x + wangchangqian.frame.size.width, y + w, w, h)];
    [self.xuetanView addSubview:wangchanghou];
    UILabel *suiqian = [self chanjianLableName:@"睡\n前" andCGRect:CGRectMake(wangchanghou.frame.origin.x + wangchanghou.frame.size.width, y , w, h *2)];
    [self.xuetanView addSubview:suiqian];
}
-(UILabel *)chanjianLableName:(NSString *)name andCGRect:(CGRect)rect{
    UILabel *zaochanghou = [[UILabel alloc] initWithFrame:rect];
    zaochanghou.text = name;
    zaochanghou.numberOfLines = 0;
    zaochanghou.backgroundColor = yanshe;
    zaochanghou.textAlignment = NSTextAlignmentCenter;
    return zaochanghou;
}
#pragma mark - 饼状图
-(void)bingzhuangtu{
    if (self.zhuangtaiModel.list.count == 0) {
        return;
    }
    //设置饼状图
    int height = [self.view bounds].size.width/4*2.; // 220;
    int width = [self.view bounds].size.width / 4 * 3; //320;
    PCPieChart *pieChart = [[PCPieChart alloc] initWithFrame:CGRectMake(([UIScreen mainScreen].bounds.size.width - width ) / 2,35,width,height)];
    [pieChart setAutoresizingMask:UIViewAutoresizingFlexibleLeftMargin|UIViewAutoresizingFlexibleRightMargin|UIViewAutoresizingFlexibleTopMargin|UIViewAutoresizingFlexibleBottomMargin];
    [pieChart setDiameter:width/2];
    [pieChart setSameColorLabel:YES];
    if ([[UIDevice currentDevice] userInterfaceIdiom]==UIUserInterfaceIdiomPad)
    {
        pieChart.titleFont = [UIFont fontWithName:@"HelveticaNeue-Bold" size:30];
        pieChart.percentageFont = [UIFont fontWithName:@"HelveticaNeue-Bold" size:50];
    }
    NSMutableArray *components = [NSMutableArray array];
    for (int i = 0; i < 3; i++) {
        if (i == 0) {
            PCPieComponent *component = [PCPieComponent pieComponentWithTitle:@"正常" value:[self.zhuangtaiModel.normalSum floatValue]];
            [components addObject:component];
            [component setColour:[UIColor colorWithRed:159/255.0 green:234/255.0 blue:17/255.0 alpha:1]];
        }else if (i == 1) {
            PCPieComponent *component = [PCPieComponent pieComponentWithTitle:@"偏低" value:[self.zhuangtaiModel.lowSum floatValue]];
            [components addObject:component];
            [component setColour:[UIColor colorWithRed:121/255.0 green:183/255.0 blue:245/255.0 alpha:1]];
        }else{
            PCPieComponent *component = [PCPieComponent pieComponentWithTitle:@"偏高" value:[self.zhuangtaiModel.highSum floatValue]];
            [components addObject:component];
            [component setColour:[UIColor colorWithRed:250/255.0 green:72/255.0 blue:10/255.0 alpha:1]];
        }
    }
    [pieChart setComponents:components];
    self.pieChart = pieChart;
    [self.xuetanView addSubview:pieChart];
}
#pragma mark - 两个时间选择
//点击开始
-(void)dianjikaishi:(UIButton *)btn{
    self.btn = btn;
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0){
        UIAlertController* alertVc=[UIAlertController alertControllerWithTitle:@"\n\n\n\n\n\n\n\n\n\n\n" message:nil preferredStyle:(UIAlertControllerStyleActionSheet)];
        SRMonthPicker* datePicker=[[SRMonthPicker alloc]init];
        // 设置当前显示
        datePicker.monthPickerDelegate = self;
        datePicker.maximumYear = [[NSDate date] quchunian];
        datePicker.minimumYear = 1900;
        datePicker.yearFirst = YES;
        UIAlertAction* ok=[UIAlertAction actionWithTitle:@"确认" style:(UIAlertActionStyleDefault) handler:^(UIAlertAction *action) {
            if ([self.kaishiDate isDayubenyue]) {
                UIAlertView *alert = [[UIAlertView alloc]initWithTitle:nil message:@"请选择正确的日期" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
                [alert show];
                [self.btn setTitle:self.kaishiriqi forState:UIControlStateNormal];
            }else{
                [self.btn setTitle:self.riqi forState:UIControlStateNormal];
                //网络获取
                NSString *url = [MLInterface sharedMLInterface].getGlycemicDataByMap;
                [[MLUserInfo sharedMLUserInfo] loadUserInfoFromSanbox];
                NSDictionary *dict = @{@"token":[MLUserInfo sharedMLUserInfo].token,@"userId":self.model.ID,@"startTime":self.riqi};
                [IWHttpTool postWithURL:url params:dict success:^(id json) {
                    MLhuangzheZhuangtaiModel *model = [MLhuangzheZhuangtaiModel objectWithKeyValues:json];
                    self.zhuangtaiModel = model;
                    if ([model.statusCode isEqualToString:@"200"]) {
                        [self.pieChart removeFromSuperview];
                        [self.collectionView removeFromSuperview];
                        [self bingzhuangtu];
                        NSArray *array = [MLHuangzheXiangxiModel objectArrayWithKeyValuesArray:model.list];
                        self.array = array;
                        [self chuangjianbuju];
                    }
                } failure:^(NSError *error) {
                    [MBProgressHUD showError:@"请检查网络" toView:self.view];
                }];
            }
        }];
        UIAlertAction* no=[UIAlertAction actionWithTitle:@"取消" style:(UIAlertActionStyleDefault) handler:^(UIAlertAction *action) {
            
        }];
        [alertVc.view addSubview:datePicker];
        [alertVc addAction:ok];
        [alertVc addAction:no];
        [self presentViewController:alertVc animated:YES completion:nil];
    }else{
        SRMonthPicker* datePicker=[[SRMonthPicker alloc]init];
        // 设置当前显示
        datePicker.monthPickerDelegate = self;
        datePicker.maximumYear = [[NSDate date] quchunian];
        datePicker.minimumYear = 1900;
        datePicker.yearFirst = YES;
        UIActionSheet *aler= [[UIActionSheet alloc] initWithTitle:@"\n\n\n\n\n\n\n\n\n\n\n" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:@"确定" otherButtonTitles:nil, nil];
        aler.tag = 3;
        [aler addSubview:datePicker];
        [aler showInView:self.view];
    }
}
#pragma mark - 时间选择代理方法
- (void)monthPickerDidChangeDate:(SRMonthPicker *)monthPicker
{
    NSTimeZone *zone = [NSTimeZone systemTimeZone];
    NSInteger interval = [zone secondsFromGMTForDate:monthPicker.date];
    NSDate *localeDate = [monthPicker.date  dateByAddingTimeInterval: interval];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init] ;
    [formatter setDateFormat:@"yyyy-MM"];
    NSString *destDateString = [formatter stringFromDate:localeDate];
    self.riqi = destDateString;
    self.kaishiDate = localeDate;
}
#pragma mark - 流水布局代理
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return self.array.count;
}
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return 9;
}
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *ID = @"cell";
    MLHuangzheXuetangCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:ID forIndexPath:indexPath];
    MLHuangzheXiangxiModel *model = self.array[indexPath.section];
    if (indexPath.row == 0) {//日期
        NSDate *date = [NSDate dateWithTimeIntervalInMilliSecondSince1970:[model.createTime doubleValue]];
        NSCalendar *calendar = [NSCalendar currentCalendar];
        int unit = NSCalendarUnitDay | NSCalendarUnitMonth |  NSCalendarUnitYear;
        // 2.获得年月日
        NSDateComponents *selfCmps = [calendar components:unit fromDate:date];
        NSString *str = [NSString stringWithFormat:@"%ld",(long)selfCmps.day];
        [cell lableText:str andYanse:[UIColor blackColor]];
    }
    if (indexPath.row == 1) {
        if ([model.morningNum isEqualToString:@"0"] == NO) {//凌晨
            if ([model.morningNum integerValue] < 3.9) {//偏低
                [cell lableText:model.morningNum andYanse:lanse];
            }else if ([model.morningNum integerValue] > 6.2) {//偏高
                [cell lableText:model.morningNum andYanse:hongse];
            }else{//正常
                [cell lableText:model.morningNum andYanse:lvshe];
            }
        }
    }
    
    if (indexPath.row == 2) {
        if ([model.breakfastStart isEqualToString:@"0"] == NO) {//早餐前
            if ([model.breakfastStart integerValue] < 3.9) {//偏低
                [cell lableText:model.breakfastStart andYanse:lanse];
            }else if ([model.breakfastStart integerValue] > 6.2) {//偏高
                [cell lableText:model.breakfastStart andYanse:hongse];
            }else{//正常
                [cell lableText:model.breakfastStart andYanse:lvshe];
            }
        }
    }
    if (indexPath.row == 3) {
        if ([model.breakfastEnd isEqualToString:@"0"] == NO) {//早餐后
            if ([model.breakfastEnd integerValue] < 3.9) {//偏低
                [cell lableText:model.breakfastEnd andYanse:lanse];
            }else if ([model.breakfastEnd integerValue] > 6.2) {//偏高
                [cell lableText:model.breakfastEnd andYanse:hongse];
            }else{//正常
                [cell lableText:model.breakfastEnd andYanse:lvshe];
            }
        }
    }
    if (indexPath.row == 4) {
        if ([model.chineseFoodStart isEqualToString:@"0"] == NO) {//中餐前
            if ([model.chineseFoodStart integerValue] < 3.9) {//偏低
                [cell lableText:model.chineseFoodStart andYanse:lanse];
            }else if ([model.chineseFoodStart integerValue] > 6.2) {//偏高
                [cell lableText:model.chineseFoodStart andYanse:hongse];
            }else{//正常
                [cell lableText:model.chineseFoodStart andYanse:lvshe];
            }
        }
    }
    if (indexPath.row == 5) {
        if ([model.chineseFoodEnd isEqualToString:@"0"] == NO) {//中餐后
            if ([model.chineseFoodEnd integerValue] < 3.9) {//偏低
                [cell lableText:model.chineseFoodEnd andYanse:lanse];
            }else if ([model.chineseFoodEnd integerValue] > 6.2) {//偏高
                [cell lableText:model.chineseFoodEnd andYanse:hongse];
            }else{//正常
                [cell lableText:model.chineseFoodEnd andYanse:lvshe];
            }
        }
    }
    if (indexPath.row == 6) {
        if ([model.dinnerStart isEqualToString:@"0"]  == NO) {//晚餐前
            if ([model.dinnerStart integerValue] < 3.9) {//偏低
                [cell lableText:model.dinnerStart andYanse:lanse];
            }else if ([model.dinnerStart integerValue] > 6.2) {//偏高
                [cell lableText:model.dinnerStart andYanse:hongse];
            }else{//正常
                [cell lableText:model.dinnerStart andYanse:lvshe];
            }
        }
    }
    if (indexPath.row == 7) {
        if ([model.dinnerEnd isEqualToString:@"0"] == NO) {//晚餐后
            if ([model.dinnerEnd integerValue] < 3.9) {//偏低
                [cell lableText:model.dinnerEnd andYanse:lanse];
            }else if ([model.dinnerEnd integerValue] > 6.2) {//偏高
                [cell lableText:model.dinnerEnd andYanse:hongse];
            }else{//正常
                [cell lableText:model.dinnerEnd andYanse:lvshe];
            }
        }
    }
    if (indexPath.row == 8) {
        if ([model.beforeGoingToBed isEqualToString:@"0"] == NO) {//睡前
            if ([model.beforeGoingToBed integerValue] < 3.9) {//偏低
                [cell lableText:model.beforeGoingToBed andYanse:lanse];
            }else if ([model.beforeGoingToBed integerValue] > 6.2) {//偏高
                [cell lableText:model.beforeGoingToBed andYanse:hongse];
            }else{//正常
                [cell lableText:model.beforeGoingToBed andYanse:lvshe];
            }
        }
    }
    return cell;
}
#pragma mark - 点击发送聊天按钮
-(void)dianjiBtn{
    NSLog(@"点击发送聊天");
}
//界面消失完毕
-(void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    [self.yingchang removeFromSuperview];
}
@end
