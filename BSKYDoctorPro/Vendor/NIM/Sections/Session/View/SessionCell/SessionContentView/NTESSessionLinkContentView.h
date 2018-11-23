//
//  NTESSessionLinkContentView.h
//  BSKYDoctorPro
//
//  Created by vince on 2018/11/12.
//  Copyright © 2018年 ky. All rights reserved.
//

#import "NIMSessionMessageContentView.h"

NS_ASSUME_NONNULL_BEGIN

static NSString *const NIMDemoEventNameLinkingPacket = @"NIMDemoEventNameLinkingPacket";

@interface NTESSessionLinkContentView : NIMSessionMessageContentView
// 根据宽度，字体和文本内容获取高度
+ (CGFloat)getHeightByWidth:(CGFloat)width title:(NSString *)title font:(UIFont *)font;
@end

NS_ASSUME_NONNULL_END
