//
//  ArchiveDiseaseRequest.m
//  BSKYDoctorPro
//
//  Created by vince on 2018/10/23.
//  Copyright © 2018年 ky. All rights reserved.
//

#import "ArchiveChronicDiseaseRequest.h"

@implementation ArchiveChronicDiseaseRequest
- (NSString*)bs_requestUrl {
    return @"/doctor/lentivirus/chronicdisease";
}

- (YTKRequestMethod)requestMethod {
    return YTKRequestMethodPOST;
}

- (YTKRequestSerializerType)requestSerializerType{
    return YTKRequestSerializerTypeJSON;
}

- (id)requestArgument {
    return self.dataDic;
}

- (void)requestCompleteFilter {
    [super requestCompleteFilter];
    if([self.ret isKindOfClass:[NSDictionary class]]){
        self.diseaseArchiveId = self.ret[@"id"];
    }
}

- (void)requestFailedFilter {
    [super requestFailedFilter];
    
}
@end
