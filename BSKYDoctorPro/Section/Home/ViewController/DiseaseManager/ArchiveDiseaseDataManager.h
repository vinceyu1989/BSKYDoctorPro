//
//  ArchiveDiseaseDataManager.h
//  BSKYDoctorPro
//
//  Created by vince on 2018/10/23.
//  Copyright © 2018年 ky. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BSArchiveModel.h"

@interface ArchiveDiseaseDataManager : NSObject
@property (nonatomic ,strong) ArchiveModel *diseaseUIdata;
+ (ArchiveDiseaseDataManager *)dataManager;
+ (void)dellocManager;
@end
