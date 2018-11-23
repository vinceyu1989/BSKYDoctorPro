//
//  NIMAvatarImageView+BSKY.h
//  BSKYDoctorPro
//
//  Created by 何雷 on 2018/5/18.
//  Copyright © 2018年 ky. All rights reserved.
//

#import <NIMKit/NIMAvatarImageView.h>

@interface NIMAvatarImageView (BSKY)

@property (nonatomic, strong, readonly) UIImageView * doctorTag;

- (void)bsky_sizeToFit;

@end
