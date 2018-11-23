//
//  BSContactCell.m
//  BSKYDoctorPro
//
//  Created by LinfengYU on 2017/8/22.
//  Copyright © 2017年 ky. All rights reserved.
//

#import "BSContactCell.h"
#import "IMEXModel.h"
#import "IMContactLabelCollectionView.h"

@interface BSContactCell ()

@property (weak, nonatomic) IBOutlet UIImageView *avatarImageView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *telLabel;
@property (weak, nonatomic) IBOutlet UIImageView *doctorIcon;
@property (nonatomic ,strong) IMContactLabelCollectionView *labelView;
@property (nonatomic, copy) NSString * memberId;

@end

@implementation BSContactCell

- (void)awakeFromNib {
    [super awakeFromNib];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]init];
    [tap addTarget:self action:@selector(onPressAvatar:)];
    [self.avatarImageView addGestureRecognizer:tap];
    // Initialization code
    self.selectedBackgroundView = [[UIView alloc] initWithFrame:self.bounds];
    self.selectedBackgroundView.backgroundColor = UIColorFromRGB(0xededed);
    [self.avatarImageView setCornerRadius:5];
    [self.nameLabel mas_updateConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(140);
    }];
}

- (void)setUser:(NIMUser *)user
{
    _user = user;
    self.nameLabel.text = [self showNameWithUser:user];
    [self.avatarImageView sd_setImageWithURL:[NSURL URLWithString:user.userInfo.avatarUrl] placeholderImage:[UIImage imageNamed:@"avatar_user"]];
    IMEXModel *exModel = [IMEXModel mj_objectWithKeyValues:user.userInfo.ext];
    self.doctorIcon.hidden = exModel.professionType.integerValue == 1 ? NO : YES;
    self.genderImageView.image  = user.userInfo.gender == NIMUserGenderMale ? [UIImage imageNamed:@"male"] : [UIImage imageNamed:@"female"];
    [self.genderImageView sizeToFit];
    if ([exModel.age isNotEmptyString]) {
        self.ageLabel.text = [NSString stringWithFormat:@"%@岁",exModel.age];
    }
    self.telLabel.hidden = YES;
    self.ageLabel.hidden = YES;
    self.genderImageView.hidden = YES;
    self.memberId = user.userId;
    //标签View
    if (_user.ext.length && exModel.professionType.integerValue == 2) {
        IMFriendEXModel *friendExt = [IMFriendEXModel mj_objectWithKeyValues:user.ext];
        [self setLabelViewWhithExt:friendExt];
    }else{
        [_labelView removeFromSuperview];
    }
}
- (void)setLabelViewWhithExt:(IMFriendEXModel *)info{
    self.labelView.value = info.userLabel;
    [self.contentView addSubview:self.labelView];
}
- (IMContactLabelCollectionView *)labelView{
    if (!_labelView) {
        _labelView = [[IMContactLabelCollectionView alloc] initWithFrame:CGRectMake(self.ageLabel.right + 20, 10, SCREEN_WIDTH - self.ageLabel.right - 45, 15)];
        _labelView.centerY = self.contentView.centerY;
        _labelView.userInteractionEnabled = NO;
    }
    return _labelView;
}
- (void)setTeam:(NIMTeam *)team
{
    _team = team;
    self.nameLabel.text = [team.teamName isNotEmptyString] ? team.teamName : team.teamId;
    [self.avatarImageView sd_setImageWithURL:[NSURL URLWithString:team.avatarUrl] placeholderImage:[UIImage imageNamed:@"avatar_team"]];
    self.genderImageView.hidden = YES;
    self.ageLabel.hidden = YES;
    self.telLabel.hidden = YES;
    self.doctorIcon.hidden = YES;
    self.memberId = team.teamId;
}

- (void)setModel:(IMFriendInfoModel *)model {
    self.genderImageView.hidden = YES;
    self.ageLabel.hidden = YES;
    self.nameLabel.text = model.name;
    self.doctorIcon.hidden = model.ex.professionType.integerValue == 2 ? YES : NO;
    [self.avatarImageView sd_setImageWithURL:[NSURL URLWithString:model.iocn] placeholderImage:[UIImage imageNamed:@"avatar_user"]];
    self.telLabel.text = model.accid;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (void)onPressAvatar:(id)sender{
    if ([self.delegate respondsToSelector:@selector(bsContactCell:onPressAvatar:)]) {
        [self.delegate bsContactCell:self onPressAvatar:self.memberId];
    }
}
- (NSString *)showNameWithUser:(NIMUser *)user
{
    if ([user.alias isNotEmptyString]) {
        return user.alias;
    }
    if ([user.userInfo.nickName isNotEmptyString]) {
        return user.userInfo.nickName;
    }
    return user.userId;
}

@end
