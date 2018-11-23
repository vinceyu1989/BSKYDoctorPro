//
//  BSSignFamilyArchiveRequest.h
//  BSKYDoctorPro
//
//  Created by kykj on 2018/1/12.
//  Copyright © 2018年 ky. All rights reserved.
//

#import <BSKYCore/BSKYCore.h>
//查询家庭档案信息列表
@interface BSSignFamilyArchiveRequest : BSBaseRequest

@property (nonatomic, copy) NSString *familyCodeOrName;
@property (nonatomic, copy) NSNumber *pageSize;
@property (nonatomic, copy) NSNumber *pageIndex;

@property (nonatomic, strong) NSMutableArray *familyArchiveData;

@end
