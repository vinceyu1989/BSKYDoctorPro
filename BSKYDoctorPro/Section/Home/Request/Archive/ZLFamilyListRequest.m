//
//  ZLFamilyListRequest.m
//  BSKYDoctorPro
//
//  Created by 快医科技 on 2018/2/28.
//  Copyright © 2018年 ky. All rights reserved.
//

#import "ZLFamilyListRequest.h"
#import "FamilyListModel.h"

@implementation ZLFamilyListRequest
- (NSString *)bs_requestUrl{
    NSMutableString *urlBodyStr = [[NSMutableString alloc] initWithString:@"/doctor/sczl/putonrecord/archiveslist?"];
    
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
        [urlBodyStr appendString:[NSString stringWithFormat:@"&masterParam=%@",self.familyCodeOrName]];
    }else{
//        [urlBodyStr appendString:[NSString stringWithFormat:@"&masterParam=%@",@""]];
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
    self.familyListData = [ZLFamilyListModel mj_objectArrayWithKeyValuesArray:self.ret];
}
- (void)requestFailedFilter{
    [super requestFailedFilter];
}
@end
