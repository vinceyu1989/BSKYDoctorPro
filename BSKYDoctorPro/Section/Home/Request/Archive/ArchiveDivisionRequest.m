//
//  ArchiveDivisionRequest.m
//  BSKYDoctorPro
//
//  Created by 快医科技 on 2018/1/17.
//  Copyright © 2018年 ky. All rights reserved.
//

#import "ArchiveDivisionRequest.h"
#import "ArchiveDivisionModel.h"

@implementation ArchiveDivisionRequest
- (NSString *)bs_requestUrl{
    return [NSString stringWithFormat:@"/allreq/administrative/divisioncode/%@",self.regionCode];
}
- (YTKRequestMethod )requestMethod{
    return YTKRequestMethodGET;
}
- (id )requestArgument {
    return @{};
}
- (void)requestCompleteFilter{
    [super requestCompleteFilter];
    NSArray *array = [ArchiveDivisionModel mj_objectArrayWithKeyValuesArray:self.ret];
    self.regionArray = array;
}
- (void)requestFailedFilter{
    [super requestFailedFilter];
}
@end
