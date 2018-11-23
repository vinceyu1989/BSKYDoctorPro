//
//  StreetMabeyViewController.h
//  BSKYDoctorPro
//
//  Created by kykj on 2017/11/27.
//  Copyright © 2017年 ky. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DivisionCodeModel.h"

@class StreetMabeyViewController;
typedef void(^OrganMabeyBlock)(StreetMabeyViewController *vc,DivisionCodeModel *model);

@interface StreetMabeyViewController : UIViewController

@property (nonatomic, strong) DivisionCodeModel *model;
@property (nonatomic, strong) NSMutableArray    *dataSource;
@property (nonatomic, copy)   OrganMabeyBlock    block;

@end
