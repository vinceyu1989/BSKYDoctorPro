//
//  BSAppUpdateView.h
//  BSKYDoctorPro
//
//  Created by LinfengYU on 2017/9/22.
//  Copyright © 2017年 ky. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BSAppUpdateView : UIView

@property (nonatomic, copy) NSString* info;
@property (nonatomic, assign) BOOL mandatoryUpdate;

+ (BSAppUpdateView*)showInView:(UIView*)view animated:(BOOL)animated info:(NSString*)info mandatoryUpdate:(BOOL)mandatoryUpdate;

- (void)hide;

@end
