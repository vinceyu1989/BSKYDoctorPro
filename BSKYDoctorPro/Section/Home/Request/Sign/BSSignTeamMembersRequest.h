//
//  BSSignTeamMembersRequest.h
//  BSKYDoctorPro
//
//  Created by kykj on 2018/1/12.
//  Copyright © 2018年 ky. All rights reserved.
//

#import <BSKYCore/BSKYCore.h>

@interface BSSignTeamMembersRequest : BSBaseRequest

@property (nonatomic, copy) NSString *teamId;

@property (nonatomic, strong) NSMutableArray *teamMembersData;

@end
