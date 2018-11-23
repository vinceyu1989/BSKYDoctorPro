//
//  BSSignFamilyMemberRequest.m
//  BSKYDoctorPro
//
//  Created by kykj on 2018/1/12.
//  Copyright © 2018年 ky. All rights reserved.
//

#import "BSSignFamilyMemberRequest.h"
#import "SignFamilyMembersModel.h"

@implementation BSSignFamilyMemberRequest

- (NSString*)bs_requestUrl {
    return [NSString stringWithFormat:@"/doctor/sign/familyMember"];
}

- (YTKRequestMethod)requestMethod {
    return YTKRequestMethodGET;
}

- (id)requestArgument {
    return @{@"familyId":self.familyId,};
}

- (void)requestCompleteFilter {
    [super requestCompleteFilter];
    if (self.ret != nil) {
        self.familyMembersData = [SignFamilyMembersModel mj_objectArrayWithKeyValuesArray:self.ret];
        [self.familyMembersData decryptArray];
    }
}

- (void)requestFailedFilter {
    [super requestFailedFilter];
}

@end
