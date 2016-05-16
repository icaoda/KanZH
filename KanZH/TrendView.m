//
//  TrendView.m
//  KanZH_Startpage
//
//  Created by SW05 on 5/6/16.
//  Copyright © 2016 SW05. All rights reserved.
//

#import "TrendView.h"
#import "ToolBox.h"

/*  ** Trend View的功能是绘制折线图：外界传入两个数组
        @property：dateArray--日期数组，用于标示横坐标
        @property: scaleArray--数值数组，每日的值
    ** 原理：固定一些元素的frame大小值，绘制坐标和label背景，通过计算绘制折线
                ------------------------
                绘图视图: size为(290*290)
                成图网格: size为（24*24）
                标签网格: size为（24*16）
                ------------------------
                网格左上角：原点为(30*20)
                网格左下角：原点为(30*260)
                纵轴标签起点：原点为(3*12)
                横轴标签起点：原点为(18*263)
                ------------------------
    ** 主要的任务：1.绘制网格--以宽度为1.0的黑色UIView，绘制网格
                 2.绘制标签--
                 3.绘制折线--
 */
@interface TrendView ()
@property (nonatomic, assign) CGFloat maxScale;
@property (nonatomic, assign) CGFloat minScale;
@end


@implementation TrendView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self=[super initWithFrame:frame]) {
        self.backgroundColor = [UIColor whiteColor];
    }
    return self;
}
// ** 绘制折线图
- (void)drawRect:(CGRect)rect {
    // ** 1.绘制背景
    [self calculateArray:self.scaleArray];
    [self drawGridForView];
    [self drawLabelWithMaxAndMinY];
    // ** 2.绘制折线
    NSArray *points = [self calculateLocationForPoints];
    UIColor *color = [UIColor redColor];
    [color set];
    UIBezierPath *bezier = [UIBezierPath bezierPath];
    bezier.lineWidth = 2.0;
    bezier.lineCapStyle = kCGLineCapRound;
    bezier.lineJoinStyle = kCGLineCapRound;
    for (NSUInteger i=0; i<points.count/2; i++) {
        CGFloat xPoint = [points[2*i] floatValue];
        CGFloat yPoint = [points[2*i+1] floatValue];
        CGPoint point = CGPointMake(xPoint, yPoint);
        if (i==0) {
            [bezier moveToPoint:point];
        } else {
            [bezier addLineToPoint:point];
        }
    }
    [bezier stroke];
}

// ** 绘制网格
- (void)drawGridForView {
    // ** 1.绘制竖直Y向grid
    for (NSInteger i=0; i<=10; i++) {
        CGRect rect = CGRectMake(50+24*i, 20, 1, 240);
        UIView *line = [[UIView alloc] initWithFrame:rect];
        if (i==0) {
            line.backgroundColor = [UIColor blackColor];
        } else {
            line.backgroundColor = [UIColor brownColor];
        }
        [self addSubview:line];
    }
    // ** 2.绘制横轴X向grid
    for (NSUInteger i=0; i<=10; i++) {
        CGRect rect = CGRectMake(50, 20+24*i, 240, 1);
        UIView *line = [[UIView alloc] initWithFrame:rect];
        if (i==0 || i==10) {
            line.backgroundColor = [UIColor blackColor];
        } else {
            line.backgroundColor = [UIColor brownColor];
        }
        [self addSubview:line];
    }
}

// ** 绘制标签
- (void)drawLabelWithMaxAndMinY {
    // ** 1.绘制竖直Y向标签
    for (NSUInteger i=0; i<=10; i++) {
        CGRect rect = CGRectMake(3, 252-24*i, 42, 16);
        UILabel *tag = [[UILabel alloc] initWithFrame:rect];
        CGFloat yScale = _minScale + (_maxScale - _minScale) * i / 10.0;
        tag.text = [NSString stringWithFormat:@"%ld",(NSUInteger)yScale];
        tag.textAlignment = NSTextAlignmentRight;
        tag.font = [UIFont systemFontOfSize:8.0];
        tag.textColor = [UIColor blackColor];
        [self addSubview:tag];
    }
    // ** 2.绘制横轴X向标签
    for (NSUInteger i=0; i<10; i++) {
        CGRect rect = CGRectMake(38+24*i, 263, 24, 16);
        UILabel *tag = [[UILabel alloc] initWithFrame:rect];
        tag.text = [ToolBox toolGetDateSubString:self.dateArray[i*3]];
        tag.textAlignment = NSTextAlignmentCenter;
        tag.font = [UIFont systemFontOfSize:7.0];
        tag.textColor = [UIColor blackColor];
        [self addSubview:tag];
    }
}

// ** 描绘折现点
- (NSArray *)calculateLocationForPoints {
    // ** 给数值数组绘制坐标系内的点
    CGFloat x0; CGFloat y0;
    NSMutableArray *points = [NSMutableArray array];
    for (NSUInteger i=0; i<[self.scaleArray count]; i++) {
        // ** 计算笛卡尔坐标系下的位置
        CGFloat value = [self.scaleArray[i] floatValue];
        x0 = 8.0 * i;
        y0 = 240.0 * (value - _minScale) / (_maxScale - _minScale);
        // ** 变化到iOS坐标
        x0 = 50.0 + x0;
        y0 = 20.0 + 240.0 - y0;
        [points addObject:[NSNumber numberWithFloat:x0]];
        [points addObject:[NSNumber numberWithFloat:y0]];
    }
    return points;
}

#pragma mark - 辅助计算方法
// ** 给定数值数列，求坐标的最大值
- (void)calculateArray:(NSArray *)array {
    // 1.求数列最大值
    CGFloat max = 0;
    CGFloat min = MAXFLOAT;
    for (NSString *ele in array) {
        if ([ele integerValue] > max) {
            max = [ele integerValue];
        }
        if ([ele integerValue] < min) {
            min = [ele integerValue];
        }
    }
    // 2.如果所有值相等，最大值为其两倍，直线在最中间
    if (max == min) {// 如果为恒值，则最小值为0 最大值为2倍
        self.minScale = 0.0;
        self.maxScale = 2 * max;
    } else {
        self.minScale = min;
        self.maxScale = max;
    }
}

@end
