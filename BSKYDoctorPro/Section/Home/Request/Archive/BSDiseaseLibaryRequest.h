//
//  BSDiseaseLibaryRequest.h
//  BSKYDoctorPro
//
//  Created by 快医科技 on 2018/1/13.
//  Copyright © 2018年 ky. All rights reserved.
//

#import <BSKYCore/BSKYCore.h>
#import "PersonHistoryModel.h"

@interface BSDiseaseLibaryRequest : BSBaseRequest
@property (nonatomic ,strong)NSArray *diseaseArray;
@end
