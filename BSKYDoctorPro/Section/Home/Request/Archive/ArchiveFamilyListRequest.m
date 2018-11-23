//
//  ArchiveFamilyListRequest.m
//  BSKYDoctorPro
//
//  Created by 快医科技 on 2018/1/9.
//  Copyright © 2018年 ky. All rights reserved.
//

#import "ArchiveFamilyListRequest.h"
#import "FamilyListModel.h"

@implementation ArchiveFamilyListRequest
- (NSString *)bs_requestUrl{
    NSMutableString *urlBodyStr = [[NSMutableString alloc] initWithString:@"/doctor/putonrecord/familyAchive?"];
    
    if (self.pageSize.length) {
        [urlBodyStr appendString:[NSString stringWithFormat:@"pageSize=%@",self.pageSize]];
    }else{
        [urlBodyStr appendString:[NSString stringWithFormat:@"pageSize=%@",@"20"]];
    }
    if (self.pageIndex.length) {
        [urlBodyStr appendString:[NSString stringWithFormat:@"&pageIndex=%@",self.pageIndex]];
    }else{
        [urlBodyStr appendString:[NSString stringWithFormat:@"&pageIndex=%@",@"1"]];
    }
    if (self.familyCodeOrName.length) {
        [urlBodyStr appendString:[NSString stringWithFormat:@"&familyCodeOrName=%@",[[self.familyCodeOrName encryptCBCStr] urlencode]]];
    }else{
        [urlBodyStr appendString:[NSString stringWithFormat:@"&familyCodeOrName=%@",@""]];
    }
    
    return urlBodyStr;
}
- (YTKRequestMethod )requestMethod{
    return YTKRequestMethodGET;
}
- (id )requestArgument {
    return @{};
}
- (void)requestCompleteFilter{
    [super requestCompleteFilter];
    self.familyListData = [FamilyListModel mj_objectArrayWithKeyValuesArray:self.ret];
    [self.familyListData decryptArray];
}
- (void)requestFailedFilter{
    [super requestFailedFilter];
}
@end
