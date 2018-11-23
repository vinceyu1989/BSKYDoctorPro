//
//  ResidentPhotoRequest.h
//  BSKYDoctorPro
//
//  Created by 何雷 on 2018/1/23.
//  Copyright © 2018年 ky. All rights reserved.
//

#import <BSKYCore/BSKYCore.h>

@interface ResidentPhotoRequest : BSBaseRequest

@property (nonatomic, copy) NSString * personId;

@property (nonatomic, copy) NSString * data;

@end
