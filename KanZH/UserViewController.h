//
//  UserViewController.h
//  KanZH
//
//  Created by SW05 on 5/16/16.
//  Copyright © 2016 SW05. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UserViewController : UIViewController
// ** 构造方法
+ (instancetype)userViewControllerWithHash:(NSString *)hash;
- (instancetype)initViewControllerWithHans:(NSString *)hash;
@end
