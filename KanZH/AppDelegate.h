//
//  AppDelegate.h
//  KanZH
//
//  Created by SW05 on 5/10/16.
//  Copyright © 2016 SW05. All rights reserved.
//

#import <UIKit/UIKit.h>

@class JVFloatingDrawerViewController;
@class JVFloatingDrawerSpringAnimator;
@interface AppDelegate : UIResponder <UIApplicationDelegate>
@property (strong, nonatomic) UIWindow *window;
// ** 抽屉控制器的左右控件
@property (strong, nonatomic) JVFloatingDrawerViewController *drawer;
@property (strong, nonatomic) JVFloatingDrawerSpringAnimator *animator;
// ** 统一delegate接口
+ (AppDelegate *)globalDelegate;
// ** 统一抽屉方法
- (void)toggleDrawerWithLeftSide;
- (void)toggleDrawerWithRightSide;
@end

