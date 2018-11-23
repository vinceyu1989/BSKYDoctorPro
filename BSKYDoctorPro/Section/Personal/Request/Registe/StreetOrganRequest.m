//
//  StreetOrganRequest.m
//  BSKYDoctorPro
//
//  Created by kykj on 2017/11/30.
//  Copyright © 2017年 ky. All rights reserved.
//

#import "StreetOrganRequest.h"
#import "DivisionCodeModel.h"

@implementation StreetOrganRequest
- (NSString*)bs_requestUrl {
    return [NSString stringWithFormat:@"/allreq/administrative/organizationList"];
}

- (YTKRequestMethod)requestMethod {
    return YTKRequestMethodGET;
}

- (id)requestArgument {
    return @{@"organizationArea":self.divisionId,
             @"pageSize":self.pageSize,
             @"pageNo":self.pageNo,
                 };
}

- (void)requestCompleteFilter {
    [super requestCompleteFilter];
    if (![self.ret isKindOfClass:[NSArray class]]) {
        return;
    }
    NSArray* data = self.ret;
    _streetData = [NSMutableArray arrayWithCapacity:data.count];
    if (data.count != 0) {
        for (int i=0; i<data.count; i++) {
            DivisionCodeModel *street = [[DivisionCodeModel alloc] init];
            street.divisionName = [NSString stringWithFormat:@"%@",data[i][@"organizationName"]];
            street.divisionId = [NSString stringWithFormat:@"%@",data[i][@"organizationId"]];
            [_streetData addObject:street];
        }
    }
}

@end
