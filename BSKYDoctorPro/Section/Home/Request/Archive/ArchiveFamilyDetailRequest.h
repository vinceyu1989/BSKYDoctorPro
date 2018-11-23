//
//  ArchiveFamilyDetailRequest.h
//  BSKYDoctorPro
//
//  Created by 快医科技 on 2018/1/13.
//  Copyright © 2018年 ky. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FamilyArchiveModel.h"

@interface ArchiveFamilyDetailRequest : BSBaseRequest
@property (nonatomic ,strong) NSString *familyId;
@property (nonatomic ,strong) FamilyDetailModel *familyModel;
@end
