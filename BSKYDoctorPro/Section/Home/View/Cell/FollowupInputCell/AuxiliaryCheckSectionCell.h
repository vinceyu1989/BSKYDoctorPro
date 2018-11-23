//
//  AuxiliaryCheckSectionCell.h
//  BSKYDoctorPro
//
//  Created by 何雷 on 2017/8/29.
//  Copyright © 2017年 ky. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AuxiliaryCheckSectionModel.h"

@class AuxiliaryCheckSectionCell;

@protocol AuxiliaryCheckSectionCellDelegate <NSObject>

- (void)auxiliaryCheckSectionCell:(AuxiliaryCheckSectionCell *)cell select:(BOOL)isSelect;

@end


@interface AuxiliaryCheckSectionCell : UITableViewCell

@property (nonatomic ,strong) AuxiliaryCheckSectionModel *model;

@property (nonatomic ,weak) id<AuxiliaryCheckSectionCellDelegate> delegate;

@property (weak, nonatomic) IBOutlet UIImageView *selectIcon;


@end
