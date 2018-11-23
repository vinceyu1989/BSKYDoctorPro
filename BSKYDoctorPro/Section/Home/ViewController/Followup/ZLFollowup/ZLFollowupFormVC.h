//
//  ZLFollowupFormVC.h
//  BSKYDoctorPro
//
//  Created by 何雷 on 2018/2/26.
//  Copyright © 2018年 ky. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ZLFollowupFormVC : UIViewController

@property (nonatomic ,strong)BSFollowup *planModel;

@property (nonatomic, copy) void (^backFPBlock)(void);

@end
