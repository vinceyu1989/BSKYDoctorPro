//
//  VisitDetailModel.h
//  BSKYDoctorPro
//
//  Created by vince on 2018/9/5.
//  Copyright © 2018年 ky. All rights reserved.
//

#import <Foundation/Foundation.h>

@class VisitDetailBaseModel;
@interface VisitDetailModel : NSObject
@property (nonatomic ,strong) VisitDetailBaseModel *basicInfoDTO;
- (void)decryptModel;
@end


@interface VisitDetailBaseModel : NSObject
@property (nonatomic ,copy) NSString *age;
@property (nonatomic ,copy) NSString *deptId;
@property (nonatomic ,copy) NSString *deptName;
@property (nonatomic ,copy) NSString *doctorName;
@property (nonatomic ,copy) NSString *detailId;
@property (nonatomic ,copy) NSString *personId;
@property (nonatomic ,copy) NSString *personName;
@property (nonatomic ,copy) NSString *sex;
@property (nonatomic ,copy) NSString *subjective;
@property (nonatomic ,copy) NSString *diseaseHistory;
@property (nonatomic ,copy) NSString *doctorId;
- (void)decryptModel;
@end
