//
//  ArhciveDiseaseModel.h
//  BSKYDoctorPro
//
//  Created by vince on 2018/10/23.
//  Copyright © 2018年 ky. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ExamBody : NSObject

@property (nonatomic, strong) NSString * examDate;
@property (nonatomic, strong) NSString * rightDbp;
@property (nonatomic, strong) NSString * rightSbp;
@end

@interface CmPerson : NSObject

@property (nonatomic, strong) NSString * diagnosisDate;
@property (nonatomic, strong) NSString * diseaseKindID;
@property (nonatomic, strong) NSString * doctorID;
@property (nonatomic, strong) NSString * doctorName;
@property (nonatomic, strong) NSString * idField;
@property (nonatomic, strong) NSString * orgID;
@property (nonatomic, strong) NSString * personID;
@property (nonatomic, strong) NSString * recordDate;
@property (nonatomic, strong) NSString * status;
@property (nonatomic, strong) NSString * userID;
@property (nonatomic, strong) NSString * userName;
@end

@interface CmHyLevel : NSObject

@property (nonatomic, strong) NSString * clinicalComplications;
@property (nonatomic, strong) NSString * cmPersonID;
@property (nonatomic, strong) NSString * hyLevel;
@property (nonatomic, strong) NSString * otherRiskFactors;
@property (nonatomic, strong) NSString * targetOrganDamage;
@end

@interface ArchiveDiseaseModel : NSObject
@property (nonatomic, strong) NSString * buildType;
@property (nonatomic, strong) CmHyLevel * cmHyLevel;
@property (nonatomic, strong) CmPerson * cmPerson;
@property (nonatomic, strong) ExamBody * examBody;
@property (nonatomic, strong) NSString * personTel;
- (void)encryptModel;
@end

