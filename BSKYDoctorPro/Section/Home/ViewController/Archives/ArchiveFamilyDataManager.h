//
//  ArchiveFamilyDataManager.h
//  BSKYDoctorPro
//
//  Created by 快医科技 on 2018/1/16.
//  Copyright © 2018年 ky. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BSArchiveModel.h"
#import "FamilyArchiveModel.h"

@interface ArchiveFamilyDataManager : NSObject
@property (nonatomic ,strong)FamilyArchiveModel *familyModel;
@property (nonatomic ,strong) ArchiveModel *familyUIdata;
@property (nonatomic ,strong) NSArray *disivionArray;
@property (nonatomic ,strong) NSString *regionCode;
@property (nonatomic ,strong) NSDictionary *dataDic;
+ (ArchiveFamilyDataManager *)dataManager;
+ (void)dellocManager;
- (void)initWJWArchiveDatasuccess:(YTKRequestCompletionBlock)success failure:(YTKRequestCompletionBlock)failure;
@end
