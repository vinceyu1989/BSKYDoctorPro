//
//  DisivionPicker.h
//  BSKYDoctorPro
//
//  Created by 快医科技 on 2018/1/17.
//  Copyright © 2018年 ky. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ArchiveDivisionModel.h"

typedef enum : NSUInteger {
    ZLDisivionPickerTypeCity = 0,
    ZLDisivionPickerTypeCommittee = 1,
} ZLDisivionPickerType;

@interface ZLDisivionPicker : UIView<UIPickerViewDelegate,UIPickerViewDataSource>
@property (nonatomic ,copy) void (^selectedIndex)(NSInteger firstIndex,NSInteger seconIndex ,NSInteger thirdIndex);
@property (nonatomic ,assign) ZLDisivionPickerType type;
@property (nonatomic ,assign) NSUInteger section;
- (void)setItems:(NSArray *)items title:(NSString *)title defaultStr:(NSString *)defaultStr;

- (void)show;
@end
