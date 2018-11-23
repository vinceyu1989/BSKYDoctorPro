//
//  ResidentChineseMedicineCell.h
//  BSKYDoctorPro
//
//  Created by 何雷 on 2018/1/20.
//  Copyright © 2018年 ky. All rights reserved.
//

#import "ResidentRefreshCell.h"
#import "ResidentZhongYiModel.h"

@class ResidentChineseMedicineCell;

@protocol ResidentChineseMedicineCellDelegate <NSObject>

- (void)residentChineseMedicineCellExamineBtnPressed:(ResidentChineseMedicineCell *)cell;

- (void)residentChineseMedicineCellAddBtnPressed:(ResidentChineseMedicineCell *)cell;

@end

@interface ResidentChineseMedicineCell : ResidentRefreshCell

@property (nonatomic, strong) ResidentZhongYiModel * model;

@property (nonatomic, weak) id<ResidentChineseMedicineCellDelegate> delegate;

@end
