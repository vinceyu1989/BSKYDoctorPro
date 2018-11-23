//
//  FamilyListModel.h
//  BSKYDoctorPro
//
//  Created by 快医科技 on 2018/1/9.
//  Copyright © 2018年 ky. All rights reserved.
//

#import <Foundation/Foundation.h>

//卫计委
@interface FamilyListModel : NSObject
@property (nonatomic ,copy) NSString *FamilyAddress;
@property (nonatomic ,copy) NSString *FamilyCode;
@property (nonatomic ,copy) NSString *FamilyID;
@property (nonatomic ,copy) NSString *MasterName;
@property (nonatomic ,copy) NSString *TelNumber;
@property (nonatomic ,copy) NSString *RegionCode;
@property (nonatomic ,copy) NSString *RegionID;
- (void)decryptModel;
@end

@interface FamilyMemberListModel : NSObject
@property (nonatomic ,copy) NSString *Age;
@property (nonatomic ,copy) NSString *CardID;
@property (nonatomic ,copy) NSString *GenderCode;
@property (nonatomic ,copy) NSString *Name;
@property (nonatomic ,copy) NSString *PersonCode;
@property (nonatomic ,copy) NSString *PersonId;
@property (nonatomic ,copy) NSString *Telphone;
@end

//中年
@interface ZLFamilyListModel : NSObject
@property (nonatomic ,copy) NSString *familyAddress;
@property (nonatomic ,copy) NSString *familyArchiveId;
@property (nonatomic ,copy) NSString *familyId;
@property (nonatomic ,copy) NSString *masterId;
@property (nonatomic ,copy) NSString *masterName;
@property (nonatomic ,copy) NSString *telNumber;
@end

@interface ZLFamilyMemberListModel : NSObject
@property (nonatomic ,copy) NSString *age;
@property (nonatomic ,copy) NSString *archiveId;
@property (nonatomic ,copy) NSString *cardId;
@property (nonatomic ,copy) NSString *code;
@property (nonatomic ,copy) NSString *familyArchiveId;
@property (nonatomic ,copy) NSString *familyId;
@property (nonatomic ,copy) NSString *gender;
@property (nonatomic ,copy) NSString *masterId;
@property (nonatomic ,copy) NSString *masterName;
@property (nonatomic ,copy) NSString *name;
@property (nonatomic ,copy) NSString *personId;
@property (nonatomic ,copy) NSString *telPhone;
@end
