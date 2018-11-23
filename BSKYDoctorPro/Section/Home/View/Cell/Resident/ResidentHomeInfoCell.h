//
//  ResidentHomeInfoCell.h
//  BSKYDoctorPro
//
//  Created by 何雷 on 2018/1/19.
//  Copyright © 2018年 ky. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PersonColligationModel.h"

@class ResidentHomeInfoCell;

@protocol ResidentHomeInfoCellDelegate <NSObject>

- (void)residentHomeInfoCellPhoneBtnPressed:(ResidentHomeInfoCell *)cell;

- (void)residentHomeInfoCellJiBtnPressed:(ResidentHomeInfoCell *)cell;

- (void)residentHomeInfoCellFamilyArchivesBtnPressed:(ResidentHomeInfoCell *)cell;

- (void)residentHomeInfoCellHealthArchivesBtnPressed:(ResidentHomeInfoCell *)cell;

@end

@interface ResidentHomeInfoCell : UITableViewCell

@property (nonatomic, copy) NSString * imageDataStr;

@property (nonatomic, strong) PersonColligationModel * model;

@property (nonatomic, weak) id<ResidentHomeInfoCellDelegate> delegate;

@end
