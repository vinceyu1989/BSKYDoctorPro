//
//  VisitListRequest.m
//  BSKYDoctorPro
//
//  Created by vince on 2018/9/5.
//  Copyright © 2018年 ky. All rights reserved.
//

#import "VisitListRequest.h"
#import "VisitListModel.h"

@implementation VisitListRequest
- (instancetype)init
{
    self = [super init];
    if (self) {
        _personId = @"";
    }
    return self;
}
- (NSString*)bs_requestUrl {
    return [NSString stringWithFormat:@"/doctor/visit/visithistorylist"];
}

- (YTKRequestMethod)requestMethod {
    return YTKRequestMethodGET;
}

- (id)requestArgument {
    return @{
             @"personId" : self.personId,
             };
}

- (void)requestCompleteFilter {
    [super requestCompleteFilter];
    
    NSDictionary* data = self.ret;
    self.listArray = [VisitListModel mj_objectArrayWithKeyValuesArray:data];
    [self.listArray decryptArray];
}

- (void)requestFailedFilter {
    [super requestFailedFilter];
    
}
@end
