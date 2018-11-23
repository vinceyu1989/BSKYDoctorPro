//
//  DisivionPicker.h
//  BSKYDoctorPro
//
//  Created by 快医科技 on 2018/1/17.
//  Copyright © 2018年 ky. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ArchiveDivisionModel.h"

@interface DisivionPicker : UIView<UIPickerViewDelegate,UIPickerViewDataSource>
@property (nonatomic ,copy) void (^selectedIndex)(NSInteger firstIndex,NSInteger seconIndex);

- (void)setItems:(NSArray *)items title:(NSString *)title defaultStr:(NSString *)defaultStr;

- (void)show;
@end
