//
//  NIMTeamCardHeaderCell+BSKY.m
//  BSKYDoctorPro
//
//  Created by 何雷 on 2018/5/23.
//  Copyright © 2018年 ky. All rights reserved.
//

#import "NIMTeamCardHeaderCell+BSKY.h"
#import <NIMKit/NIMAvatarImageView.h>
#import <NIMKit/NIMCardMemberItem.h>
#import "IMEXModel.h"

static const char * kDoctorTagKey = "bs_doctorTag";

@implementation NIMTeamCardHeaderCell (BSKY)

+ (void)load {
    static dispatch_once_t oncetoken;
    _dispatch_once(&oncetoken, ^{
        SEL originalSelector1 = NSSelectorFromString(@"refreshData:");
        SEL swizzledSelector1 = @selector(swiz_refreshData:);
        [NIMTeamCardHeaderCell swizzleInstanceMethod:originalSelector1 with:swizzledSelector1];
    });
}
- (void)swiz_refreshData:(id<NIMKitCardHeaderData>)data;
{
    [self swiz_refreshData:data];
    self.doctorTag.hidden = YES;
    if ([data respondsToSelector:@selector(memberId)]) {
        NIMUser *user = [[NIMSDK sharedSDK].userManager userInfo:data.memberId];
        IMEXModel *exModel = [IMEXModel mj_objectWithKeyValues:user.userInfo.ext];
        self.doctorTag.hidden = exModel.professionType.integerValue == 1 ? NO : YES;
    }
}
- (UIImageView *)doctorTag
{
    // 获取对应属性的值
    if (!objc_getAssociatedObject(self, kDoctorTagKey)) {
        UIImageView *doctorTag = [[UIImageView alloc]initWithFrame:CGRectZero];
        doctorTag.image = [UIImage imageNamed:@"icon_doctorTag_big"];
        [self.imageView addSubview:doctorTag];
        [doctorTag mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.top.equalTo(self.imageView);
            make.width.height.equalTo(self.imageView.mas_width).multipliedBy(0.5);
        }];
        objc_setAssociatedObject(self, kDoctorTagKey, doctorTag, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
        return doctorTag;
    }
    return objc_getAssociatedObject(self, kDoctorTagKey);
}

@end
