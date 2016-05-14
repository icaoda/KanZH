//
//  NewsModel.h
//  KanZH_Startpage
//
//  Created by SW05 on 5/5/16.
//  Copyright © 2016 SW05. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NewsModel : NSObject
// ** 新闻模型的属性，源自新闻列表的返回json
@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *time;
@property (nonatomic, copy) NSString *summary;
@property (nonatomic, copy) NSString *questionid;
@property (nonatomic, copy) NSString *answerid;
@property (nonatomic, copy) NSString *authorname;
@property (nonatomic, copy) NSString *authorhash;
@property (nonatomic, copy) NSString *avatar;
@property (nonatomic, copy) NSString *vote;
// ** 构造方法，从字典键值对获取成员值
+ (instancetype)newsModelWithDictionary:(NSDictionary *)dic;
- (instancetype)initModelWithDictionary:(NSDictionary *)dic;
// ** 实现KVC的方法
- (void)setValue:(id)value forUndefinedKey:(NSString *)key;
@end
