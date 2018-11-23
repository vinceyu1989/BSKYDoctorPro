//
//  ArchiveDivisionRequest.h
//  BSKYDoctorPro
//
//  Created by 快医科技 on 2018/1/17.
//  Copyright © 2018年 ky. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ArchiveDivisionRequest : BSBaseRequest
@property (nonatomic ,strong) NSString *regionCode;
@property (nonatomic ,strong) NSArray *regionArray;
@end
