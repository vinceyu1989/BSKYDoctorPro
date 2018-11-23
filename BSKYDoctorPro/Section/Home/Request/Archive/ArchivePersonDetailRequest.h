//
//  ArchivePersonDetailRequest.h
//  BSKYDoctorPro
//
//  Created by 快医科技 on 2018/4/3.
//  Copyright © 2018年 ky. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PersonBaseInfoModel.h"

@interface ArchivePersonDetailRequest : BSBaseRequest
@property (nonatomic ,strong) NSString *personId;
@property (nonatomic ,strong) PersonBaseInfoModel *personModel;
@end
