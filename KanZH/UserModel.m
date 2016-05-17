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
        self.id         =   [dic objectForKey:@"id"];
        self.count      =   [dic objectForKey:key];
        self.name       =   [dic objectForKey:@"name"];
        self.uHash      =   [dic objectForKey:@"hash"];
        self.avatar     =   [dic objectForKey:@"avatar"];
        self.signature  =   [dic objectForKey:@"signature"];
    }
    return self;
}

@end
