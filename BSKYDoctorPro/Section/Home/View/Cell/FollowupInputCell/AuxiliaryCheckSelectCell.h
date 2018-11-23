//
//  AuxiliaryCheckSelectCell.h
//  BSKYDoctorPro
//
//  Created by 何雷 on 2017/8/30.
//  Copyright © 2017年 ky. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AuxiliaryCheckSectionModel.h"
#import "FollowupUpModel.h"

@class AuxiliaryCheckSelectCell;

@protocol AuxiliaryCheckSelectCellDelegate <NSObject>

- (void)auxiliaryCheckSelectCell:(AuxiliaryCheckSelectCell *)cell selectIndex:(NSInteger)index;

@end

@interface AuxiliaryCheckSelectCell : UITableViewCell

@property (nonatomic ,strong) FollowupUpModel *upModel;

@property (nonatomic ,strong) AuxiliaryCheckSectionModel *model;

@property (nonatomic ,weak) id<AuxiliaryCheckSelectCellDelegate> delegate;

@end
