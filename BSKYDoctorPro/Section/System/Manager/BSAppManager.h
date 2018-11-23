//
//  BSAppManager.h
//  BSKYDoctorPro
//
//  Created by LinfengYU on 2017/9/12.
//  Copyright © 2017年 ky. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BjcaSignManager.h"

@interface BSAppManager : NSObject

@property (nonatomic, assign) BOOL isAudit;
@property (nonatomic, retain) BSUser *currentUser;
@property (nonatomic ,copy) NSString *publicKey;
@property (nonatomic ,copy) NSString *cbcKey;
@property (nonatomic ,copy) NSString *needEncryption;
@property (nonatomic ,copy) NSString *signClientId;
@property (nonatomic ,assign) ServerType signServerType;
@property (nonatomic ,copy) NSString *getuiClientId;
@property (nonatomic ,assign) BOOL signGetuiClientId;
@property (nonatomic ,strong) NSMutableDictionary *dataDic;
@property (nonatomic ,strong) NSMutableDictionary *diseaseDic;
@property (nonatomic ,strong) NSMutableArray *dataDicArray; //数据字曲要用到的参数
+ (instancetype)sharedInstance;
- (void)initWJWDataDicSuccess:(YTKRequestCompletionBlock)success failure:(YTKRequestCompletionBlock)failure;
- (void)initDiseaseSuccess:(YTKRequestCompletionBlock)success failure:(YTKRequestCompletionBlock)failure;
@end
