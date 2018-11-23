//
//  FollowupDoctorModel.h
//  BSKYDoctorPro
//
//  Created by 何雷 on 2017/9/14.
//  Copyright © 2017年 ky. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FollowupDoctorModel : NSObject

@property (nonatomic ,strong) NSString *employeeId;
@property (nonatomic ,strong) NSString *employeeName;
@property (nonatomic ,strong) NSString *telphone;
- (void)decryptModel;
@end
