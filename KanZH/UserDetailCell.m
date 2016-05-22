//
//  UserDetailCell.m
//  KanZH_Startpage
//
//  Created by SW05 on 5/6/16.
//  Copyright © 2016 SW05. All rights reserved.
//

#import "UserDetailCell.h"
#import "UIImageView+WebCache.h"
#import "UserDetail.h"
#import "Header.h"

@interface UserDetailCell ()
@property (weak, nonatomic) IBOutlet UIImageView *avatar;
@property (weak, nonatomic) IBOutlet UIImageView *nameImg;
@property (weak, nonatomic) IBOutlet UIImageView *sigImg;
@property (weak, nonatomic) IBOutlet UIImageView *descImg;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *sigLabel;
@property (weak, nonatomic) IBOutlet UILabel *desLabel;
@end

@implementation UserDetailCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)showCellWithUserDetail:(UserDetail *)user {
    // ** 1.赋值
    [self.avatar sd_setImageWithURL:[NSURL URLWithString:user.avatar]
                   placeholderImage:[UIImage imageNamed:@"avatar_holder"]];
    self.nameLabel.text = user.name;
    self.sigLabel.text = user.signature;
    self.desLabel.text = user.uDescription;
    // ** 2.排版
    self.avatar.frame = CGRectMake(kCellSpace, kCellSpace, 100, 100);
    self.nameImg.frame = CGRectMake(kCellSpace+CGRectGetMaxX(self.avatar.frame), kCellSpace, 15, 15);
    self.sigImg.frame = CGRectMake(kCellSpace+CGRectGetMaxX(self.avatar.frame), 27.5+CGRectGetMaxY(self.nameImg.frame), 15, 15);
    self.descImg.frame = CGRectMake(kCellSpace+CGRectGetMaxX(self.avatar.frame), 27.5+CGRectGetMaxY(self.sigImg.frame), 15, 15);
    self.nameLabel.frame = CGRectMake(kCellSpace+CGRectGetMaxX(self.nameImg.frame), kCellSpace, kScreenSize.width-100-15-4*kCellSpace, 15);
    self.sigLabel.frame = CGRectMake(kCellSpace+CGRectGetMaxX(self.sigImg.frame), 15+CGRectGetMaxY(self.nameLabel.frame), kScreenSize.width-100-15-4*kCellSpace, 40);
    self.desLabel.frame = CGRectMake(kCellSpace+CGRectGetMaxX(self.descImg.frame), 15+CGRectGetMaxY(self.sigLabel.frame), kScreenSize.width-100-15-4*kCellSpace, 15);
}

@end
