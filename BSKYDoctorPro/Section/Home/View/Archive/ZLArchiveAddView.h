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


typedef enum : NSUInteger {
    ZLArchiveAddViewTypeDisease,
    ZLArchiveAddViewTypeSurgical,
    ZLArchiveAddViewTypeFamily,
} ZLArchiveAddViewType;

typedef void(^saveSuccessBlock)(id model);

@interface ZLArchiveAddView : UIView
@property (nonatomic ,copy)ArchiveModel *model;
@property (nonatomic ,assign) BOOL isUpdate;
@property (nonatomic ,assign) ZLArchiveAddViewType *tpye;
@property (nonatomic ,copy) saveSuccessBlock successBlock;
@property (nonatomic ,strong) NSString *personId;
- (instancetype)initWithFrame:(CGRect)frame model:(ArchiveModel *)model;
- (void)show;
@end
