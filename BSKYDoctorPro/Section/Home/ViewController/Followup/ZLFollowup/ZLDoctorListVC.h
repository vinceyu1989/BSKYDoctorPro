//
//  ZLDoctorListVC.h
//  BSKYDoctorPro
//
//  Created by 何雷 on 2018/3/9.
//  Copyright © 2018年 ky. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZLDoctorModel.h"

@interface ZLDoctorListVC : UIViewController

@property (nonatomic, copy) void(^didSelectBlock)(ZLDoctorModel *doctorModel);

@end
