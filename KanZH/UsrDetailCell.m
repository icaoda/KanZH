//
//  UsrDetailCell.m
//  KanZH
//
//  Created by SW05 on 5/18/16.
//  Copyright © 2016 SW05. All rights reserved.
//

#import "UsrDetailCell.h"

@interface UsrDetailCell ()
// ** private properties
@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *scale;
@end

@implementation UsrDetailCell

- (void)showCellWithRect:(CGRect)rect name:(NSString *)aName scale:(id)aScale {
    // ** 移除旧有的view
    for (UIView *v in self.subviews) {
        [v removeFromSuperview];
    }
    // ** 添加新的view
    self.frame = rect;
    self.name  = aName;
    if ([aScale isKindOfClass:[NSNumber class]] == YES) {
        self.scale = [NSString stringWithFormat:@"%lu",[aScale integerValue]];
    } else {
        self.scale = aScale;
    }
    UILabel *name  = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.bounds)/2,
                                                               CGRectGetHeight(self.bounds))];
    UILabel *scale = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetWidth(self.bounds)/2, 0,
                                                               CGRectGetWidth(self.bounds)/2,
                                                               CGRectGetHeight(self.bounds))];
    name.text  = self.name;
    scale.text = self.scale;
    name.font  = [UIFont systemFontOfSize:12.0];
    name.textAlignment  = NSTextAlignmentLeft;
    scale.textAlignment = NSTextAlignmentCenter;
    [self addSubview:name];
    [self addSubview:scale];
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    self.backgroundColor = [UIColor whiteColor];
    // Configure the view for the selected state
}

@end
