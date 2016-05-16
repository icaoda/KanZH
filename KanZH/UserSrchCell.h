//
//  UserSrchCell.h
//  KanZH_Startpage
//
//  Created by SW05 on 5/5/16.
//  Copyright © 2016 SW05. All rights reserved.
//

#import <UIKit/UIKit.h>

@class UserSrch;
@interface UserSrchCell : UITableViewCell
// ** 构造用户cell
- (void)showCellWithUserSrch:(UserSrch *)user;
@end
