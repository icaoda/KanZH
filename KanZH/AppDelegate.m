//
//  AppDelegate.m
//  KanZH
//
//  Created by SW05 on 5/10/16.
//  Copyright © 2016 SW05. All rights reserved.
//

#import "AppDelegate.h"
#import "JVFloatingDrawerViewController.h"
#import "JVFloatingDrawerSpringAnimator.h"
#import "SideViewController.h"
#import "MainViewController.h"
#import "Header.h"

@interface AppDelegate ()
@property (nonatomic, strong) SideViewController *side;
@property (nonatomic, strong) MainViewController *main;
@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    // ** 配置抽屉控制器
    self.drawer.leftViewController = self.side;
    self.drawer.centerViewController = [[UINavigationController alloc] initWithRootViewController:self.main];
    self.drawer.backgroundImage = [UIImage imageNamed:@"bg_drawer"];
    self.drawer.animator = self.animator;
    self.drawer.leftDrawerWidth = 300.0;
    // ** 设置为window根控制器
    self.window.rootViewController = self.drawer;
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
    // ** 注册通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(sideBarNotification:) name:kSideBarNotification object:nil];
    
    return YES;
}

// ** get方法
- (JVFloatingDrawerViewController *)drawer {
    if (_drawer == nil) {
        _drawer = [[JVFloatingDrawerViewController alloc] init];
    }
    return _drawer;
}

- (JVFloatingDrawerSpringAnimator *)animator {
    if (_animator == nil) {
        _animator = [[JVFloatingDrawerSpringAnimator alloc] init];
    }
    return _animator;
}

- (SideViewController *)side {
    if (_side == nil) {
        _side = [[SideViewController alloc] init];
    }
    return _side;
}

- (MainViewController *)main {
    if (_main == nil) {
        _main = [[MainViewController alloc] init];
    }
    return _main;
}

// ** 全局代理方法
+ (AppDelegate *)globalDelegate {
    return [UIApplication sharedApplication].delegate;
}

// ** 抽屉方法
- (void)toggleDrawerWithLeftSide {
    [self.drawer toggleDrawerWithSide:JVFloatingDrawerSideLeft animated:YES completion:nil];
}

- (void)toggleDrawerWithRightSide {
    [self.drawer toggleDrawerWithSide:JVFloatingDrawerSideRight animated:YES completion:nil];
}

// ** 替换右侧的主视图
- (void)sideBarNotification:(NSNotification *)notify {
    NSIndexPath *indexPath = [notify.userInfo valueForKey:@"indexPath"];
    NSArray *arr = @[@"MainViewController",@"TopUserViewController",@"AboutViewController"];
    Class class = NSClassFromString(arr[indexPath.row]);
    UIViewController *vc = [[class alloc] init];
    self.drawer.centerViewController = [[UINavigationController alloc] initWithRootViewController:vc];
}

// ** 其他代理方法
- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kSideBarNotification object:nil];
}

@end
