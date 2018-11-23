//
//  ResidentSearchRequest.m
//  BSKYDoctorPro
//
//  Created by 何雷 on 2018/1/17.
//  Copyright © 2018年 ky. All rights reserved.
//

#import "ResidentSearchRequest.h"

@implementation ResidentSearchRequest

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.putModel = [[ResidentSearchRequestPutModel alloc]init];
        self.putModel.isStatus = @"0";
    }
    return self;
}

- (NSString*)bs_requestUrl {
    return @"/doctor/putonrecord/personColligationList";
}

- (YTKRequestMethod)requestMethod {
    return YTKRequestMethodGET;
}
-(NSTimeInterval)requestTimeoutInterval {
    return 90;
}
- (id)requestArgument {
    return [self.putModel mj_keyValues];
}

- (void)requestCompleteFilter {
    [super requestCompleteFilter];
    self.dataList = [PersonColligationModel mj_objectArrayWithKeyValuesArray:self.ret];
    [self.dataList decryptArray];
}

- (void)requestFailedFilter {
    [super requestFailedFilter];
}

@end

@implementation ResidentSearchRequestPutModel

@end
