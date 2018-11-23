//
//  ResidentPhysicalCell.h
//  BSKYDoctorPro
//
//  Created by 何雷 on 2018/1/20.
//  Copyright © 2018年 ky. All rights reserved.
//

#import "ResidentRefreshCell.h"
#import "PersonColligationModel.h"

@class ResidentPhysicalCell;

@protocol ResidentPhysicalCellDelegate <NSObject>

- (void)residentPhysicalCellExamineBtnPressed:(ResidentPhysicalCell *)cell;

- (void)residentPhysicalCellPerfectBtnPressed:(ResidentPhysicalCell *)cell;

- (void)residentPhysicalCellAddBtnPressed:(ResidentPhysicalCell *)cell;

@end

@interface ResidentPhysicalCell : ResidentRefreshCell

@property (nonatomic, strong) PersonColligationModel * model;

@property (nonatomic, weak) id<ResidentPhysicalCellDelegate> delegate;

@end
