//
//  ZLFollowupFormVM.h
//  BSKYDoctorPro
//
//  Created by 何雷 on 2018/3/5.
//  Copyright © 2018年 ky. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BSFollowup.h"
#import "ZLFollowupLastModel.h"

@class FollowupCheckModel;

@interface ZLFollowupFormVM : NSObject

SYNTHESIZE_SINGLETON_FOR_CLASS_HEADER(ZLFollowupFormVM)

// 获取上次随访数据
- (void)getLastDataWithPlanModel:(BSFollowup *)planModel success:(YTKRequestCompletionBlock)success failure:(YTKRequestCompletionBlock)failure;

// 获取随访次数
- (void)getYearCountWithPlanModel:(BSFollowup *)planModel success:(YTKRequestCompletionBlock)success failure:(YTKRequestCompletionBlock)failure;

// 配置默认数据
- (void)configDefaultUIArray:(NSMutableArray *)uiArray lastModel:(ZLFollowupLastModel *)dataModel planModel:(BSFollowup *)planModel;

// 配置UIArray
- (void)configUIArray:(NSMutableArray *)uiArray lastModel:(ZLFollowupLastModel *)dataModel planModel:(BSFollowup *)planModel;

// 根据ui操作结果配置dataModel
- (void)configDataModel:(ZLFollowupLastModel *)dataModel baseCell:(FormBaseCell *)cell uiModel:(InterviewInputModel *)uiModel;

// 检测上传数据
- (FollowupCheckModel *)checkDataModel:(ZLFollowupLastModel *)dataModel planModel:(BSFollowup *)planModel uiArray:(NSMutableArray *)uiArray;

// 保存随访数据
- (void)upDataModel:(ZLFollowupLastModel *)dataModel planModel:(BSFollowup *)planModel success:(YTKRequestCompletionBlock)success failure:(YTKRequestCompletionBlock)failure;

// 获取bmi
- (NSString *)getBmiStringWithDataModel:(ZLFollowupLastModel *)dataModel;

@end

@interface FollowupCheckModel : NSObject

@property (nonatomic, assign) BOOL isValid;             // 是否有效
@property (nonatomic, copy) NSString *contentStr;       // 内容
@property (nonatomic, strong) NSIndexPath * indexPath;  // 定位

@end

