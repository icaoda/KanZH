//
//  UserModel.m
//  KanZH_Startpage
//
//  Created by SW05 on 5/5/16.
//  Copyright © 2016 SW05. All rights reserved.
//

#import "UserModel.h"

@implementation UserModel

+ (instancetype)userModelWithDictionary:(NSDictionary *)dic key:(NSString *)key {
    return [[self alloc] initModelWithDictionary:dic key:key];
}

- (instancetype)initModelWithDictionary:(NSDictionary *)dic key:(NSString *)key {
    if (self=[super init]) {
        self.id         =   [dic valueForKey:@"id"];
        self.count      =   [dic valueForKey:key];
        self.name       =   [dic valueForKey:@"name"];
        self.uHash      =   [dic valueForKey:@"hash"];
        self.avatar     =   [dic valueForKey:@"avatar"];
        self.signature  =   [dic valueForKey:@"signature"];
    }
    return self;
}

@end
