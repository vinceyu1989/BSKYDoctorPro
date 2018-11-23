//
//  ZLChecCardRequest.m
//  BSKYDoctorPro
//
//  Created by 快医科技 on 2018/2/28.
//  Copyright © 2018年 ky. All rights reserved.
//

#import "ZLCheckCardRequest.h"

@implementation ZLCheckCardRequest
- (NSString *)bs_requestUrl{
    return [NSString stringWithFormat:@"/doctor/sczl/putonrecord/isPersonArchive?cardId=%@",self.card];
}
- (YTKRequestMethod )requestMethod{
    return YTKRequestMethodGET;
}
- (id )requestArgument {
    return @{};
}
- (void)requestCompleteFilter{
    [super requestCompleteFilter];
    
}
- (void)requestFailedFilter{
    [super requestFailedFilter];
}
@end
