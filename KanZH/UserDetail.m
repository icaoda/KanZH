//
//  UserDetail.m
//  KanZH_Startpage
//
//  Created by SW05 on 5/6/16.
//  Copyright © 2016 SW05. All rights reserved.
//

#import "UserDetail.h"

@implementation UserDetail

+ (instancetype)userDetailWithDictionary:(NSDictionary *)dic {
    return [[self alloc] initDetailWithDictioanry:dic];
}

- (instancetype)initDetailWithDictioanry:(NSDictionary *)dic {
    if (self=[super init]) {
        self.name           = dic[@"name"];
        self.star           = dic[@"star"];
        self.trend          = dic[@"trend"];
        self.avatar         = dic[@"avatar"];
        self.detail         = dic[@"detail"];
        self.signature      = dic[@"signature"];
        self.uDescription   = dic[@"description"];
        self.topanswers     = dic[@"topanswers"];
    }
    return self;
}

@end
