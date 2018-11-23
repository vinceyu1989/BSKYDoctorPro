//
//  BSAppManager.m
//  BSKYDoctorPro
//
//  Created by LinfengYU on 2017/9/12.
//  Copyright © 2017年 ky. All rights reserved.
//

#import "BSAppManager.h"
#import "BSGeTuiRequest.h"
#import "BSFormsDicRequest.h"
#import "BSDictModel.h"
#import "BSDiseaseLibaryRequest.h"
#import "PersonHistoryModel.h"

@implementation BSAppManager

+ (instancetype)sharedInstance {
    static BSAppManager *sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[self alloc] init];
        sharedInstance.isAudit = YES;
//        sharedInstance.needEncryption = @"";
    });
    return sharedInstance;
}
- (instancetype)init
{
    self = [super init];
    if (self) {
//        [self initDataDic];
    }
    return self;
}
- (NSMutableDictionary *)dataDic{
    if (!_dataDic) {
        _dataDic = [[NSMutableDictionary alloc] init];
    }
    return _dataDic;
}
- (NSString *)signClientId{
    NSString *str = [BSNetConfig sharedInstance].type == AppType_Release ? kGtReleaseClientId : kGtTestClientId;
    return str;
}
- (ServerType )signServerType{
    ServerType str = [BSNetConfig sharedInstance].type == AppType_Release ? Public : Integrate;
    return str;
}
- (void )setSignGetuiClientId:(BOOL)signGetuiClientId{
    if (self.getuiClientId.length && !self.signGetuiClientId && self.currentUser.userId.length) {
        _signGetuiClientId = YES;
        BSGeTuiRequest *request = [[BSGeTuiRequest alloc] init];
        
        [request startWithCompletionBlockWithSuccess:^(__kindof BSGeTuiRequest * _Nonnull request) {
            self->_signGetuiClientId = YES;
        } failure:^(__kindof BSGeTuiRequest * _Nonnull request) {
            self->_signGetuiClientId = NO;
        }];
    }
}
- (void)setCurrentUser:(BSUser *)currentUser{
    _currentUser = currentUser;
    _signGetuiClientId = NO;
    [self setSignGetuiClientId:YES];
}
- (void)setGetuiClientId:(NSString *)getuiClientId{
    _getuiClientId = getuiClientId;
    [self setSignGetuiClientId:YES];
}
- (NSMutableArray *)dataDicArray{
    if (!_dataDicArray) {
        _dataDicArray = [[NSMutableArray alloc] initWithObjects:@"gw_nation",@"gw_relationship_with_ho",@"gw_node_type",@"gw_resident_type",@"gw_relationship_with_holder",@"gw_abo_flood_typ",@"gw_rh_flood_type",@"gw_education_degree",@"gw_occupation",@"gw_marital_status",@"gw_payment_method",@"gw_drup_allergy_history",@"gw_exposure",@"gw_disability",@"gw_family_disease",@"gw_relation_shape",@"gw_kitchen_facilities",@"gw_fuel_type",@"gw_drinking_water",@"gw_toilet",@"gw_a_bird",@"gw_abo_flood_type",@"gw_IsFlowing_type", nil];
    }
    return _dataDicArray;
}
//相关字典数据
- (void)initWJWDataDicSuccess:(YTKRequestCompletionBlock)success failure:(YTKRequestCompletionBlock)failure{
    
    
    if (self.dataDic.count) {
        BSFormsDicRequest *infoAllRequest = [[BSFormsDicRequest alloc]init];
        //        infoAllRequest.dictArray = dic;
        if (success) {
            success(infoAllRequest);
        }
        
    }else{
        BSFormsDicRequest *infoAllRequest = [[BSFormsDicRequest alloc]init];
        infoAllRequest.dictTypes = [BSAppManager sharedInstance].dataDicArray;
        //        [infoAllRequest startWithCompletionBlockWithSuccess:success failure:failure];
        [infoAllRequest startWithCompletionBlockWithSuccess:^(__kindof BSFormsDicRequest * _Nonnull request) {
            for (BSDictModel *model in request.dictArray) {
                [[BSAppManager sharedInstance].dataDic setObject:model.dictList forKey:model.type];
            }
            if (success) {
                success(request);
            }
        } failure:failure];
    }
    
}
//疾病相关
- (void)initDiseaseSuccess:(YTKRequestCompletionBlock)success failure:(YTKRequestCompletionBlock)failure{
    
    
    if (self.diseaseDic.count) {
        BSDiseaseLibaryRequest *infoAllRequest = [[BSDiseaseLibaryRequest alloc]init];
        //        infoAllRequest.dictArray = dic;
        if (success) {
            success(infoAllRequest);
        }
        
    }else{
        BSDiseaseLibaryRequest *infoAllRequest = [[BSDiseaseLibaryRequest alloc]init];
        [infoAllRequest startWithCompletionBlockWithSuccess:^(__kindof BSDiseaseLibaryRequest * _Nonnull request) {
            for (DiseaseModel *model in request.diseaseArray) {
                [[BSAppManager sharedInstance].diseaseDic setObject:model forKey:model.diseaseName];
            }
            if (success) {
                success(request);
            }
        } failure:failure];
    }
    
}
@end
