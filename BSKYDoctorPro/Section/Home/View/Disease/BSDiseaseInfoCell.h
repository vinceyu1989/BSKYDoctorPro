//
//  BSDiseaseInfoCell.h
//  BSKYDoctorPro
//
//  Created by kykj on 2018/8/20.
//  Copyright © 2018年 ky. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BSDiseaseInfoModel.h"

typedef void(^DiseaseInfoCellBlock)(BSDiseaseInfoModel *model,NSString *type);

@interface BSDiseaseInfoCell : UITableViewCell

@property (nonatomic, strong) BSDiseaseInfoModel *model;
@property (nonatomic, copy) DiseaseInfoCellBlock block;

@end
