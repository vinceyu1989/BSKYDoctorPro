//
//  PatientListModel.h
//  BSKYDoctorPro
//
//  Created by vince on 2018/9/5.
//  Copyright © 2018年 ky. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PatientListModel : NSObject
@property (nonatomic ,copy) NSString *age;
@property (nonatomic ,copy) NSString *cardId;
@property (nonatomic ,copy) NSString *deptName;
@property (nonatomic ,copy) NSString *doctorName;
@property (nonatomic ,copy) NSString *listId;
@property (nonatomic ,copy) NSString *personId;
@property (nonatomic ,copy) NSString *personName;
@property (nonatomic ,copy) NSString *sex;
- (void)decryptModel;
@end
