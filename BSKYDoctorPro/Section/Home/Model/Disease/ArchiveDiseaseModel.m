//
//  ArhciveDiseaseModel.m
//  BSKYDoctorPro
//
//  Created by vince on 2018/10/23.
//  Copyright © 2018年 ky. All rights reserved.
//

#import "ArchiveDiseaseModel.h"

@implementation ExamBody

@end

@implementation CmPerson

@end

@implementation CmHyLevel

@end

@implementation ArchiveDiseaseModel
- (instancetype)init
{
    self = [super init];
    if (self) {
        self.examBody = [[ExamBody alloc] init];
        self.cmPerson = [[CmPerson alloc] init];
        self.cmHyLevel = [[CmHyLevel alloc] init];
    }
    return self;
}
- (void)encryptModel{
    self.personTel = [self.personTel encryptCBCStr];
    self.cmPerson.doctorName = [self.cmPerson.doctorName encryptCBCStr];
    self.cmPerson.userName = [self.cmPerson.userName encryptCBCStr];
}
@end
