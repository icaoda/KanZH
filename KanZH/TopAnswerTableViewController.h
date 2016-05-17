//
//  TopAnswerTableViewController.h
//  KanZH
//
//  Created by SW05 on 5/17/16.
//  Copyright © 2016 SW05. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TopAnswerTableViewController : UITableViewController
// ** 初始化方法
+ (instancetype)topAnswerTableWithArray:(NSArray *)arr;
- (instancetype)initAnswerTableWithArray:(NSArray *)arr;
@end
