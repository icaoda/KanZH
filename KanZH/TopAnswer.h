//
//  TopAnswer.h
//  KanZH_Startpage
//
//  Created by SW05 on 5/9/16.
//  Copyright © 2016 SW05. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TopAnswer : NSObject
// ** 高票答案
@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *link;
@property (nonatomic, copy) NSString *date;
@property (nonatomic, assign) NSNumber *agree;
@property (nonatomic, assign) NSInteger ispost;

// ** 构造方法
+ (instancetype)topAnswerWithDictionary:(NSDictionary *)dic;
- (instancetype)initAnswerWithDictionary:(NSDictionary *)dic;
// ** KVC异常处理方法
- (void)setValue:(id)value forUndefinedKey:(NSString *)key;
@end
