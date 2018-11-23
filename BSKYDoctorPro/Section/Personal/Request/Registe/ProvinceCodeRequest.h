//
//  ProvinceCodeRequest.h
//  BSKYDoctorPro
//
//  Created by kykj on 2017/11/30.
//  Copyright © 2017年 ky. All rights reserved.
//

#import <BSKYCore/BSKYCore.h>

@interface ProvinceCodeRequest : BSBaseRequest

@property (nonatomic, assign) NSInteger       divisionCode;
@property (nonatomic, copy)   NSMutableArray *provinceData;

@end
