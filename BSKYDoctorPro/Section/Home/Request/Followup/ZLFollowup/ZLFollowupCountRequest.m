//
//  ZLFollowupCountRequest.m
//  BSKYDoctorPro
//
//  Created by 何雷 on 2018/3/19.
//  Copyright © 2018年 ky. All rights reserved.
//

#import "ZLFollowupCountRequest.h"

@implementation ZLFollowupCountRequest

- (NSString*)bs_requestUrl {
    
    return nil;
}

- (YTKRequestMethod)requestMethod {
    return YTKRequestMethodGET;
}

- (id)requestArgument {
    
    return @{@"personId":self.personId};
}

- (void)requestCompleteFilter {
    [super requestCompleteFilter];
    if (self.ret && [self.ret isKindOfClass:[NSNumber class]]) {
        self.count = ((NSNumber *)self.ret).integerValue;
    }
}

@end

@implementation ZLHyFollowupCountRequest

- (NSString*)bs_requestUrl {
    
    return @"/doctor/sczl/followUp/userHyFollowUpCount";
}
@end

@implementation ZLDbFollowupCountRequest

- (NSString*)bs_requestUrl {
    
    return @"/doctor/sczl/followUp/userDbFollowUpCount";
}
@end
