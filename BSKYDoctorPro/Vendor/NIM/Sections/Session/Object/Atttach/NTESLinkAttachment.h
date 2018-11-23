//
//  NTESLinkAttachment.h
//  BSKYDoctorPro
//
//  Created by vince on 2018/11/12.
//  Copyright © 2018年 ky. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NTESCustomAttachmentDefines.h"

NS_ASSUME_NONNULL_BEGIN

@interface NTESLinkAttachment : NSObject<NIMCustomAttachment,NTESCustomAttachmentInfo>

// 标题
@property (nonatomic, copy) NSString *title;

// 点击跳转的链接地址
@property (nonatomic, copy) NSString *linkUrl;

// 图片
@property (nonatomic, copy) NSString *imageUrl;

// 描述
@property (nonatomic, copy) NSString *describe;

@property (nonatomic, copy) NSString *dataStr;
@end

NS_ASSUME_NONNULL_END
