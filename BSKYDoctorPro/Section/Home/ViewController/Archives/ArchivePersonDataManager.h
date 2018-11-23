//
//  ArchivePersonDataManager.h
//  BSKYDoctorPro
//
//  Created by 快医科技 on 2017/12/29.
//  Copyright © 2017年 ky. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ArchivePersonModel.h"
#import "PersonHistoryModel.h"
#import "PersonBaseInfoModel.h"
#import "FamilyListModel.h"
#import "ZLPersonModel.h"

typedef enum : NSUInteger {
    HistoryUpdateDisease = 0,
    HistoryUpdateHealth  = 1,
    HistoryUpdateFamily  = 2,
} HistoryUpdateType;

@interface ArchivePersonDataManager : NSObject
@property (nonatomic ,strong) ArchivePersonModel *dataModel;
@property (nonatomic ,strong) PersonHistoryModel *historyModel;
@property (nonatomic ,strong) PersonHistoryAddModel *historyAddModel;
@property (nonatomic ,strong) ZLPersonUIModel *zlPersonUIModel;
@property (nonatomic ,strong) ZLHistoryAddUIModel *zlHistoryAddUIModel;
@property (nonatomic ,strong) PersonBaseInfoModel *personBaseInof;
@property (nonatomic ,strong) NSMutableArray *historySelectDisease;
@property (nonatomic ,strong) NSMutableArray *historySelectFamily;
@property (nonatomic ,strong) NSArray *diseaseArray;
@property (nonatomic ,strong) NSArray *familyMemberArray;
@property (nonatomic ,strong) FamilyListModel *familyListModel;
@property (nonatomic ,strong) NSArray *memberShipArray;
@property (nonatomic ,strong) NSDictionary *dataDic;
@property (nonatomic ,strong) NSMutableArray *historyDiseaseArray;
@property (nonatomic ,strong) NSMutableArray *historyHealthArray;
@property (nonatomic ,strong) NSMutableArray *historyFamilyArray;
@property (nonatomic ,strong) NSArray *zlCityArray;
@property (nonatomic ,strong) NSMutableArray *zlFamilyRelationForHistory;
@property (nonatomic ,strong) NSArray *zlCommitteeArrayOfAdress;
@property (nonatomic ,strong) NSArray *zlCommitteeArrayOfRegister;
@property (nonatomic ,strong) NSDictionary *zlHistoryCodeSet;
+ (ArchivePersonDataManager *)dataManager;
+ (void)dellocManager;
- (void)getCommitteeOfAdressDict:(NSString *)code;
- (void)getCommitteeOfRegisterDict:(NSString *)code;
- (void)initWJWArchiveDatasuccess:(YTKRequestCompletionBlock)success failure:(YTKRequestCompletionBlock)failure;
- (void)initZLArchiveDatasuccess:(YTKRequestCompletionBlock)success failure:(YTKRequestCompletionBlock)failure;
//- (void)initCPArchiveDatasuccess:(YTKRequestCompletionBlock)success failure:(YTKRequestCompletionBlock)failure;
-(void)getFamilyListWithSearchStr:(NSString *)str pageSize:(NSString *)pageSize pageIndex:(NSString *)pageIndex success:(YTKRequestCompletionBlock)success failure:(YTKRequestCompletionBlock)failure;
- (void)savePersonBaseInfoWithModel:(PersonBaseInfoModel *)model success:(YTKRequestCompletionBlock)success failure:(YTKRequestCompletionBlock)failure;
- (void)setDetailHistory:(NSArray *)array type:(HistoryUpdateType )type;
- (NSMutableArray *)getUpdateDiseaseHistoryArray:(id )model index:(NSUInteger )index type:(HistoryUpdateType )type;
- (void)updateHistory:(id)model index:(NSInteger )index type:(HistoryUpdateType )type;
//疾病与家庭史排重
- (void)replaceHistorySelectFamily:(NSString *)old new:(NSString *)new;
- (void)replaceHistorySelectDisease:(NSString *)old new:(NSString *)new;
@end
