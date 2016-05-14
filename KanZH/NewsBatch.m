//
//  NewsBatch.m
//  KanZH_Startpage
//
//  Created by SW05 on 5/4/16.
//  Copyright © 2016 SW05. All rights reserved.
//

#import "NewsBatch.h"

@implementation NewsBatch

+ (instancetype)newsBatchWithDictionary:(NSDictionary *)dic {
    return [[self alloc] initBatchWithDictionary:dic];
}

- (instancetype)initBatchWithDictionary:(NSDictionary *)dic {
    if (self = [super init]) {
        [self setValuesForKeysWithDictionary:dic];
    }
    return self;
}

- (void)setValue:(id)value forUndefinedKey:(NSString *)key {
}

@end
