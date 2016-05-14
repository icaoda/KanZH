//
//  NewsViewController.h
//  KanZH
//
//  Created by SW05 on 5/12/16.
//  Copyright © 2016 SW05. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NewsViewController : UIViewController
// ** 新闻页构造方法
+ (instancetype)newsViewWithDate:(NSString *)date name:(NSString *)name;
- (instancetype)initNewsWithDate:(NSString *)date name:(NSString *)name;
@end
