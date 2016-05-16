//
//  UserSrch.m
//  KanZH_Startpage
//
//  Created by SW05 on 5/5/16.
//  Copyright © 2016 SW05. All rights reserved.
//

#import "UserSrch.h"

@implementation UserSrch

+ (instancetype)userSrchWithDictionary:(NSDictionary *)dic {
    return [[self alloc] initSrchWithDictionary:dic];
}

- (instancetype)initSrchWithDictionary:(NSDictionary *)dic {
    if (self=[super init]) {
        self.id         =   [dic valueForKey:@"id"];
        self.name       =   [dic valueForKey:@"name"];
        self.uHash      =   [dic valueForKey:@"hash"];
        self.avatar     =   [dic valueForKey:@"avatar"];
        self.signature  =   [dic valueForKey:@"signature"];
        self.answer     =   [dic valueForKey:@"answer"];
        self.agree      =   [dic valueForKey:@"agree"];
        self.follower   =   [dic valueForKey:@"follower"];
    }
    return self;
}

@end
