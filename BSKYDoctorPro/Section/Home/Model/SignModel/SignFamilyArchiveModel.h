//
//  SignFamilyArchiveModel.h
//  BSKYDoctorPro
//
//  Created by kykj on 2018/1/12.
//  Copyright © 2018年 ky. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SignFamilyArchiveModel : NSObject

@property (nonatomic, copy) NSString *familyAddress;
@property (nonatomic, copy) NSString *familyCode;    //家庭编号
@property (nonatomic, copy) NSString *familyID;
@property (nonatomic, copy) NSString *masterName;
@property (nonatomic, copy) NSString *telNumber;
- (void)decryptModel;
@end
