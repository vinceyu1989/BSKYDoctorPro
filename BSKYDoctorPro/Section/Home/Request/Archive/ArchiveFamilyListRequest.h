//
//  ArchiveFamilyListRequest.h
//  BSKYDoctorPro
//
//  Created by 快医科技 on 2018/1/9.
//  Copyright © 2018年 ky. All rights reserved.
//

#import <BSKYCore/BSKYCore.h>

@interface ArchiveFamilyListRequest : BSBaseRequest
@property (nonatomic ,strong)NSString *familyCodeOrName;
@property (nonatomic ,strong)NSString *pageSize;
@property (nonatomic ,strong)NSString *pageIndex;
@property (nonatomic ,strong)NSArray *familyListData;
@end
