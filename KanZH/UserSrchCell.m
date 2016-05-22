//
//  UserSrchCell.m
//  KanZH_Startpage
//
//  Created by SW05 on 5/5/16.
//  Copyright © 2016 SW05. All rights reserved.
//

#import "UserSrchCell.h"
#import "UIImageView+WebCache.h"
#import "UserSrch.h"
#import "Header.h"

@interface UserSrchCell ()
// ** cell的所有图标
@property (weak, nonatomic) IBOutlet UIImageView *sigImg;
@property (weak, nonatomic) IBOutlet UIImageView *nameImg;
@property (weak, nonatomic) IBOutlet UIImageView *idImg;
@property (weak, nonatomic) IBOutlet UIImageView *followImg;
@property (weak, nonatomic) IBOutlet UIImageView *answerImg;
@property (weak, nonatomic) IBOutlet UIImageView *agreeImg;
// ** cell的所有label
@property (weak, nonatomic) IBOutlet UILabel *sigLabel;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *idLabel;
@property (weak, nonatomic) IBOutlet UILabel *ansLabel;
@property (weak, nonatomic) IBOutlet UILabel *followLabel;
@property (weak, nonatomic) IBOutlet UILabel *agreeLabel;
// ** 头像图标
@property (weak, nonatomic) IBOutlet UIImageView *avatar;
@end

@implementation UserSrchCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)showCellWithUserSrch:(UserSrch *)user {
    // ** 1.设置头像
    [self.avatar sd_setImageWithURL:[NSURL URLWithString:user.avatar]
                   placeholderImage:[UIImage imageNamed:@"avatar_holder"]];
    self.avatar.layer.masksToBounds = YES;
    self.avatar.layer.cornerRadius = 42;
    // ** 2.设置所有label的值
    self.sigLabel.text      =   user.signature;
    self.nameLabel.text     =   user.name;
    self.idLabel.text       =   user.id;
    self.followLabel.text   =   user.follower;
    self.ansLabel.text      =   user.answer;
    self.agreeLabel.text    =   user.agree;
    // ** 3.设置label和icon的frame
    // **   3.1第一列图标的frame
    self.avatar.frame       = CGRectMake(kScreenSize.width-kCellSpace-84, kCellSpace, 84, 84);
    self.sigImg.frame       = CGRectMake(kCellSpace, kCellSpace, 15, 15);
    self.nameImg.frame      = CGRectMake(kCellSpace, kCellSpace+CGRectGetMaxY(self.sigImg.frame), 15, 15);
    self.idImg.frame        = CGRectMake(kCellSpace, kCellSpace+CGRectGetMaxY(self.nameImg.frame), 15, 15);
    self.answerImg.frame    = CGRectMake(kCellSpace, kCellSpace+CGRectGetMaxY(self.idImg.frame), 15, 15);
    // **   3.2第二列图标的frame:
    // **       签名标签
    CGFloat xRow2 = kCellSpace + CGRectGetMaxX(self.sigImg.frame);
    self.sigLabel.frame     = CGRectMake(xRow2, kCellSpace, kScreenSize.width - 4*kCellSpace - 15 -84, 15);
    // **       名字标签
    self.nameLabel.frame    = CGRectMake(xRow2, kCellSpace+CGRectGetMaxY(self.sigLabel.frame), self.sigLabel.frame.size.width, 15);
    // **       id标签
    self.idLabel.frame      = CGRectMake(xRow2, kCellSpace+CGRectGetMaxY(self.nameLabel.frame), 100, 15);
    // **       回答数标签
    self.ansLabel.frame     = CGRectMake(xRow2, kCellSpace+CGRectGetMaxY(self.idLabel.frame), 100, 15);
    // **   3.3第三列图标的frame
    // **       关注数图标
    self.followImg.frame    = CGRectMake(kCellSpace+CGRectGetMaxX(self.idLabel.frame), self.idLabel.frame.origin.y, 15, 15);
    self.agreeImg.frame     = CGRectMake(kCellSpace+CGRectGetMaxX(self.ansLabel.frame), self.ansLabel.frame.origin.y, 15, 15);
    self.followLabel.frame  = CGRectMake(CGRectGetMaxX(self.followImg.frame), self.followImg.frame.origin.y, 50, 15);
    self.agreeLabel.frame   = CGRectMake(CGRectGetMaxX(self.agreeImg.frame), self.agreeImg.frame.origin.y, 50, 15);
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
