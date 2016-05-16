//
//  UserCell.h
//  KanZH_Startpage
//
//  Created by SW05 on 5/5/16.
//  Copyright © 2016 SW05. All rights reserved.
//

// ** Top User 模型
#import <UIKit/UIKit.h>

@class UserModel;
@interface UserCell : UITableViewCell
// ** 设置cell，根据数据模型填充cell的内容
- (void)showCellWithUserModel:(UserModel *)user;
@end
