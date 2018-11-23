//
//  TeamPickerView.h
//  BSKYDoctorPro
//
//  Created by 何雷 on 2017/8/18.
//  Copyright © 2017年 ky. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TeamPickerView : UIView

@property (nonatomic ,copy) void (^selectedIndex)(NSInteger index);

- (void)setItems:(NSArray *)items title:(NSString *)title defaultStr:(NSString *)defaultStr;

- (void)show;

@end
