//
//  PersonHistoryModel.h
//  BSKYDoctorPro
//
//  Created by 快医科技 on 2018/1/4.
//  Copyright © 2018年 ky. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BSArchiveModel.h"

//数据
@interface DiseaseModel : NSObject
@property (nonatomic ,copy) NSString *diseaseLibraryId;
@property (nonatomic ,copy) NSString *diseaseId;
@property (nonatomic ,copy) NSString *diseaseCode;
@property (nonatomic ,copy) NSString *diseaseName;
@property (nonatomic ,copy) NSString *interfaceServerType;
@end;

@interface AddDiseaseModel : NSObject
@property (nonatomic ,copy) NSString *diagnosisDate;
@property (nonatomic ,copy) NSString *diseaseKindName;
@property (nonatomic ,copy) NSString *diseaseKindId;
@property (nonatomic ,copy) NSString *doctorId;
@property (nonatomic ,copy) NSString *doctorName;
@property (nonatomic ,copy) NSString *orgId;
@property (nonatomic ,copy) NSString *personId;
@property (nonatomic ,copy) NSString *remark;
@property (nonatomic ,copy) NSString *userId;
@property (nonatomic ,copy) NSString *userName;
@end

@interface AddHistoryModel : NSObject
@property (nonatomic ,copy) NSString *name;
@property (nonatomic ,copy) NSString *occurrenceDate;
@property (nonatomic ,copy) NSString *personId;
@property (nonatomic ,copy) NSString *recordType;
@end

@interface AddFamilyHistoryModel : NSObject
@property (nonatomic ,copy) NSString *disease;
@property (nonatomic ,copy) NSString *personId;
@property (nonatomic ,copy) NSString *relationshipType;
@property (nonatomic ,copy) NSString *remark;
@property (nonatomic ,copy) NSString *relationShipName;
@end

@interface DiseaseModelDetail : NSObject
@property (nonatomic ,copy) NSString *DiagnosisDate;
@property (nonatomic ,copy) NSString *DiseaseName;
@property (nonatomic ,copy) NSString *DiseaseKindID;
@property (nonatomic ,copy) NSString *DoctorID;
@property (nonatomic ,copy) NSString *DoctorName;
@property (nonatomic ,copy) NSString *OrgID;
@property (nonatomic ,copy) NSString *Remark;
@property (nonatomic ,copy) NSString *UserID;
@property (nonatomic ,copy) NSString *UserName;
@property (nonatomic ,copy) NSString *ID;
@property (nonatomic ,copy) NSString *PersonID;
@end

@interface HistoryModelDetail : NSObject
@property (nonatomic ,copy) NSString *Name;
@property (nonatomic ,copy) NSString *OccurrenceDate;
@property (nonatomic ,copy) NSString *PersonID;
@property (nonatomic ,copy) NSString *RecordType;
@property (nonatomic ,copy) NSString *ID;
@end

@interface FamilyHistoryModelDetail : NSObject
@property (nonatomic ,copy) NSString *Disease;
@property (nonatomic ,copy) NSString *PersonID;
@property (nonatomic ,copy) NSString *RelationshipType;
@property (nonatomic ,copy) NSString *Remark;
@property (nonatomic ,copy) NSString *RelationShipName;
@property (nonatomic ,copy) NSString *ID;
@end
//UI
@interface PersonHistoryModel : NSObject
@property (nonatomic ,strong) ArchiveModel *pastHistory;
@property (nonatomic ,strong) ArchiveModel *familyHistory;
@property (nonatomic ,strong) ArchiveModel *geneticHistory;
@end

@interface PersonHistoryAddModel : NSObject
@property (nonatomic ,strong) ArchiveModel *diseaseHistory;
@property (nonatomic ,strong) ArchiveModel *surgeryHistory;
@property (nonatomic ,strong) ArchiveModel *traumaHistory;
@property (nonatomic ,strong) ArchiveModel *bloodHistory;
@property (nonatomic ,strong) ArchiveModel *familyHistory;
@property (nonatomic ,strong) ArchiveModel *geneticHistory;
@property (nonatomic ,strong) ArchiveModel *diseaseHistoryOther;
@end;
