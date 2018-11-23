//
//  NIMContactDataCell+BSKY.m
//  BSKYDoctorPro
//
//  Created by 何雷 on 2018/5/17.
//  Copyright © 2018年 ky. All rights reserved.
//

#import "NIMContactDataCell+BSKY.h"
#import <NIMKit/NIMAvatarImageView.h>
#import "NIMAvatarImageView+BSKY.h"
#import "NTESContactDataMember.h"
#import "IMEXModel.h"

static const char * kDoctorTagKey = "bs_doctorTag";

static const char * kGenderIconKey = "bs_genderIcon";

static const char * kAgeLabelKey = "bs_ageLabel";

static const char * kTelLabelKey = "bs_telLabel";

@implementation NIMContactDataCell (BSKY)

+ (void)load {
    static dispatch_once_t oncetoken;
    _dispatch_once(&oncetoken, ^{
        
        SEL originalSelector = NSSelectorFromString(@"initWithStyle:reuseIdentifier:");
        SEL swizzledSelector = @selector(swiz_initWithStyle:reuseIdentifier:);
        
        SEL originalSelector1 = NSSelectorFromString(@"refreshUser:");
        SEL swizzledSelector1 = @selector(swiz_refreshUser:);
        
        SEL originalSelector2 = NSSelectorFromString(@"refreshTeam:");
        SEL swizzledSelector2 = @selector(swiz_refreshTeam:);
        
        SEL originalSelector3 = NSSelectorFromString(@"refreshItem:withMemberInfo:");
        SEL swizzledSelector3 = @selector(swiz_refreshItem:withMemberInfo:);
        
        SEL originalSelector4 = NSSelectorFromString(@"layoutSubviews");
        SEL swizzledSelector4 = @selector(swiz_layoutSubviews);
        
        [NIMContactDataCell swizzleInstanceMethod:originalSelector with:swizzledSelector];
        [NIMContactDataCell swizzleInstanceMethod:originalSelector1 with:swizzledSelector1];
        [NIMContactDataCell swizzleInstanceMethod:originalSelector2 with:swizzledSelector2];
        [NIMContactDataCell swizzleInstanceMethod:originalSelector3 with:swizzledSelector3];
        [NIMContactDataCell swizzleInstanceMethod:originalSelector4 with:swizzledSelector4];
    });
}
- (instancetype)swiz_initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    id __self = [self swiz_initWithStyle:style reuseIdentifier:reuseIdentifier];
    [self initView];
    return __self;
}

- (void)swiz_refreshUser:(id<NIMGroupMemberProtocol>)member
{
    [self swiz_refreshUser:member];
    NIMKitInfo *info = [[NIMKit sharedKit] infoByUser:self.memberId option:nil];
    NIMUser *user = [[NIMSDK sharedSDK].userManager userInfo:info.infoId];
    IMEXModel *exModel = [IMEXModel mj_objectWithKeyValues:user.userInfo.ext];
    self.doctorTag.hidden = exModel.professionType.integerValue == 1 ? NO : YES;
    self.genderIcon.image  = user.userInfo.gender == NIMUserGenderMale ? [UIImage imageNamed:@"male"] : [UIImage imageNamed:@"female"];
    [self.genderIcon sizeToFit];
    if ([exModel.age isNotEmptyString]) {
        self.ageLabel.text = [NSString stringWithFormat:@"%@岁",exModel.age];
    }
    self.telLabel.hidden = YES;
}

- (void)swiz_refreshTeam:(id<NIMGroupMemberProtocol>)member
{
    [self swiz_refreshTeam:member];
}

- (void)swiz_refreshItem:(id<NIMGroupMemberProtocol>)member withMemberInfo:(NIMKitInfo *)info
{
    [self swiz_refreshItem:member withMemberInfo:info];
    self.avatarImageView.userInteractionEnabled = NO;
    NIMUser *user = [[NIMSDK sharedSDK].userManager userInfo:info.infoId];
    IMEXModel *exModel = [IMEXModel mj_objectWithKeyValues:user.userInfo.ext];
    self.doctorTag.hidden = exModel.professionType.integerValue == 1 ? NO : YES;
    self.genderIcon.hidden = YES;
    self.ageLabel.hidden = YES;
    self.telLabel.hidden = YES;
}
- (void)swiz_layoutSubviews
{
    [self swiz_layoutSubviews];
    
    self.avatarImageView.width = self.height - 20;
    self.avatarImageView.height = self.height - 20;
    self.avatarImageView.centerY = self.height/2;
    
    [self.textLabel sizeToFit];
    self.textLabel.left = self.avatarImageView.right + 10;
    self.textLabel.centerY = self.height/2;
    
    self.genderIcon.left = self.textLabel.right+7;
    self.genderIcon.centerY = self.height/2;
    
    [self.ageLabel sizeToFit];
    self.ageLabel.left = self.genderIcon.right+7;
    self.ageLabel.centerY = self.height/2;
    
    [self.telLabel sizeToFit];
    self.telLabel.right = self.width - 10;
    self.telLabel.centerY = self.height/2;
}

- (void)initView
{
    self.avatarImageView.userInteractionEnabled = YES;
    [self.avatarImageView bsky_sizeToFit];
    self.textLabel.textColor = UIColorFromRGB(0x333333);
    self.textLabel.font = [UIFont systemFontOfSize:16];
    [self addSubview:self.genderIcon];
    [self addSubview:self.ageLabel];
    [self addSubview:self.telLabel];
}

- (UIImageView *)doctorTag
{
    // 获取对应属性的值
    if (!objc_getAssociatedObject(self, kDoctorTagKey)) {
        UIImageView *doctorTag = [[UIImageView alloc]initWithFrame:CGRectZero];
        doctorTag.image = [UIImage imageNamed:@"icon_doctorTag"];
        [self.avatarImageView addSubview:doctorTag];
        [doctorTag mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.top.equalTo(self.avatarImageView);
            make.width.height.equalTo(self.avatarImageView.mas_width).multipliedBy(0.5);
        }];
        objc_setAssociatedObject(self, kDoctorTagKey, doctorTag, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
        return doctorTag;
    }
    return objc_getAssociatedObject(self, kDoctorTagKey);
}
- (UIImageView *)genderIcon
{
    if (!objc_getAssociatedObject(self, kGenderIconKey)) {
        UIImageView *genderIcon = [[UIImageView alloc]initWithFrame:CGRectZero];
        genderIcon.image = [UIImage imageNamed:@"female"];
        [genderIcon sizeToFit];
        objc_setAssociatedObject(self, kGenderIconKey, genderIcon, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
        return genderIcon;
    }
    return objc_getAssociatedObject(self, kGenderIconKey);
}
- (UILabel *)ageLabel
{
    if (!objc_getAssociatedObject(self, kAgeLabelKey)) {
        UILabel *label = [[UILabel alloc]init];
        label.textColor = UIColorFromRGB(0x999999);
        label.font = [UIFont systemFontOfSize:13];
        label.text = @"63岁";
        objc_setAssociatedObject(self, kAgeLabelKey, label, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
        return label;
    }
    return objc_getAssociatedObject(self, kAgeLabelKey);
}
- (UILabel *)telLabel
{
    if (!objc_getAssociatedObject(self, kTelLabelKey)) {
        UILabel *label = [[UILabel alloc]init];
        label.textColor = UIColorFromRGB(0x999999);
        label.font = [UIFont systemFontOfSize:13];
        label.text = @"13711112222";
        objc_setAssociatedObject(self, kTelLabelKey, label, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
        return label;
    }
    return objc_getAssociatedObject(self, kTelLabelKey);
}

@end
