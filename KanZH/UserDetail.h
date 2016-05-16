//
//  UserDetail.h
//  KanZH_Startpage
//
//  Created by SW05 on 5/6/16.
//  Copyright © 2016 SW05. All rights reserved.
//

// ** User Detail 模型
#import "UserModel.h"

@interface UserDetail : UserModel
@property (nonatomic, copy) NSString *uDescription;
@property (nonatomic, strong) NSDictionary *detail;
@property (nonatomic, strong) NSDictionary *star;
@property (nonatomic, strong) NSArray *trend;
@property (nonatomic, strong) NSArray *topanswers;
// ** 构造方法，通过解析字典获取成员值
+ (instancetype)userDetailWithDictionary:(NSDictionary *)dic;
- (instancetype)initDetailWithDictioanry:(NSDictionary *)dic;
@end
