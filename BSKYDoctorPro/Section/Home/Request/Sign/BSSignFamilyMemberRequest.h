//
//  BSSignFamilyMemberRequest.h
//  BSKYDoctorPro
//
//  Created by kykj on 2018/1/12.
//  Copyright © 2018年 ky. All rights reserved.
//

#import <BSKYCore/BSKYCore.h>

@interface BSSignFamilyMemberRequest : BSBaseRequest

@property (nonatomic, copy) NSString *familyId;

@property (nonatomic, strong) NSMutableArray *familyMembersData;

@end
