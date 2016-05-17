//
//  LeftViewController.m
//  KanZH
//
//  Created by SW05 on 5/14/16.
//  Copyright © 2016 SW05. All rights reserved.
//

#import "SideViewController.h"
#import "MainViewController.h"
#import "TopUserViewController.h"
#import "AboutViewController.h"
#import "AppDelegate.h"
#import "Header.h"

@interface SideViewController ()<UITableViewDelegate,UITableViewDataSource>
// ** 表格相关变量
@property (nonatomic, strong) NSArray *dataSource;
@property (nonatomic, strong) UITableView *table;
@end

@implementation SideViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // ** 初始化设置
    self.dataSource = @[@"看知乎首页",@"用户排行",@"关于看知乎",@"side-zhihu",@"side-rank",@"side-about"];
    [self addTableView];
}

- (void)addTableView {
    // ** 配置表头
    UIImageView *header = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 300.0, 100.0)];
    header.image = [UIImage imageNamed:@"side-header"];
    // ** 配置表格
    self.table = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, 300.0, CGRectGetHeight(self.view.frame)-100)];
    self.table.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    self.table.separatorColor = [UIColor blackColor];
    self.table.tableHeaderView = header;
    self.table.backgroundColor = [UIColor clearColor];
    self.table.dataSource = self;
    self.table.delegate = self;
    [self.table registerClass:[UITableViewCell class] forCellReuseIdentifier:@"SideCell"];
    [self.view addSubview:self.table];
}

#pragma mark - 表格代理和数据
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataSource.count/2;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [self.table dequeueReusableCellWithIdentifier:@"SideCell"];
    cell.textLabel.text = self.dataSource[indexPath.row];
    cell.textLabel.textColor = [UIColor blueColor];
    cell.backgroundColor = [UIColor clearColor];
    cell.imageView.image = [UIImage imageNamed:self.dataSource[indexPath.row+self.dataSource.count/2]];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [[NSNotificationCenter defaultCenter] postNotificationName:kSideBarNotification object:self userInfo:@{@"indexPath":indexPath}];
    [[AppDelegate globalDelegate] toggleDrawerWithLeftSide];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
