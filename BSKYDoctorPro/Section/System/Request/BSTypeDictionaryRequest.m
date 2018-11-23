//
//  BSTypeDictionaryRequest.m
//  BSKYDoctorPro
//
//  Created by kykj on 2018/1/12.
//  Copyright © 2018年 ky. All rights reserved.
//

#import "BSTypeDictionaryRequest.h"
#import "BSTypeDictionaryModel.h"
@implementation BSTypeDictionaryRequest

- (NSString*)bs_requestUrl {
    return [NSString stringWithFormat:@"/allreq/dict/typeDict"];
}

- (YTKRequestMethod)requestMethod {
    return YTKRequestMethodGET;
}

- (id)requestArgument {
    return @{@"dictTypes":self.dictTypes};
}

- (void)requestCompleteFilter {
    [super requestCompleteFilter];
    if (self.ret != nil && [self.ret isKindOfClass:[NSArray class]]) {
        NSArray *arr = (NSArray *)self.ret;
        NSDictionary *dic = arr.firstObject;
        if ([dic.allKeys containsObject:@"dictList"]) {
            self.dictTypesData = [BSTypeDictionaryModel mj_objectArrayWithKeyValuesArray:dic[@"dictList"]];
        }
    }
}

- (void)requestFailedFilter {
    [super requestFailedFilter];
}

@end
