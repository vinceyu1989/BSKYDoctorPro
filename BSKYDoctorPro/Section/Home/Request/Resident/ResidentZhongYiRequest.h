//
//  ResidentZhongYiRequest.h
//  BSKYDoctorPro
//
//  Created by 何雷 on 2018/1/22.
//  Copyright © 2018年 ky. All rights reserved.
//

#import <BSKYCore/BSKYCore.h>
#import "ResidentZhongYiModel.h"

@interface ResidentZhongYiRequest : BSBaseRequest

@property (nonatomic, copy) NSString * personId;

@property (nonatomic, strong) ResidentZhongYiModel * data;

@property (nonatomic, assign) ResidentRefreshStatus refreshStatus;

@end
