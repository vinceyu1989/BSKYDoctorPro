//
//  ArchiveUpdateFamilyRequest.h
//  BSKYDoctorPro
//
//  Created by 快医科技 on 2018/4/3.
//  Copyright © 2018年 ky. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FamilyArchiveModel.h"

@interface ArchiveUpdateFamilyRequest : BSBaseRequest
@property (nonatomic ,strong)NSDictionary *familyArchiveInVM;
@property (nonatomic ,strong)FamilyArchiveModel *familyModel;
@end
