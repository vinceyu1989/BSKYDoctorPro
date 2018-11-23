//
//  NIMContactDataCell+BSKY.h
//  BSKYDoctorPro
//
//  Created by 何雷 on 2018/5/17.
//  Copyright © 2018年 ky. All rights reserved.
//

#import "NIMContactDataCell.h"

@interface NIMContactDataCell (BSKY)

@property(nonatomic ,strong, readonly) UIImageView *doctorTag; // 医生标签

@property(nonatomic ,strong, readonly) UIImageView *genderIcon; // 性别icon

@property(nonatomic, strong, readonly) UILabel *ageLabel;

@property(nonatomic, strong, readonly) UILabel *telLabel;

@end
