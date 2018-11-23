//
//  BSEduTeachModelVC.h
//  BSKYDoctorPro
//
//  Created by jangry on 2018/7/12.
//  Copyright © 2018年 ky. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BSEduHealthContentModel.h"

typedef void(^ContentBlock)(BSEduHealthContentModel *model);

@interface BSEduTeachModelVC : UIViewController

@property (nonatomic, copy) NSString *eduTitle;
@property (nonatomic, copy) ContentBlock block;

@end
