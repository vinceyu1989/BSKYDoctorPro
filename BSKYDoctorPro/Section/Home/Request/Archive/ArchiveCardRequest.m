//
//  ArchiveCardRequest.m
//  BSKYDoctorPro
//
//  Created by 快医科技 on 2018/1/13.
//  Copyright © 2018年 ky. All rights reserved.
//

#import "ArchiveCardRequest.h"

@implementation ArchiveCardRequest
- (NSString *)bs_requestUrl{
    return [NSString stringWithFormat:@"/doctor/putonrecord/isCard?card=%@",[[self.card encryptCBCStr] urlencode]];
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
