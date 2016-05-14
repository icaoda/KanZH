//
//  ToolBox.m
//  KanZH_Startpage
//
//  Created by SW05 on 5/4/16.
//  Copyright © 2016 SW05. All rights reserved.
//

#import "ToolBox.h"
#import <Availability.h>

@implementation ToolBox

+ (CGFloat)toolCalcHeightForString:(NSString *)str Width:(CGFloat)width fontSize:(CGFloat)size {
    CGSize cellSize = CGSizeMake(width, MAXFLOAT);
    NSDictionary *attr = @{NSFontAttributeName:[UIFont systemFontOfSize:size]};
    CGRect rect = [str boundingRectWithSize:cellSize options:NSStringDrawingUsesFontLeading|NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingTruncatesLastVisibleLine attributes:attr context:nil];
    return rect.size.height;
}

+ (NSString *)toolGetDateFromString:(NSString *)str {
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:[str integerValue]];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"MM-dd hh:mm:ss"];
    return [formatter stringFromDate:date];
}

+ (NSString *)toolGetDateSubString:(NSString *)str {
    str = [str stringByReplacingOccurrencesOfString:@"-" withString:@"/"];
    str = [str substringFromIndex:5];
    return str;
}

+ (BOOL)toolDate:(NSString *)date1 isNotLaterThanDate:(NSString *)date2 {
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setLocale:[NSLocale systemLocale]];
    [formatter setDateFormat:@"yyyy-MM-dd"];
    NSComparisonResult result = [[formatter dateFromString:date1] compare:[formatter dateFromString:date2]];
    return result==NSOrderedAscending ? NO : YES;
}

+ (NSString *)toolDayWithString:(NSString *)string {
    // ** 格式化读入日期
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setLocale:[NSLocale systemLocale]];
    [formatter setDateFormat:@"yyyyMMdd"];
    NSDate *date = [formatter dateFromString:string];
    // ** 转化日期格式
    [formatter setDateFormat:@"yyyy-MM-dd"];
    NSString *str = [formatter stringFromDate:date];
    return str;
}

+ (NSString *)toolOneDay:(NSString *)day before:(BOOL)before {
    // ** 格式化读入
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setLocale:[NSLocale systemLocale]];
    [formatter setDateFormat:@"yyyyMMdd"];
    NSDate *date = [formatter dateFromString:day];
    // ** 求前后一天
    if (before == YES) {
        date = [NSDate dateWithTimeInterval:-24*60*60 sinceDate:date];
    } else {
        date = [NSDate dateWithTimeInterval:24*60*60 sinceDate:date];
    }
    return [formatter stringFromDate:date];
}
@end
