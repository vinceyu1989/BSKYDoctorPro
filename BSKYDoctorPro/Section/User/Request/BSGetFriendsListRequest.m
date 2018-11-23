//
//  BSGetFriendsListRequest.m
//  BSKYDoctorPro
//
//  Created by kykj on 2018/5/17.
//  Copyright © 2018年 ky. All rights reserved.
//

#import "BSGetFriendsListRequest.h"
#import "IMFriendInfoModel.h"

@implementation BSGetFriendsListRequest

- (NSString*)bs_requestUrl {
    return @"/imsignal/find/userList";
}

- (YTKRequestMethod)requestMethod {
    return YTKRequestMethodGET;
}

- (id)requestArgument {
    return @{@"code":[self.codeStr encryptCBCStr],
             @"pageNo":self.pageNo,
             @"pageSize":self.pageSize,
             };
}

- (void)requestCompleteFilter {
    [super requestCompleteFilter];
    if (self.ret != nil) {
        self.searchData = [IMFriendInfoModel mj_objectArrayWithKeyValuesArray:self.ret];
        [self.searchData decryptArray];
    }
}

- (void)requestFailedFilter {
    [super requestFailedFilter];
    
}
@end
