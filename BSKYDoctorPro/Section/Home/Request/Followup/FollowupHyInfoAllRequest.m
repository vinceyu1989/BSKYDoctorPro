//
//  FollowupHyInfoAllRequest.m
//  BSKYDoctorPro
//
//  Created by 何雷 on 2017/11/20.
//  Copyright © 2017年 ky. All rights reserved.
//

#import "FollowupHyInfoAllRequest.h"

@implementation FollowupHyInfoAllRequest

- (NSString*)bs_requestUrl {
    
    return [NSString stringWithFormat:@"/doctor/followup/hyFollowUpInfoAll/%@/%@",self.personId,self.lastfollowdate];
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
    if (dic[@"cmHyper"]) {
        [dic setObject:dic[@"cmHyper"] forKey:@"cmModel"];
        [dic removeObjectForKey:@"cmHyper"];
    }
    if (dic[@"labora"]) {
        [dic removeObjectForKey:@"labora"]; // 辅助检查没有默认值
    }
    self.lastModel = [FollowupUpModel mj_objectWithKeyValues:dic];
}

- (void)requestFailedFilter {
    [super requestFailedFilter];
    
}

@end
