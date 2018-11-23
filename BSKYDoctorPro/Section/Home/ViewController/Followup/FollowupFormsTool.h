//
//  FollowupFormsTool.h
//  BSKYDoctorPro
//
//  Created by 何雷 on 2017/12/4.
//  Copyright © 2017年 ky. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FollowupUpModel.h"
#import "BSFollowup.h"

static NSString * const kFollowupAddMedicate = @"添加的药品";
static NSString * const kFollowupAddMedicateP = @"添加的药品-普通";
static NSString * const kFollowupAddMedicateG = @"添加的药品-高血压";
static NSString * const kFollowupAddMedicateT = @"添加的药品-糖尿病";
static NSString * const kFollowupAddMedicateY = @"添加的药品-胰岛素";

@interface FollowupFormsTool : NSObject

// 获取上次随访数据
+ (void)initLastDataWithPlanModel:(BSFollowup *)planModel success:(YTKRequestCompletionBlock)success failure:(YTKRequestCompletionBlock)failure;

// 获取随访次数
+ (void)initLastCountWithPlanModel:(BSFollowup *)planModel success:(YTKRequestCompletionBlock)success failure:(YTKRequestCompletionBlock)failure;

// 配置默认数据
+ (void)configDefaultUIArray:(NSMutableArray *)uiArray lastModel:(FollowupUpModel *)upModel planModel:(BSFollowup *)planModel;

// 配置UIArray
+ (void)configUIArray:(NSMutableArray *)uiArray lastModel:(FollowupUpModel *)upModel planModel:(BSFollowup *)planModel;

// 获取其他症状
+ (NSString *)getOtherSymptomStrWithUpModel:(FollowupUpModel *)upModel;

// 检测上传数据
+ (NSString *)checkUpModel:(FollowupUpModel *)upModel planModel:(BSFollowup *)planModel;

// 获取BmiString
+ (NSString *)getBmiStringWithUpModel:(FollowupUpModel *)upModel;

// 检查药品信息
+ (BOOL)checkDurgInfoWithUpModel:(FollowupUpModel *)upModel;

@end
