//
//  IMDetailCell.m
//  BSKYDoctorPro
//
//  Created by 快医科技 on 2018/5/15.
//  Copyright © 2018年 ky. All rights reserved.
//

#import "IMDetailCell.h"
#import "IMEXModel.h"
#import "IMFriendInfoModel.h"

@interface IMDetailCell ()
@property (weak, nonatomic) IBOutlet UIImageView *avaterImageView;
@property (weak, nonatomic) IBOutlet UIImageView *cardImageView;
@property (weak, nonatomic) IBOutlet UIImageView *genderImageView;
@property (weak, nonatomic) IBOutlet UIImageView *telImageView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *telLabel;
@property (weak, nonatomic) IBOutlet UILabel *cardLabel;
@property (weak, nonatomic) IBOutlet UILabel *ageLabel;
@property (weak, nonatomic) IBOutlet UIImageView *doctorTagImageView;

@end

@implementation IMDetailCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    [self.nameLabel setTextColor:UIColorFromRGB(0x333333)];
    [self.nameLabel setFont:[UIFont systemFontOfSize:18]];
    self.avaterImageView.layer.cornerRadius = 8.0f;
//    self.avaterImageView.layer.borderColor = [UIColor redColor].CGColor;
//    self.avaterImageView.layer.borderWidth = 2.0;
    [self.ageLabel setTextColor:UIColorFromRGB(0x999999)];
    [self.ageLabel setFont:[UIFont systemFontOfSize:13]];
    
    [self.telLabel setTextColor:UIColorFromRGB(0x42a4ff)];
    [self.telLabel setFont:[UIFont systemFontOfSize:14]];
    
    [self.cardLabel setTextColor:UIColorFromRGB(0x333333)];
    [self.cardLabel setFont:[UIFont systemFontOfSize:14]];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(playTelAction)];
    self.telLabel.userInteractionEnabled = YES;
    [self.telLabel addGestureRecognizer:tap];
}
- (void)playTelAction{
    if (![self.telLabel.text isPhoneNumber]) {
        return;
    }
    NSMutableString * str=[[NSMutableString alloc] initWithFormat:@"tel:%@",self.telLabel.text];
    UIWebView * callWebview = [[UIWebView alloc] init];
    [callWebview loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:str]]];
    [self addSubview:callWebview];
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (void)setUser:(id )user{
    _user = user;
    if ([user isKindOfClass:[NIMUser class]]) {
        NIMUser *currentUser = (NIMUser *)user;
        NIMUserInfo *userInfo = currentUser.userInfo;
        if (userInfo.gender == NIMUserGenderMale) {
            self.genderImageView.hidden = NO;
            [self.genderImageView setImage:[UIImage imageNamed:@"im_detail_male"]];
        }else if (userInfo.gender == NIMUserGenderFemale){
            self.genderImageView.hidden = NO;
            [self.genderImageView setImage:[UIImage imageNamed:@"im_detail_female"]];
        }else {
            self.genderImageView.hidden = YES;
        }
        self.telLabel.text = userInfo.mobile;
        self.nameLabel.text = userInfo.nickName;
        [self.avaterImageView sd_setImageWithURL:[NSURL URLWithString:userInfo.avatarUrl] placeholderImage:[UIImage imageNamed:@"im_detail_avater"]];
        if (userInfo.ext.length) {
            IMEXModel *model = [IMEXModel mj_objectWithKeyValues:[userInfo.ext mj_JSONObject]];
            self.cardLabel.text = [NSString idCardStrByReplacingCharactersWithAsterisk:model.idcard];;
            self.ageLabel.text = model.age.length ? [NSString stringWithFormat:@"%@岁",model.age] : @"";
            if (model.professionType.integerValue == 2) {
                self.doctorTagImageView.hidden = YES;
            }else{
                self.doctorTagImageView.hidden = NO;
            }
        }
    }else if ([user isKindOfClass:[IMFriendInfoModel class]]){
        IMFriendInfoModel * currentUser = (IMFriendInfoModel *)user;
//        NIMUserInfo *userInfo = user.userInfo;
        if (currentUser.gender.integerValue == NIMUserGenderMale) {
            self.genderImageView.hidden = NO;
            [self.genderImageView setImage:[UIImage imageNamed:@"im_detail_male"]];
        }else if (currentUser.gender.integerValue == NIMUserGenderFemale){
            self.genderImageView.hidden = NO;
            [self.genderImageView setImage:[UIImage imageNamed:@"im_detail_female"]];
        }else {
            self.genderImageView.hidden = YES;
        }
        self.telLabel.text = currentUser.mobile;
        self.nameLabel.text = currentUser.name;
        [self.avaterImageView sd_setImageWithURL:[NSURL URLWithString:currentUser.iocn] placeholderImage:[UIImage imageNamed:@"im_detail_avater"]];
        if (currentUser.ex) {
            IMEXModel *model = currentUser.ex;
            self.cardLabel.text = [NSString idCardStrByReplacingCharactersWithAsterisk:model.idcard];;
            self.ageLabel.text = model.age.length ? [NSString stringWithFormat:@"%@岁",model.age] : @"";
            if (model.professionType.integerValue == 2) {
                self.doctorTagImageView.hidden = YES;
            }else{
                self.doctorTagImageView.hidden = NO;
            }
        }
    }
    
}
@end
