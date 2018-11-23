//
//  ArchivePersonHistoryRequest.h
//  BSKYDoctorPro
//
//  Created by 快医科技 on 2018/1/13.
//  Copyright © 2018年 ky. All rights reserved.
//

#import <BSKYCore/BSKYCore.h>

@interface ArchivePersonHistoryRequest : BSBaseRequest
@property (nonatomic ,strong)NSArray *personHistoryInVMList;
@end

@interface UpdatePersonHistoryRequest : BSBaseRequest
@property (nonatomic ,strong)NSArray *personHistoryInVMList;
@end
