//
//  BSFollowupSearchRequestNew.m
//  BSKYDoctorPro
//
//  Created by vince on 2018/10/12.
//  Copyright © 2018年 ky. All rights reserved.
//

#import "BSFollowupSearchRequestNew.h"

@implementation BSFollowupSearchRequestNew
- (NSString*)bs_requestUrl {
    
    return @"/doctor/followup/personalrecords";
}

- (YTKRequestMethod)requestMethod {
    return YTKRequestMethodGET;
}

- (id)requestArgument {
    return @{@"keyValue":[self.key encryptCBCStr],
             @"buildType":self.buildType,
             @"regionID":[BSAppManager sharedInstance].currentUser.divisionCode,
             @"pageIndex": self.pageIndex,
             @"pageSize": self.pageSize};
}

- (void)requestCompleteFilter {
    [super requestCompleteFilter];
    self.dataList = [FollowupUserSearchModel mj_objectArrayWithKeyValuesArray:self.ret];
    [self.dataList decryptArray];
}

- (void)requestFailedFilter {
    [super requestFailedFilter];
    
}
@end
