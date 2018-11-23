//
//  DiseaseCreatVC.h
//  BSKYDoctorPro
//
//  Created by vince on 2018/10/23.
//  Copyright © 2018年 ky. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum : NSUInteger {
    DiseaseArchivesCreateTypeGXY = 0 //高血压
} DiseaseArchivesCreateType;

@interface DiseaseCreatVC : UIViewController
@property (nonatomic ,assign) DiseaseArchivesCreateType type;
@end
