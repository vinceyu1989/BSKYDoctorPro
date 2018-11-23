//
//  BSHomeStatisticRequest.h
//  BSKYDoctorPro
//
//  Created by LinfengYU on 2017/9/12.
//  Copyright © 2017年 ky. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BSHomeStatisticRequest : BSBaseRequest

@property (nonatomic, copy) NSString *putOnRecordCount;
@property (nonatomic, copy) NSString *signedCount;
@property (nonatomic, copy) NSString *followUpCount;

@end
