//
//  ArchiveDiseaseDataManager.m
//  BSKYDoctorPro
//
//  Created by vince on 2018/10/23.
//  Copyright © 2018年 ky. All rights reserved.
//

#import "ArchiveDiseaseDataManager.h"

static ArchiveDiseaseDataManager *_instance;

@implementation ArchiveDiseaseDataManager
+ (ArchiveDiseaseDataManager *)dataManager{
    if (_instance == nil) {
        _instance = [[ArchiveDiseaseDataManager alloc] init];
    }
    
    return _instance;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self initDataModel];
//        [self getDivisionId];
    }
    return self;
}
//UI
- (void)initDataModel{
    NSString *pathStr = [[NSBundle mainBundle] pathForResource:@"ArhciveDisease" ofType:@"json"];
    NSData *data = [NSData dataWithContentsOfFile:pathStr];
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
    self.diseaseUIdata = [ArchiveModel mj_objectWithKeyValues:dic];
}
//data 本人下级区划
//- (void)getDivisionId{
//    ArchiveDivisionRequest *request = [[ArchiveDivisionRequest alloc] init];
//    request.regionCode =[BSAppManager sharedInstance].currentUser.divisionCode;
//    Bsky_WeakSelf;
//    [request startWithCompletionBlockWithSuccess:^(__kindof ArchiveDivisionRequest * _Nonnull request) {
//        Bsky_StrongSelf;
//        self.disivionArray = request.regionArray;
//    } failure:^(__kindof ArchiveDivisionRequest * _Nonnull request) {
//
//    }];
//
//}
//- (void)initWJWArchiveDatasuccess:(YTKRequestCompletionBlock)success failure:(YTKRequestCompletionBlock)failure{
//    BSFormsDicRequest *infoAllRequest = [[BSFormsDicRequest alloc]init];
//    infoAllRequest.dictTypes = @[@"family_location",@"gw_house_type",@"gw_toilet_type",@"gw_family_fule_type",@"gw_family_drinking_water",@"gw_rescu_people"];
//    [infoAllRequest startWithCompletionBlockWithSuccess:success failure:failure];
//}
//本人上级区划
- (void)getPersonUpDisivion{
    
}
+ (void)dellocManager{
    _instance = nil;
}
@end
