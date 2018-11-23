//
//  BSDiseaseListRequest.m
//  BSKYDoctorPro
//
//  Created by kykj on 2018/8/21.
//  Copyright © 2018年 ky. All rights reserved.
//

#import "BSDiseaseListRequest.h"
#import "BSDiseaseInfoModel.h"

@implementation BSDiseaseListRequest

- (NSString*)bs_requestUrl {
    return @"/doctor/lentivirus/lentiviruslist";
}

- (YTKRequestMethod)requestMethod {
    return YTKRequestMethodGET;
}

- (id)requestArgument {
    return @{@"regionID":self.regionID,
             @"buildType":self.buildType,
             @"pageSize":self.pageSize,
             @"pageIndex":self.pageIndex,
             @"keyValue":[self.keyValue encryptCBCStr],
             @"phoneTel":self.phoneTel,
             @"isClose":self.isClose,
             @"isPoor":self.isPoor,
             @"hasFollowup":self.hasFollowup,
             };
}

- (void)requestCompleteFilter {
    [super requestCompleteFilter];
    self.listData = [BSDiseaseInfoModel mj_objectArrayWithKeyValuesArray:self.ret];
    [self.listData decryptArray];
}

- (void)requestFailedFilter {
    [super requestFailedFilter];
    
}

@end
