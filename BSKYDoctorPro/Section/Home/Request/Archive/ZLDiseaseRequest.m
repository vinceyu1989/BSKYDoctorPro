//
//  ZLDiseaseRequest.m
//  BSKYDoctorPro
//
//  Created by 快医科技 on 2018/3/5.
//  Copyright © 2018年 ky. All rights reserved.
//

#import "ZLDiseaseRequest.h"
#import "ZLDiseaseModel.h"

@implementation ZLDiseaseRequest
- (NSString *)bs_requestUrl{
    self.searchKey = [self.searchKey stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    if (!self.pageSize) {
        self.pageSize = 100;
    }
    return [NSString stringWithFormat:@"/doctor/sczl/putonrecord/illnessList?allQuery=%@&pageSize=%lu&pageIndex=%lu",self.searchKey,self.pageSize,self.pageIndex];
}
- (YTKRequestMethod )requestMethod{
    return YTKRequestMethodGET;
}
- (id )requestArgument {
    return @{};
}
- (void)requestCompleteFilter{
    [super requestCompleteFilter];
    self.dataArray = [ZLDiseaseModel mj_objectArrayWithKeyValuesArray:self.ret];
    
}
- (void)requestFailedFilter{
    [super requestFailedFilter];
}
@end
