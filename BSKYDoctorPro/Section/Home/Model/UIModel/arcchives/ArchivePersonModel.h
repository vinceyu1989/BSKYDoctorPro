//
//  ArchivePersonModel.h
//  BSKYDoctorPro
//
//  Created by 快医科技 on 2017/12/29.
//  Copyright © 2017年 ky. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BSArchiveModel.h"

@interface ArchivePersonModel : NSObject
@property (nonatomic ,strong) ArchiveModel *baseInfo;
@property (nonatomic ,strong) ArchiveModel *relateInfo;
@property (nonatomic ,strong) ArchiveModel *medicalHistoryInfo;
@property (nonatomic ,strong) ArchiveModel *environment;
@end
