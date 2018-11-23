//
//  BSFormsDicRequest.m
//  BSKYDoctorPro
//
//  Created by 快医科技 on 2018/1/9.
//  Copyright © 2018年 ky. All rights reserved.
//

#import "BSFormsDicRequest.h"
#import "BSDictModel.h"

@implementation BSFormsDicRequest
- (NSString *)bs_requestUrl{
    NSMutableString *string = [NSMutableString stringWithFormat:@"%@",@"/allreq/dict/typeDict"];
    if ([self.dictTypes count]) {
        [string appendString:@"?dictTypes="];
        for (NSInteger i = 0 ; i < [self.dictTypes count] ; i ++) {
            [string appendString:[self.dictTypes objectAtIndex:i]];
            if (i < [self.dictTypes count] - 1) {
                [string appendString:@","];
            }
        }
    }
    return [string stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
}
- (YTKRequestMethod )requestMethod{
    return YTKRequestMethodGET;
}
- (id )requestArgument {
    return @{};
}
- (void)requestCompleteFilter{
    [super requestCompleteFilter];
    NSArray *data = [BSDictModel mj_objectArrayWithKeyValuesArray:self.ret];
    self.dictArray = data;
//    NSLog(@"%@",data);
    
}
- (void)requestFailedFilter{
    [super requestFailedFilter];
}
@end
