//
//  BSListMessageRequest.m
//  BSKYDoctorPro
//
//  Created by kykj on 2018/4/10.
//  Copyright © 2018年 ky. All rights reserved.
//

#import "BSListMessageRequest.h"
#import "BSMessageModel.h"

@implementation BSListMessageRequest

- (instancetype)init {
    if (self = [super init]) {
        self.pageSize = @10;
        self.pageNo = @1;
    }
    return self;
}

- (NSString*)bs_requestUrl {
    return [NSString stringWithFormat:@"/doctor/news/listTitle"];
}

- (YTKRequestMethod)requestMethod {
    return YTKRequestMethodGET;
}

- (id)requestArgument {
    return @{@"type":self.type,
             @"pageSize":self.pageSize,
             @"pageNo":self.pageNo
             };
}

- (void)requestCompleteFilter {
    [super requestCompleteFilter];
    
    if (self.ret != nil) {
        self.msgListData = [BSMessageModel mj_objectArrayWithKeyValuesArray:self.ret];
    }
}

- (void)requestFailedFilter {
    [super requestFailedFilter];
}

@end
