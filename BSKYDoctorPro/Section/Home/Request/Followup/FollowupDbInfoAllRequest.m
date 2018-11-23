//
//  FollowupDbInfoAllRequest.m
//  BSKYDoctorPro
//
//  Created by 何雷 on 2017/11/20.
//  Copyright © 2017年 ky. All rights reserved.
//

#import "FollowupDbInfoAllRequest.h"

@implementation FollowupDbInfoAllRequest

- (NSString*)bs_requestUrl {
    
    return [NSString stringWithFormat:@"/doctor/followup/dbFollowUpInfoAll/%@/%@",self.personId,self.lastfollowdate];
}

- (YTKRequestMethod)requestMethod {
    return YTKRequestMethodGET;
}

- (id)requestArgument {
    return nil;
}

- (void)requestCompleteFilter {
    [super requestCompleteFilter];
    NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithDictionary:self.ret];
    if (dic[@"cmDiab"]) {
        [dic setObject:dic[@"cmDiab"] forKey:@"cmModel"];
        [dic removeObjectForKey:@"cmDiab"];
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
