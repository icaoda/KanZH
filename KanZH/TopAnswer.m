//
//  TopAnswer.m
//  KanZH_Startpage
//
//  Created by SW05 on 5/9/16.
//  Copyright © 2016 SW05. All rights reserved.
//

#import "TopAnswer.h"

@implementation TopAnswer

+ (instancetype)topAnswerWithDictionary:(NSDictionary *)dic {
    return [[self alloc] initAnswerWithDictionary:dic];
}

- (instancetype)initAnswerWithDictionary:(NSDictionary *)dic {
    if (self = [super init]) {
        [self setValuesForKeysWithDictionary:dic];
    }
    return self;
}

- (void)setValue:(id)value forUndefinedKey:(NSString *)key {
    NSLog(@"Do nothing");
}

@end
