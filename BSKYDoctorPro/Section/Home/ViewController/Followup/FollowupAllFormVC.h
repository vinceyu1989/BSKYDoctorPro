//
//  FollowupAllFormVC.h
//  BSKYDoctorPro
//
//  Created by 何雷 on 2017/11/23.
//  Copyright © 2017年 ky. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FollowupAllFormVC : UIViewController

@property (nonatomic ,strong)BSFollowup *planModel;

@property (nonatomic, copy) void (^backAllBlock)(NSString *sourceRecID);

@end
