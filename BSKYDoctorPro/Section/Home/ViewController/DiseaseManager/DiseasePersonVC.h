//
//  DiseasePersonVC.h
//  BSKYDoctorPro
//
//  Created by vince on 2018/10/24.
//  Copyright © 2018年 ky. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^DiseasePersonSelect)(id model);

@interface DiseasePersonVC : UIViewController
@property (nonatomic ,copy) DiseasePersonSelect selectBlock;
@end
