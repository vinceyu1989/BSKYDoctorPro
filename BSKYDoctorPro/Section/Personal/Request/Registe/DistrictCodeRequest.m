//
//  DistrictCodeRequest.m
//  BSKYDoctorPro
//
//  Created by kykj on 2017/11/30.
//  Copyright © 2017年 ky. All rights reserved.
//

#import "DistrictCodeRequest.h"
#import "DivisionCodeModel.h"

@implementation DistrictCodeRequest

- (NSString*)bs_requestUrl {
    return [NSString stringWithFormat:@"/allreq/administrative/parent/%@", self.parentId];
}

- (YTKRequestMethod)requestMethod {
    return YTKRequestMethodGET;
}

- (id)requestArgument {
    return nil;
}

- (void)requestCompleteFilter {
    [super requestCompleteFilter];
    if (![self.ret isKindOfClass:[NSArray class]]) {
        return;
    }
    NSArray* data = self.ret;
    _districtData = [NSMutableArray arrayWithCapacity:data.count];
    if (data.count != 0) {
        for (int i=0; i<data.count; i++) {
            DivisionCodeModel *district = [[DivisionCodeModel alloc] init];
            district = [DivisionCodeModel mj_objectWithKeyValues:data[i]];
//            district.divisionName = [NSString stringWithFormat:@"%@",data[i][@"divisionName"]];
//            district.divisionId = [NSString stringWithFormat:@"%@",data[i][@"divisionId"]];
//            district.divisionCode = [NSString stringWithFormat:@"%@",data[i][@"divisionCode"]];
            [_districtData addObject:district];
        }
    }
}

@end
