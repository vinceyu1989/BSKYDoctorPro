//
//  InterviewPickerView.h
//  BSKYDoctorPro
//
//  Created by 何雷 on 2017/9/6.
//  Copyright © 2017年 ky. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface InterviewPickerView : UIView

@property (nonatomic ,copy) NSArray *items;

@property (nonatomic ,copy) void (^selectedComplete)(NSString *str ,NSArray *selectItems);

- (void)show;

@end
 
