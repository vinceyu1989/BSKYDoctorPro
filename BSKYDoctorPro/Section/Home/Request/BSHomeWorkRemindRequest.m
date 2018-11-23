//
//  BSHomeWorkRemindRequest.m
//  BSKYDoctorPro
//
//  Created by vince on 2018/8/16.
//  Copyright © 2018年 ky. All rights reserved.
//

#import "BSHomeWorkRemindRequest.h"

@implementation BSHomeWorkRemindRequest
- (NSString*)bs_requestUrl {
    NSMutableString *urlStr = [[NSMutableString alloc] initWithString:@"/doctor/work/isWork?"];
    if (self.name.length) {
        [urlStr appendString:[NSString stringWithFormat:@"name=%@&",[self.name stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding]]];
    }
    if (self.tipsType.length) {
        [urlStr appendString:[NSString stringWithFormat:@"tipsType=%@&",self.tipsType]];
    }else{
        [urlStr appendString:[NSString stringWithFormat:@"tipsType=%@&",@"-1"]];
    }
    if (self.orgID.length) {
        [urlStr appendString:[NSString stringWithFormat:@"orgID=%@&",self.orgID]];
    }else{
        self.orgID = [NSString stringWithFormat:@"%@",[BSAppManager sharedInstance].currentUser.phisInfo.OrgId];
        [urlStr appendString:[NSString stringWithFormat:@"orgID=%@&",self.orgID]];
    }
    if (self.doctorId.length) {
        [urlStr appendString:[NSString stringWithFormat:@"doctorId=%@&",self.doctorId]];
    }else{
        self.doctorId = [NSString stringWithFormat:@"%@",[BSAppManager sharedInstance].currentUser.phisInfo.EmployeeID];
        [urlStr appendString:[NSString stringWithFormat:@"doctorId=%@&",self.doctorId]];
    }
    if (self.pageSize.length) {
        [urlStr appendString:[NSString stringWithFormat:@"pageSize=%@&",self.pageSize]];
    }else{
        [urlStr appendString:[NSString stringWithFormat:@"pageSize=%@&",@"20"]];
    }
    if (self.pageIndex.length) {
        [urlStr appendString:[NSString stringWithFormat:@"pageIndex=%@&",self.pageIndex]];
    }else{
        [urlStr appendString:[NSString stringWithFormat:@"pageIndex=%@&",@"1"]];
    }
    return urlStr;
}

- (YTKRequestMethod)requestMethod {
    return YTKRequestMethodGET;
}

- (id)requestArgument {
    return @{};
}

- (void)requestCompleteFilter {
    [super requestCompleteFilter];
    
    id data = self.ret;
    if ([data isKindOfClass:[NSString class]] || [data isKindOfClass:[NSNumber class]]) {
        self.remind = [data boolValue];
    }
    
    
   
}

- (void)requestFailedFilter {
    [super requestFailedFilter];
    
}
@end
