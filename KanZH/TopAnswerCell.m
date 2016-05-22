//
//  TopAnswerCell.m
//  KanZH_Startpage
//
//  Created by SW05 on 5/9/16.
//  Copyright © 2016 SW05. All rights reserved.
//

#import "TopAnswerCell.h"
#import "TopAnswer.h"
#import "ToolBox.h"
#import "Header.h"

@interface TopAnswerCell ()
@property (weak, nonatomic) IBOutlet UIImageView *agreeIcon;
@property (weak, nonatomic) IBOutlet UILabel *agreeCount;
@property (weak, nonatomic) IBOutlet UILabel *timeStamp;
@property (weak, nonatomic) IBOutlet UILabel *title;
@end

@implementation TopAnswerCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)showCellWithAnswer:(TopAnswer *)answer {
    // ** 1.填充内容
    self.agreeIcon.layer.masksToBounds = YES;
    self.agreeIcon.layer.cornerRadius = 7.5;
    NSUInteger agree = [answer.agree integerValue];
    if (agree >= 1000) {
        self.agreeCount.text = [NSString stringWithFormat:@"%luK",agree/1000];
    } else {
        self.agreeCount.text = [NSString stringWithFormat:@"%lu",(long)[answer.agree integerValue]];
    }
    self.timeStamp.text = [ToolBox toolGetDateSubString:answer.date];
    self.title.text = answer.title;
    
    // ** 2.调整frame
    self.agreeIcon.frame = CGRectMake(21, 0, 44, 15);
    self.agreeCount.frame = CGRectMake(23, CGRectGetMaxY(_agreeIcon.frame), 40, 15);
    self.timeStamp.frame = CGRectMake(8, CGRectGetMaxY(_agreeCount.frame), 70, 15);
    self.title.frame = CGRectMake(kCellSpace+CGRectGetMaxX(_timeStamp.frame),0,
                                  self.contentView.frame.size.width-kCellSpace*3-70,
                                  self.contentView.frame.size.height);
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
