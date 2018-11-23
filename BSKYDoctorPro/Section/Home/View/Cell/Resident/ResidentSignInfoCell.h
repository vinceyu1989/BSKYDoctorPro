//
//  ResidentSignInfoCell.h
//  BSKYDoctorPro
//
//  Created by 何雷 on 2018/1/20.
//  Copyright © 2018年 ky. All rights reserved.
//

#import "ResidentRefreshCell.h"
#import "BSSignContractListRequest.h"

@class ResidentSignInfoCell;

@protocol ResidentSignInfoCellDelegate <NSObject>

- (void)residentSignInfoCellSignBtnPressed:(ResidentSignInfoCell *)cell;

- (void)residentSignInfoCellMoreBtnPressed:(ResidentSignInfoCell *)cell;

@end

@interface ResidentSignInfoCell : ResidentRefreshCell

@property (nonatomic, strong) SignContractModel * dataModel;

@property (nonatomic, weak) id<ResidentSignInfoCellDelegate> delegate;

@end
