//
//  ArchiveFamilyDetailRequest.m
//  BSKYDoctorPro
//
//  Created by 快医科技 on 2018/1/13.
//  Copyright © 2018年 ky. All rights reserved.
//

#import "ArchiveFamilyDetailRequest.h"

@implementation ArchiveFamilyDetailRequest
- (NSString *)bs_requestUrl{
    return [NSString stringWithFormat:@"/doctor/putonrecord/findFamilyArchivesAll?familyId=%@",self.familyId];
}
- (YTKRequestMethod )requestMethod{
    return YTKRequestMethodGET;
}
- (id )requestArgument {
    return @{};
}
- (void)requestCompleteFilter{
    [super requestCompleteFilter];
    self.familyModel = [FamilyDetailModel mj_objectWithKeyValues:self.ret];
    [self.familyModel decryptModel];
}
- (void)requestFailedFilter{
    [super requestFailedFilter];
}
@end
