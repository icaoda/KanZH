//
//  7PolorView.m
//  KanZH_Startpage
//
//  Created by SW05 on 5/7/16.
//  Copyright © 2016 SW05. All rights reserved.
//

/* ** 功能：绘制7星图，通过一组值（排行数）绘制一个七星图
   ** 原理：固定图框大小为          (280*208)
           固定外接圆直径          (80)
           固定外接圆圆心          (140,140)
           固定标签的大小为        (50*16)
    ** 步骤：1.计算正七边形的顶点坐标 
            2.计算标签的中心坐标
            3.计算数组的最大值
            4.计算数值点的坐标
 */

#import "Polor7View.h"

@interface Polor7View ()
// ** 保存排名数值得数列
@property (nonatomic, copy) NSArray *scales;
@end

@implementation Polor7View

- (instancetype)initWithFrame:(CGRect)frame {
    if (self=[super initWithFrame:frame]) {
        self.backgroundColor = [UIColor whiteColor];
    }
    return self;
}

- (void)drawRect:(CGRect)rect {
    // ** 1.绘制正七边形
    NSArray *mLocation = [self locationForPolorAngles:80.0];
    UIBezierPath *mPath = [UIBezierPath bezierPath];
    mPath.lineWidth = 1.0;
    mPath.lineCapStyle = kCGLineCapSquare;
    mPath.lineJoinStyle = kCGLineCapSquare;
    [[UIColor blueColor] set];
    for (int i=0; i < mLocation.count/2; i++) {
        CGFloat x0 = [mLocation[2*i] floatValue];
        CGFloat y0 = [mLocation[2*i+1] floatValue];
        if (i==0) {
            [mPath moveToPoint:CGPointMake(x0, y0)];
        } else {
            [mPath addLineToPoint:CGPointMake(x0, y0)];
        }
    }
    [mPath closePath];
    [mPath stroke];
    // ** 2.绘制外围label
    [self drawTextLabels];
    // ** 3.绘制内部7星图
    [self sortRankDataToScaleArray];
    NSArray *iLocation = [self locationForRankScale];
    UIBezierPath *iPath = [UIBezierPath bezierPath];
    iPath.lineWidth = 1.0;
    iPath.lineCapStyle = kCGLineCapSquare;
    iPath.lineJoinStyle = kCGLineCapSquare;
    [[UIColor greenColor] set];
    for (int i=0; i<7; i++) {
        CGFloat x0 = [iLocation[2*i] floatValue];
        CGFloat y0 = [iLocation[2*i+1] floatValue];
        if (i==0) {
            [iPath moveToPoint:CGPointMake(x0, y0)];
        } else {
            [iPath addLineToPoint:CGPointMake(x0, y0)];
        }
    }
    [iPath closePath];
    [iPath fill];
}

// ** 添加外围的文字label
- (void)drawTextLabels {
    NSArray *texts = @[@"回答和专栏",@"赞同数",@"平均赞同",@"被关注数",@"收藏数",@"赞同1000+",@"赞同100+"];
    NSArray *oLocation = [self locationForPolorAngles:110.0];
    for (int i=0; i < oLocation.count/2; i++) {
        CGFloat x0 = [oLocation[2*i] floatValue];
        CGFloat y0 = [oLocation[2*i+1] floatValue];
        CGPoint center = CGPointMake(x0, y0);
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 50, 16)];
        label.center = center;
        label.font = [UIFont systemFontOfSize:8.0];
        label.text = [texts objectAtIndex:i];
        label.textColor = [UIColor blueColor];
        label.textAlignment = NSTextAlignmentCenter;
        [self addSubview:label];
    }
}

#pragma mark - Algorithm to process data array
// ** 将字典的值，按照键序列存到数组
- (void)sortRankDataToScaleArray {
    NSMutableArray *arr = [NSMutableArray array];
    NSArray *keys = @[@"answerrank",@"agreerank",@"ratiorank",@"followerrank",@"favrank",@"count1000rank",@"count100rank"];
    for (NSString *k in keys) {
        NSString *scale = [self.rankData valueForKey:k];
        [arr addObject:scale];
    }
    self.scales = arr;
}
// ** 查找数组最大值
- (CGFloat)estimateMaxScaleOfRankData {
    CGFloat max = 0;
    for (NSString *s in self.scales) {
        if ([s floatValue] > max) {
            max = [s floatValue];
        }
    }
    return max;
}

#pragma mark - Algorithm to calculate point location
// ** 计算正七边形的顶点坐标, 和标签的中心坐标
// @para: 计算项目到圆心的距离
- (NSArray *)locationForPolorAngles:(CGFloat)radius {
    NSMutableArray *locations = [NSMutableArray array];
    for (int i=0; i<7; i++) {
        // 1.以圆心为原点的顶点坐标
        CGFloat xPoint = radius * cos(i * M_PI * 2 / 7);
        CGFloat yPoint = radius * sin(i * M_PI * 2 / 7);
        // 2.换算到iOS坐标系
        xPoint = xPoint + 140.0;
        yPoint = yPoint + 140.0;
        [locations addObject:[NSNumber numberWithFloat:xPoint]];
        [locations addObject:[NSNumber numberWithFloat:yPoint]];
    }
    return locations;
}
// ** 计算数据值在7星图中的位置
- (NSArray *)locationForRankScale {
    CGFloat max = [self estimateMaxScaleOfRankData];
    NSMutableArray *locations = [NSMutableArray array];
    for (int i=0; i<7; i++) {
        CGFloat s = [_scales[i] floatValue];
        // 1.以圆心为原点计算的坐标
        CGFloat xPoint = 80.0 * (s/max) * cos(i * M_PI * 2 / 7);
        CGFloat yPoint = 80.0 * (s/max) * sin(i * M_PI * 2 / 7);
        // 2.换算到iOS坐标系
        xPoint = xPoint + 140.0;
        yPoint = yPoint + 140.0;
        [locations addObject:[NSNumber numberWithFloat:xPoint]];
        [locations addObject:[NSNumber numberWithFloat:yPoint]];
    }
    return locations;
}

@end
