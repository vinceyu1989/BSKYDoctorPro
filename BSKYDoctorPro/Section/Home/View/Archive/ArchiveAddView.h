//
//  ArchiveAddView.h
//  BSKYDoctorPro
//
//  Created by 快医科技 on 2018/1/4.
//  Copyright © 2018年 ky. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BSArchiveModel.h"
#import "ArchivePersonDataManager.h"
#import "PersonHistoryModel.h"

typedef void(^saveSuccessBlock)(id model);

@interface ArchiveAddView : UIView
@property (nonatomic ,copy)ArchiveModel *model;
@property (nonatomic ,assign) BOOL isUpdate;
@property (nonatomic ,assign) NSUInteger index;
@property (nonatomic ,copy) saveSuccessBlock successBlock;
@property (nonatomic ,strong) NSString *personId;
- (instancetype)initWithFrame:(CGRect)frame model:(ArchiveModel *)model;
- (void)show;
@end
