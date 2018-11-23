//
//  ArchivePersonDetailRequest.m
//  BSKYDoctorPro
//
//  Created by 快医科技 on 2018/4/3.
//  Copyright © 2018年 ky. All rights reserved.
//

#import "ArchivePersonDetailRequest.h"


@implementation ArchivePersonDetailRequest
- (NSString *)bs_requestUrl{
    return [NSString stringWithFormat:@"/doctor/putonrecord/residentAll?personId=%@",self.personId];
}
- (YTKRequestMethod )requestMethod{
    return YTKRequestMethodGET;
}
- (id )requestArgument {
    return @{};
}
- (void)requestCompleteFilter{
    [super requestCompleteFilter];
    self.personModel = [PersonBaseInfoModel mj_objectWithKeyValues:self.ret];
    [self.personModel decryptDeatalModel];
}
- (void)requestFailedFilter{
    [super requestFailedFilter];
}
@end
