//
//  BSDiseaseLibaryRequest.m
//  BSKYDoctorPro
//
//  Created by 快医科技 on 2018/1/13.
//  Copyright © 2018年 ky. All rights reserved.
//

#import "BSDiseaseLibaryRequest.h"

@implementation BSDiseaseLibaryRequest
- (NSString *)bs_requestUrl{
    return @"/doctor/putonrecord/diseaseLibrary";
}
- (YTKRequestMethod )requestMethod{
    return YTKRequestMethodGET;
}
- (id )requestArgument {
    return @{};
}
- (void)requestCompleteFilter{
    [super requestCompleteFilter];
    self.diseaseArray = [DiseaseModel mj_objectArrayWithKeyValuesArray:self.ret];
}
- (void)requestFailedFilter{
    [super requestFailedFilter];
}
@end
