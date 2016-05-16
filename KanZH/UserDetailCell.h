//
//  UserDetailCell.h
//  KanZH_Startpage
//
//  Created by SW05 on 5/6/16.
//  Copyright © 2016 SW05. All rights reserved.
//

// ** User detail 模型
#import <UIKit/UIKit.h>

@class UserDetail;
@interface UserDetailCell : UITableViewCell
// ** 通过数据模型设置cell的内容
- (void)showCellWithUserDetail:(UserDetail *)user;
@end
