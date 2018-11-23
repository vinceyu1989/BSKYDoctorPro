//
//  ArchiveDiseaseRequest.h
//  BSKYDoctorPro
//
//  Created by vince on 2018/10/23.
//  Copyright © 2018年 ky. All rights reserved.
//

#import "BSBaseRequest.h"

@interface ArchiveChronicDiseaseRequest : BSBaseRequest
@property (nonatomic ,strong) NSDictionary *dataDic;
@property (nonatomic ,copy) NSString *diseaseArchiveId;
@end
