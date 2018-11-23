//
//  ArchiveFamilyHistoryRequest.h
//  BSKYDoctorPro
//
//  Created by 快医科技 on 2018/1/15.
//  Copyright © 2018年 ky. All rights reserved.
//

#import <BSKYCore/BSKYCore.h>

@interface ArchiveFamilyHistoryRequest : BSBaseRequest
@property (nonatomic ,strong) NSArray *familyHistoryInVMList;
@end

@interface UpdateFamilyHistoryRequest : BSBaseRequest
@property (nonatomic ,strong) NSArray *familyHistoryInVMList;
@end
