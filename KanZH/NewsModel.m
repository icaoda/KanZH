//
//  NewsModel.m
//  KanZH_Startpage
//
//  Created by SW05 on 5/5/16.
//  Copyright © 2016 SW05. All rights reserved.
//

#import "NewsModel.h"

@implementation NewsModel

+ (instancetype)newsModelWithDictionary:(NSDictionary *)dic {
    return [[self alloc] initModelWithDictionary:dic];
}

- (instancetype)initModelWithDictionary:(NSDictionary *)dic {
    if (self=[super init]) {
        [self setValuesForKeysWithDictionary:dic];
    }
    return self;
}

- (void)setValue:(id)value forUndefinedKey:(NSString *)key {
    // Do nothing
}

@end
