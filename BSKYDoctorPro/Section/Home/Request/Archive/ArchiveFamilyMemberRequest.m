//
//  AchiveFamilyMemberRequest.m
//  BSKYDoctorPro
//
//  Created by 快医科技 on 2018/1/15.
//  Copyright © 2018年 ky. All rights reserved.
//

#import "ArchiveFamilyMemberRequest.h"
#import "FamilyListModel.h"

@implementation ArchiveFamilyMemberRequest
- (NSString *)bs_requestUrl{
    return [NSString stringWithFormat:@"/doctor/putonrecord/familyMember?familyId=%@",self.familyID];
}
- (YTKRequestMethod )requestMethod{
    return YTKRequestMethodGET;
}
- (id )requestArgument {
    return @{};
}
- (void)requestCompleteFilter{
    [super requestCompleteFilter];
    self.dataArray = [FamilyMemberListModel mj_objectArrayWithKeyValuesArray:self.ret];
    
}
- (void)requestFailedFilter{
    [super requestFailedFilter];
}
@end
