//
//  BSFindBCardRequest.h
//  BSKYDoctorPro
//
//  Created by kykj on 2018/4/11.
//  Copyright © 2018年 ky. All rights reserved.
//

#import <BSKYCore/BSKYCore.h>
#import "BSBankInfoModel.h"

@interface BSFindBCardRequest : BSBaseRequest

@property (nonatomic, strong) BSBankInfoModel *model;

@end
