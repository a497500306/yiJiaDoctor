//
//  MLGuanyuwomenController.m
//  医家(医生端)
//
//  Created by 洛耳 on 15/7/21.
//  Copyright (c) 2015年 workorz. All rights reserved.
//

#import "MLGuanyuwomenController.h"
#import "SVWebViewController.h"
@interface MLGuanyuwomenController ()<UITableViewDataSource,UITableViewDelegate>

@end

@implementation MLGuanyuwomenController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"关于我们";
    self.view.backgroundColor = [UIColor colorWithRed:239/255.0 green:239/255.0 blue:239/255.0 alpha:1];
    //关注我们
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(10, 10 + 64, [UIScreen mainScreen].bounds.size.width - 20, 40)];
    label.text = @"关注我们";
    [self.view addSubview:label];
    //入口
    UITableView *table = [[UITableView alloc] initWithFrame:CGRectMake(10, label.frame.origin.y + label.frame.size.height, [UIScreen mainScreen].bounds.size.width - 20, 99)];
    table.delegate = self;
    table.dataSource = self;
    table.rowHeight = 50;
    table.scrollEnabled = NO;
    [self.view addSubview:table];
}


//每组又多少行
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 2;
}
//每行显示什么内容
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:nil];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    cell.detailTextLabel.textColor = [UIColor colorWithRed:111/255.0 green:111/255.0 blue:111/255.0 alpha:1];
    cell.textLabel.textColor = [UIColor colorWithRed:29/255.0 green:111/255.0 blue:240/255.0 alpha:1];
    if (indexPath.row == 0) {
        cell.textLabel.text = @"医疗官网";
        cell.detailTextLabel.text = @"http://www.rolle.cn";
    }else{
        cell.textLabel.text = @"微信公众号";
        cell.detailTextLabel.text = @"点击关注微信公共号";
    }
    return cell;
}
//点击每行做什么事情
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    //取消选择
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    if (indexPath.row == 0) {//跳到官网
        NSURL *url = [NSURL URLWithString:@"http://www.rolle.cn"];
        SVWebViewController *webC = [[SVWebViewController alloc] initWithURL:url];
        [self.navigationController pushViewController:webC animated:YES];
    }else{//微信公众号
#warning 跳转微信关注
    }
}

@end
