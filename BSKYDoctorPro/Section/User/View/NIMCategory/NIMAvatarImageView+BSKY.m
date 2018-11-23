//
//  NIMAvatarImageView+BSKY.m
//  BSKYDoctorPro
//
//  Created by 何雷 on 2018/5/18.
//  Copyright © 2018年 ky. All rights reserved.
//

#import "NIMAvatarImageView+BSKY.h"
#import "IMEXModel.h"

static const char * kDoctorTagKey = "bs_doctorTag";

@implementation NIMAvatarImageView (BSKY)

+ (void)load {
    static dispatch_once_t oncetoken;
    _dispatch_once(&oncetoken, ^{
        
        SEL originalSelector1 = NSSelectorFromString(@"setAvatarBySession:");
        SEL swizzledSelector1 = @selector(swiz_setAvatarBySession:);
        
        SEL originalSelector2 = NSSelectorFromString(@"setAvatarByMessage:");
        SEL swizzledSelector2 = @selector(swiz_setAvatarByMessage:);
        
        [NIMAvatarImageView swizzleInstanceMethod:originalSelector1 with:swizzledSelector1];
        [NIMAvatarImageView swizzleInstanceMethod:originalSelector2 with:swizzledSelector2];
    });
}

- (void)bsky_sizeToFit
{
    for (UIView *view in self.subviews) {
        if ([view isKindOfClass:[UIImageView class]] && view.tag != 2010) {
            [(UIImageView *)view mas_makeConstraints:^(MASConstraintMaker *make) {
                make.edges.equalTo(self);
            }];
            break;
        }
    }
}
- (void)swiz_setAvatarBySession:(NIMSession *)session
{
    [self swiz_setAvatarBySession:session];
    self.doctorTag.hidden = YES;
    if (session.sessionType != NIMSessionTypeTeam)
    {
        NIMUser *user = [[NIMSDK sharedSDK].userManager userInfo:session.sessionId];
        IMEXModel *exModel = [IMEXModel mj_objectWithKeyValues:user.userInfo.ext];
        self.doctorTag.hidden = exModel.professionType.integerValue == 1 ? NO : YES;
    }
}
- (void)swiz_setAvatarByMessage:(NIMMessage *)message
{
    [self swiz_setAvatarByMessage:message];
    self.doctorTag.hidden = YES;
    NIMUser *user = [[NIMSDK sharedSDK].userManager userInfo:message.from];
    IMEXModel *exModel = [IMEXModel mj_objectWithKeyValues:user.userInfo.ext];
    self.doctorTag.hidden = exModel.professionType.integerValue == 1 ? NO : YES;
}

- (UIImageView *)doctorTag
{
    // 获取对应属性的值
    if (!objc_getAssociatedObject(self, kDoctorTagKey)) {
        UIImageView *doctorTag = [[UIImageView alloc]initWithFrame:CGRectZero];
        doctorTag.image = [UIImage imageNamed:@"icon_doctorTag"];
        doctorTag.tag = 2010;
        UIImageView *imageView = nil;
        for (UIView *view in self.subviews) {
            if ([view isKindOfClass:[UIImageView class]] && view.tag != 2010) {
                imageView = (UIImageView *)view;
                break;
            }
        }
        [imageView addSubview:doctorTag];
        [doctorTag mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.top.equalTo(imageView);
            make.width.height.equalTo(imageView).multipliedBy(0.5);
        }];
        objc_setAssociatedObject(self, kDoctorTagKey, doctorTag, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
        return doctorTag;
    }
    return objc_getAssociatedObject(self, kDoctorTagKey);
}

@end
