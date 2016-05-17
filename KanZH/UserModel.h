//
//  UserModel.h
//  KanZH_Startpage
//
//  Created by SW05 on 5/5/16.
//  Copyright © 2016 SW05. All rights reserved.
//

// ** Top User 模型
#import <Foundation/Foundation.h>

@interface UserModel : NSObject
// ** 用户属性
@property (nonatomic, copy) NSString *id;
@property (nonatomic, copy) NSNumber *count;
@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *uHash;
@property (nonatomic, copy) NSString *avatar;
@property (nonatomic, copy) NSString *signature;
// ** 构造方法
+ (instancetype)userModelWithDictionary:(NSDictionary *)dic key:(NSString *)key;
- (instancetype)initModelWithDictionary:(NSDictionary *)dic key:(NSString *)key;
@end
