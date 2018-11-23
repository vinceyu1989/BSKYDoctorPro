//
//  FollowupGtInfoAllRequest.m
//  BSKYDoctorPro
//
//  Created by 何雷 on 2017/12/11.
//  Copyright © 2017年 ky. All rights reserved.
//

#import "FollowupGtInfoAllRequest.h"

@implementation FollowupGtInfoAllRequest

- (NSString*)bs_requestUrl {
    
    return @"/doctor/hydbfollowup/hyDbFollowUpInfo";
}

- (YTKRequestMethod)requestMethod {
    return YTKRequestMethodGET;
}
- (id)requestArgument {
    return @{@"personId": self.personId};
}

- (void)requestCompleteFilter {
    [super requestCompleteFilter];
    NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithDictionary:self.ret];
    if (dic[@"cmHyDb"]) {
        [dic setObject:dic[@"cmHyDb"] forKey:@"cmModel"];
        [dic removeObjectForKey:@"cmHyDb"];
    }
    NSMutableDictionary *laboraDic = [NSMutableDictionary dictionaryWithDictionary:dic[@"labora"]]; // 辅助检查没有默认值
    if (laboraDic) {
        for (NSString *key in laboraDic.allKeys) {
            if ([key isEqualToString:@"fastingBloodGlucose"] ||
                [key isEqualToString:@"postprandialBloodGlucose"] ||
                [key isEqualToString:@"randomBloodGlucose"] ||
                [key isEqualToString:@"glycatedHemoglobin"] ||
                [key isEqualToString:@"examDate"] ) {
            }
            else
            {
                [laboraDic removeObjectForKey:key];
            }
        }
        [dic removeObjectForKey:@"labora"];
        [dic setObject:laboraDic forKey:@"labora"];
    }
    self.lastModel = [FollowupUpModel mj_objectWithKeyValues:dic];
}

- (void)requestFailedFilter {
    [super requestFailedFilter];
    
}

@end
