//
//  NewsBatchCell.m
//  KanZH_Startpage
//
//  Created by SW05 on 5/4/16.
//  Copyright © 2016 SW05. All rights reserved.
//

#import "NewsBatchCell.h"
#import "NewsBatch.h"
#import "Header.h"
#import "ToolBox.h"

@interface NewsBatchCell ()
@property (weak, nonatomic) IBOutlet UIImageView *newsImg;
@property (weak, nonatomic) IBOutlet UIImageView *badget;
@property (weak, nonatomic) IBOutlet UIImageView *timeImg;
@property (weak, nonatomic) IBOutlet UILabel *newsExcerpt;
@property (weak, nonatomic) IBOutlet UILabel *pubTime;
@property (weak, nonatomic) IBOutlet UILabel *newsCount;
@end

@implementation NewsBatchCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Auto resize to screen size
    CGRect rect = self.frame;
    rect.size.width = kScreenSize.width;
    self.frame = rect;
}

- (void)showCellWithNewsBatch:(NewsBatch *)newsBatch {
    CGFloat cellWidth = self.contentView.frame.size.width;
    // ** 1.设置图片
    self.newsImg.image = [UIImage imageNamed:newsBatch.pic];
    self.newsImg.image = [UIImage imageNamed:@"place_holder_batch"];
    CGRect imgRect = CGRectMake((cellWidth-200)/2, 0, 200, 100);
    self.newsImg.frame = imgRect;
    // ** 2.设置内容
    self.newsExcerpt.text = newsBatch.excerpt;
    CGFloat eWidth  = cellWidth - 2*kCellSpace;
    CGFloat eHeight = [ToolBox toolCalcHeightForString:newsBatch.excerpt Width:eWidth fontSize:10.0];
    CGRect eRect = CGRectMake(kCellSpace, CGRectGetMaxY(self.newsImg.frame), eWidth, eHeight);
    self.newsExcerpt.frame = eRect;
    // ** 3.设置时间戳
    self.timeImg.frame = CGRectMake(kCellSpace, CGRectGetMaxY(self.newsExcerpt.frame), 15, 15);
    self.pubTime.text = [ToolBox toolGetDateFromString:newsBatch.publishtime];
    self.pubTime.frame = CGRectMake(kCellSpace+CGRectGetMaxX(_timeImg.frame), CGRectGetMaxY(self.newsExcerpt.frame), 100, 15);
    // ** 4.设置数量
    self.newsCount.text = [NSString stringWithFormat:@"共%@条",newsBatch.count];
    self.newsCount.frame = CGRectMake(cellWidth-kCellSpace-40, CGRectGetMaxY(self.newsExcerpt.frame), 40, 15);
    // ** 5.设置右角标
    if ([newsBatch.name isEqualToString:@"recent"]) {
        self.badget.image = [UIImage imageNamed:@"widget_recent"];
    }else if ([newsBatch.name isEqualToString:@"yesterday"]) {
        self.badget.image = [UIImage imageNamed:@"widget_yesterday"];
    }else {
        self.badget.image = [UIImage imageNamed:@"widget_history"];
    }
    self.badget.frame = CGRectMake(CGRectGetMaxX(self.contentView.frame)-90, 0, 90, 60);
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
