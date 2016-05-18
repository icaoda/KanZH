//
//  TrendView.h
//  KanZH_Startpage
//
//  Created by SW05 on 5/6/16.
//  Copyright © 2016 SW05. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TrendView : UIView
// ** 成员：横纵坐标对应的数组
@property (nonatomic, copy) NSArray *dateArray;
@property (nonatomic, copy) NSArray *scaleArray;
- (void)drawTitleWithString:(NSString *)str;
@end
