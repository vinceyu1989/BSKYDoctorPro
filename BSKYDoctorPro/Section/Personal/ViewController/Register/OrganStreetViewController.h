//
//  OrganStreetViewController.h
//  BSKYDoctorPro
//
//  Created by kykj on 2017/11/27.
//  Copyright © 2017年 ky. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DivisionCodeModel.h"

@class OrganStreetViewController;
typedef void(^OrganStreetBlock)(OrganStreetViewController *vc,DivisionCodeModel *model);

@interface OrganStreetViewController : UIViewController

@property (nonatomic, strong) NSMutableArray  *dataSource;
@property (nonatomic, copy)   OrganStreetBlock block;

@end
