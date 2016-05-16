//
//  UserSrch.h
//  KanZH_Startpage
//
//  Created by SW05 on 5/5/16.
//  Copyright © 2016 SW05. All rights reserved.
//

#import "UserModel.h"

@interface UserSrch : UserModel
// ** 用户属性
@property (nonatomic, copy) NSString *answer;
@property (nonatomic, copy) NSString *agree;
@property (nonatomic, copy) NSString *follower;
// ** 构造方法
+ (instancetype)userSrchWithDictionary:(NSDictionary *)dic;
- (instancetype)initSrchWithDictionary:(NSDictionary *)dic;
@end
