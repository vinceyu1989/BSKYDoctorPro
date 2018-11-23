//
//  BSTotalMessageRequest.m
//  BSKYDoctorPro
//
//  Created by kykj on 2018/4/10.
//  Copyright © 2018年 ky. All rights reserved.
//

#import "BSTotalMessageRequest.h"
#import "BSMessageModel.h"

@implementation BSTotalMessageRequest

- (NSString*)bs_requestUrl {
    return [NSString stringWithFormat:@"/doctor/news/titleTotal"];
}

- (YTKRequestMethod)requestMethod {
    return YTKRequestMethodGET;
}

- (id)requestArgument {
    return @{};
}

- (void)requestCompleteFilter {
    [super requestCompleteFilter];
    
    if (self.ret != nil) {
        self.msgArrData = [BSMessageModel mj_objectArrayWithKeyValuesArray:self.ret];
        NSInteger n = 0;
        for (BSMessageModel *model in self.msgArrData) {
            n += [model.total integerValue];
        }
        self.num = [NSString stringWithFormat:@"%ld",n];
    }
}

- (void)requestFailedFilter {
    [super requestFailedFilter];
    
}


@end
