//
//  AboutViewController.m
//  KanZH
//
//  Created by SW05 on 5/14/16.
//  Copyright © 2016 SW05. All rights reserved.
//

#import "AboutViewController.h"
#import "AboutItemViewController.h"
#import "AppDelegate.h"
#import "Header.h"

@interface AboutViewController ()<UITableViewDelegate,UITableViewDataSource>
// ** 表格属性
@property (nonatomic, strong) UITableView *table;
@property (nonatomic, strong) NSArray *dateSource;
@end

@implementation AboutViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // ** 初始化
    self.dateSource = @[@"关于看知乎",@"看知乎API",@"用户互动",@"about_about",@"about_api",@"about_interact"];
    [self customizeNavigationBar];
    [self addTableView];
}

// ** 配置导航栏
- (void)customizeNavigationBar {
    self.navigationItem.title = @"关于看知乎";
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"menu-nav"]
                                                                             style:UIBarButtonItemStylePlain target:self
                                                                            action:@selector(toggleDrawerLeft)];
    self.navigationController.navigationBar.tintColor = kWhiteColor;
    self.navigationController.navigationBar.barTintColor = kGreenColor;
    self.navigationController.navigationBar.titleTextAttributes = @{NSFontAttributeName:[UIFont systemFontOfSize:15.0],
                                                                    NSForegroundColorAttributeName:[UIColor blueColor]};
}

// ** 添加表格
- (void)addTableView {
    // ** 配置表头
    UIImageView *headImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"side-header"]];
    headImage.frame = CGRectMake((CGRectGetWidth(self.view.frame)-200)/2.0, 0, 200, 100);
    UIView *header = [[UIView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.view.frame), 100)];
    [header addSubview:headImage];
    self.table = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
    self.table.tableHeaderView = header;
    self.table.delegate = self;
    self.table.dataSource = self;
    [self.table registerClass:[UITableViewCell class] forCellReuseIdentifier:@"AboutCell"];
    [self.view addSubview:self.table];
}

#pragma mark - Data source & Delegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dateSource.count/2;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [self.table dequeueReusableCellWithIdentifier:@"AboutCell"];
    cell.textLabel.text = self.dateSource[indexPath.row];
    cell.imageView.image = [UIImage imageNamed:self.dateSource[indexPath.row+(self.dateSource.count)/2]];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    AboutItemViewController *item = [AboutItemViewController aboutItemWithIndex:indexPath.row];
    [self.navigationController pushViewController:item animated:NO];
}

- (void)toggleDrawerLeft {
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
