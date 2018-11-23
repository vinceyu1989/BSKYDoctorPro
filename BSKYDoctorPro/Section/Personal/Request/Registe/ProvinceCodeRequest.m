//
//  ProvinceCodeRequest.m
//  BSKYDoctorPro
//
//  Created by kykj on 2017/11/30.
//  Copyright © 2017年 ky. All rights reserved.
//

#import "ProvinceCodeRequest.h"
#import "DivisionCodeModel.h"

@implementation ProvinceCodeRequest

- (NSString*)bs_requestUrl {
    return [NSString stringWithFormat:@"/allreq/administrative/divisioncode/%@", @(self.divisionCode)];
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
    _provinceData = [NSMutableArray arrayWithCapacity:data.count];
    if (data.count != 0) {
        for (int i=0; i<data.count; i++) {
            DivisionCodeModel *city = [[DivisionCodeModel alloc] init];
            city.divisionName = [NSString stringWithFormat:@"%@",data[i][@"divisionName"]];
            city.divisionId = [NSString stringWithFormat:@"%@",data[i][@"divisionId"]];
            city.divisionFullName = [NSString stringWithFormat:@"%@",data[i][@"divisionFullName"]];
            city.divisionCode = [NSString stringWithFormat:@"%@",data[i][@"divisionCode"]];

            if ([data[i][@"children"] isKindOfClass:[NSArray class]]) {
                NSArray *arr = data[i][@"children"];
                city.children = [NSMutableArray arrayWithCapacity:arr.count];
                for (int j=0; j<arr.count; j++) {
                    DivisionCodeModel *district = [[DivisionCodeModel alloc] init];
                    district = [DivisionCodeModel mj_objectWithKeyValues:arr[j]];
                    [city.children addObject:district];
                }
            }
            [_provinceData addObject:city];
        }
    }
}

@end
