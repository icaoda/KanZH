//
//  ToolBox.h
//  KanZH_Startpage
//
//  Created by SW05 on 5/4/16.
//  Copyright © 2016 SW05. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface ToolBox : NSObject

/* ** 为字符串计算容器Label的高度
 @para: str--   内容字符串
 @para: width-- 容器的宽度
 @para: size--  字体的值
 @return: Label的高度
 */
+ (CGFloat)toolCalcHeightForString:(NSString *)str Width:(CGFloat)width fontSize:(CGFloat)size;
/* ** 通过距离RTC的秒数，计算当期日期的
 @para: str--   总共秒数的值
 @return: 格式化的日期字串，这里用“MM-dd hh:mm:ss”
 */
+ (NSString *)toolGetDateFromString:(NSString *)str;
/* ** 日期转化,把 "2016-04-08" 转换为 "04/28"
 @para: str-- 符合"2016-04-08"
 @retrun: MMdd格式-- "04/28"
 */
+ (NSString *)toolGetDateSubString:(NSString *)str;
/* ** 日期比较，对比时间的早晚
 @para: date1,date2 以“20150511”为格式的时间字串
 @return: 如果date1不晚于date2，返回yes，否则no
 */
+ (BOOL)toolDate:(NSString *)date1 isNotLaterThanDate:(NSString *)date2;
/* ** 时间工具，将“20150102” 转化为2015-01-02
 */
+ (NSString *)toolDayWithString:(NSString *)string;
/* ** 时间工具，求“20150512”的前后一天 
 @para：day-- 当前日期
 @para：before-- 前一天Yes,后一天No
 @return：“20150511”
 */
+ (NSString *)toolOneDay:(NSString *)day before:(BOOL)before;
@end
