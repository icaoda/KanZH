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

@interface TopUserViewController ()

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
    self.navigationController.navigationBar.tintColor = kWhiteColor;
    self.navigationController.navigationBar.barTintColor = kGreenColor;
    self.navigationController.navigationBar.titleTextAttributes = @{NSFontAttributeName:[UIFont systemFontOfSize:15.0],
                                                                    NSForegroundColorAttributeName:[UIColor blueColor]};
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
