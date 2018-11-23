//
//  BSGuideViewController.h
//  BSKYDoctorPro
//
//  Created by vince on 2018/9/5.
//  Copyright © 2018年 ky. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^GuideCompleteBlock)(void);
@interface BSGuideView : UIView
@property (nonatomic ,copy) GuideCompleteBlock block;
@end
