//
//  NewsCell.m
//  KanZH_Startpage
//
//  Created by SW05 on 5/5/16.
//  Copyright © 2016 SW05. All rights reserved.
//

#import "NewsCell.h"
#import "NewsModel.h"
#import "Header.h"
#import "ToolBox.h"

@interface NewsCell ()
@property (weak, nonatomic) IBOutlet UIButton *avatar;
@property (weak, nonatomic) IBOutlet UIImageView *authorImg;
@property (weak, nonatomic) IBOutlet UILabel *authorLabel;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *summaryLabel;
@property (weak, nonatomic) IBOutlet UIImageView *voteImg;
@property (weak, nonatomic) IBOutlet UILabel *voteLabel;
@property (weak, nonatomic) IBOutlet UIImageView *timeImg;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@end

@implementation NewsCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)showCellWithNews:(NewsModel *)news {
    // ** 1.设置头像: Notes that this not the absolute show,will show network image with SDImage
    [self.avatar setBackgroundImage:[UIImage imageNamed:@"place_holder_avatar"] forState:UIControlStateNormal];
    [self.avatar setFrame:CGRectMake(kCellSpace, kCellSpace, 60, 60)];
    [self.avatar.layer setMasksToBounds:YES];
    [self.avatar.layer setCornerRadius:30];
    // ** 2.设置答主
    [self.authorImg setFrame:CGRectMake(kCellSpace+CGRectGetMaxX(self.avatar.frame), kCellSpace, 15, 15)];
    [self.authorLabel setFrame:CGRectMake(kCellSpace+CGRectGetMaxX(self.authorImg.frame), kCellSpace, 160, 15)];
    [self.authorLabel setText:news.authorname];
    // ** 3.设置标题
    [self.titleLabel setFrame:CGRectMake(CGRectGetMaxX(self.avatar.frame)+kCellSpace,
                                         CGRectGetMaxY(self.authorImg.frame)+kCellSpace,
                                         CGRectGetWidth(self.contentView.bounds)-60-3*kCellSpace, 60-15-8)];
    [self.titleLabel setText:news.title];
    [self.titleLabel.layer setMasksToBounds:YES];
    [self.titleLabel.layer setCornerRadius:10];
    // ** 4.设置摘要
    CGFloat tWidth  = CGRectGetWidth(self.contentView.bounds) - kCellSpace*2;
    CGFloat tHeight = [ToolBox toolCalcHeightForString:news.summary Width:tWidth fontSize:11.0];
    [self.summaryLabel setFrame:CGRectMake(kCellSpace, CGRectGetMaxX(self.avatar.frame), tWidth, tHeight)];
    [self.summaryLabel setText:news.summary];
    // ** 5.设置投票
    CGFloat sumBottom = CGRectGetMaxY(self.summaryLabel.frame);
    [self.voteImg setFrame:CGRectMake(kCellSpace, sumBottom, 15, 15)];
    [self.voteLabel setFrame:CGRectMake(kCellSpace+CGRectGetMaxX(self.voteImg.frame), sumBottom, 40, 15)];
    [self.voteLabel setText:news.vote];
    // ** 6.设置时间
    [self.timeLabel setFrame:CGRectMake(CGRectGetWidth(self.contentView.bounds)-kCellSpace-110, sumBottom, 110, 15)];
    [self.timeImg setFrame:CGRectMake(CGRectGetMinX(self.timeLabel.frame)-kCellSpace-15, sumBottom, 15, 15)];
    [self.timeLabel setText:news.time];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
