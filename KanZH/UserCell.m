//
//  UserCell.m
//  KanZH_Startpage
//
//  Created by SW05 on 5/5/16.
//  Copyright © 2016 SW05. All rights reserved.
//

#import "UIImageView+WebCache.h"
#import "UserCell.h"
#import "UserModel.h"
#import "Header.h"

@interface UserCell ()
@property (weak, nonatomic) IBOutlet UIImageView *avatar;
@property (weak, nonatomic) IBOutlet UIImageView *nameImg;
@property (weak, nonatomic) IBOutlet UIImageView *idImage;
@property (weak, nonatomic) IBOutlet UIImageView *countImg;
@property (weak, nonatomic) IBOutlet UIImageView *sigImg;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *idLabel;
@property (weak, nonatomic) IBOutlet UILabel *countLabel;
@property (weak, nonatomic) IBOutlet UILabel *sigLabel;

@end

@implementation UserCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)showCellWithUserModel:(UserModel *)user {
    // ** 1.设置头像
    [self.avatar sd_setImageWithURL:[NSURL URLWithString:user.avatar]
                   placeholderImage:[UIImage imageNamed:@"avatar_holder"]];
    [self.avatar setFrame:CGRectMake(kCellSpace, kCellSpace, 84, 84)];
    [self.avatar.layer setMasksToBounds:YES];
    [self.avatar.layer setCornerRadius:42];
    // ** 2.设置图标和标签位置
    CGFloat iconX = CGRectGetMaxX(self.avatar.frame)+kCellSpace;// 图标的左侧x
    [self.nameImg   setFrame:CGRectMake(iconX, kCellSpace, 15, 15)];
    [self.idImage   setFrame:CGRectMake(iconX, kCellSpace+CGRectGetMaxY(self.nameImg.frame), 15, 15)];
    [self.countImg  setFrame:CGRectMake(iconX, kCellSpace+CGRectGetMaxY(self.idImage.frame), 15, 15)];
    [self.sigLabel  setFrame:CGRectMake(iconX, kCellSpace+CGRectGetMaxY(self.countImg.frame), 15, 15)];
    CGFloat lablX = iconX + kCellSpace +15;                     // 标签的左侧x
    [self.nameLabel     setFrame:CGRectMake(lablX, kCellSpace, 180, 15)];
    [self.idLabel       setFrame:CGRectMake(lablX, kCellSpace+CGRectGetMaxY(self.nameLabel.frame), 180, 15)];
    [self.countLabel    setFrame:CGRectMake(lablX, kCellSpace+CGRectGetMaxY(self.idLabel.frame), 180, 15)];
    [self.sigLabel      setFrame:CGRectMake(lablX, kCellSpace+CGRectGetMaxY(self.countLabel.frame), 180, 15)];
    // ** 3.设置标签值
    NSString *count = [NSString stringWithFormat:@"%ld",(long)[user.count integerValue]];
    [self.countLabel    setText:count];
    [self.idLabel       setText:user.id];
    [self.nameLabel     setText:user.name];
    [self.sigLabel      setText:user.signature];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    // Configure the view for the selected state
}

@end
