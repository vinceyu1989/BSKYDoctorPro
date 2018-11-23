//
//  BSFollowupSucceedVC.h
//  BSKYDoctorPro
//
//  Created by LinfengYU on 2017/9/15.
//  Copyright © 2017年 ky. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BSFollowupSucceedVC : UIViewController

@property (nonatomic ,copy) NSString *idcard;
@property (nonatomic ,copy) NSString *realName;

@property (nonatomic, assign) FollowupType followupType;

@property (nonatomic, copy) void (^backBlock)(void);
@property (nonatomic, copy) void (^backRootBlock)(void);

@end
