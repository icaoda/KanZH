//
//  NewsBatch.h
//  KanZH_Startpage
//
//  Created by SW05 on 5/4/16.
//  Copyright © 2016 SW05. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NewsBatch : NSObject
// ** 新闻集的属性，对应用API的posts成员
@property (nonatomic, copy) NSString *id;
@property (nonatomic, copy) NSString *date;
@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *pic;
@property (nonatomic, copy) NSString *publishtime;
@property (nonatomic, copy) NSString *count;
@property (nonatomic, copy) NSString *excerpt;
// ** 构造方法，KVC将字典映射到对象
+ (instancetype)newsBatchWithDictionary:(NSDictionary *)dic;
- (instancetype)initBatchWithDictionary:(NSDictionary *)dic;
// ** KVC补充方法，处理未定义键值对异常
- (void)setValue:(id)value forUndefinedKey:(NSString *)key;
@end
