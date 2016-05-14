//
//  NewsAnswerViewController.h
//  KanZH
//
//  Created by SW05 on 5/14/16.
//  Copyright © 2016 SW05. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NewsAnswerViewController : UIViewController
// ** 构造方法，初始化成员
+ (instancetype)newsAnserWithQuestion:(NSString *)quest answer:(NSString *)ans userHash:(NSString *)usr;
- (instancetype)initAnserWithQeestion:(NSString *)quest answer:(NSString *)ans userHash:(NSString *)usr;
@end
