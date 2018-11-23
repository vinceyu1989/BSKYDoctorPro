//
//  BSSignTeamMembersRequest.m
//  BSKYDoctorPro
//
//  Created by kykj on 2018/1/12.
//  Copyright © 2018年 ky. All rights reserved.
//

#import "BSSignTeamMembersRequest.h"
#import "SignTeamMembersModel.h"

@implementation BSSignTeamMembersRequest

- (NSString*)bs_requestUrl {
    return [NSString stringWithFormat:@"/doctor/sign/teamMembers"];
}

- (YTKRequestMethod)requestMethod {
    return YTKRequestMethodGET;
}

- (id)requestArgument {
    return @{@"teamId":self.teamId};
}

- (void)requestCompleteFilter {
    [super requestCompleteFilter];
    if (self.ret != nil) {
        self.teamMembersData = [SignTeamMembersModel mj_objectArrayWithKeyValuesArray:self.ret];
        [self.teamMembersData decryptArray];
    }
}

- (void)requestFailedFilter {
    [super requestFailedFilter];
    
}

@end
