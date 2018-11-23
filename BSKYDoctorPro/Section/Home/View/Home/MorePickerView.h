//
//  MorePickerView.h
//  BSKYDoctorPro
//
//  Created by 何雷 on 2017/9/21.
//  Copyright © 2017年 ky. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MorePickerView : UIView

@property (nonatomic ,copy) void (^selectedIndexs)(NSString *selectedStr,NSArray *indexs);

- (void)setItems:(NSArray *)items itemTitles:(NSArray *)itemTitles title:(NSString *)title defaultStrs:(NSArray *)defaultStrs;

- (void)show;

@end
