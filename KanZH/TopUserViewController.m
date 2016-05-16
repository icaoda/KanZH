//
//  TopUserViewController.m
//  KanZH
//
//  Created by SW05 on 5/14/16.
//  Copyright © 2016 SW05. All rights reserved.
//

#import "TopUserViewController.h"
#import "AppDelegate.h"
#import "Header.h"

@interface TopUserViewController ()<UITableViewDataSource, UITableViewDelegate>

@end

@implementation TopUserViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self customizeNavigationBar];
}

- (void)customizeNavigationBar {
    self.navigationItem.title = @"Top用户排行";
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"menu-nav"]
                                                                             style:UIBarButtonItemStylePlain target:self
                                                                            action:@selector(toggleDrawerLeft)];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"menu-date"]
                                                                              style:UIBarButtonItemStylePlain target:self
                                                                             action:@selector(searchBarItemClick)];
    self.navigationController.navigationBar.tintColor = kWhiteColor;
    self.navigationController.navigationBar.barTintColor = kGreenColor;
    self.navigationController.navigationBar.titleTextAttributes = @{NSFontAttributeName:[UIFont systemFontOfSize:15.0],
                                                                    NSForegroundColorAttributeName:[UIColor blueColor]};
}

- (void)addTableViewToView {
    
}

- (void)addRefreshViewToView {
    
}

- (void)downloadData {
    
}

- (void)toggleDrawerLeft {
    [[AppDelegate globalDelegate] toggleDrawerWithLeftSide];
}

- (void)searchBarItemClick {
    NSLog(@"Search start!");
}

#pragma mark - Data Source 
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    return nil;
}

#pragma mark - Delegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 100;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
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
