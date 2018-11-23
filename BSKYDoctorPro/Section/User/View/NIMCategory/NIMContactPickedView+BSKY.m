//
//  NIMContactPickedView+BSKY.m
//  BSKYDoctorPro
//
//  Created by 何雷 on 2018/5/25.
//  Copyright © 2018年 ky. All rights reserved.
//

#import "NIMContactPickedView+BSKY.h"
#import "IMEXModel.h"

@implementation NIMContactPickedView (BSKY)

+ (void)load {
    static dispatch_once_t oncetoken;
    _dispatch_once(&oncetoken, ^{
        
        SEL originalSelector1 = NSSelectorFromString(@"addMemberInfo:");
        SEL swizzledSelector1 = @selector(swiz_addMemberInfo:);
        
        [NIMContactPickedView swizzleInstanceMethod:originalSelector1 with:swizzledSelector1];
    });
}
- (void)swiz_addMemberInfo:(NIMKitInfo *)info
{
    [self swiz_addMemberInfo:info];
    NIMUser *user = [[NIMSDK sharedSDK].userManager userInfo:info.infoId];
    IMEXModel *exModel = [IMEXModel mj_objectWithKeyValues:user.userInfo.ext];
    if (exModel.professionType.integerValue == 1) {
        for (UIView *view in self.subviews) {
            if ([view isKindOfClass:[UIScrollView class]]) {
                UIImageView *doctorTag = [[UIImageView alloc]initWithFrame:CGRectZero];
                doctorTag.image = [UIImage imageNamed:@"icon_doctorTag"];
                [view.subviews.lastObject addSubview:doctorTag];
                [doctorTag mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.left.top.equalTo(view.subviews.lastObject);
                    make.width.height.equalTo(view.subviews.lastObject.mas_width).multipliedBy(0.5);
                }];
            }
        }
    }
}

@end
