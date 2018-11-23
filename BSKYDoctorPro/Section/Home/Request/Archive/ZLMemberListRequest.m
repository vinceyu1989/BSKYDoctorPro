//
//  ZLMemberListRequest.m
//  BSKYDoctorPro
//
//  Created by 快医科技 on 2018/2/28.
//  Copyright © 2018年 ky. All rights reserved.
//

#import "ZLMemberListRequest.h"
#import "FamilyListModel.h"

@implementation ZLMemberListRequest
- (NSString *)bs_requestUrl{
    return [NSString stringWithFormat:@"/doctor/sczl/putonrecord/memberslist?familyId=%@&pageSize=50&pageIndex=1",self.familyID];
}
- (YTKRequestMethod )requestMethod{
    return YTKRequestMethodGET;
}
- (id )requestArgument {
    return @{};
}
- (void)requestCompleteFilter{
    [super requestCompleteFilter];
    self.dataArray = [ZLFamilyMemberListModel mj_objectArrayWithKeyValuesArray:self.ret];
    
}
- (void)requestFailedFilter{
    [super requestFailedFilter];
}
@end
