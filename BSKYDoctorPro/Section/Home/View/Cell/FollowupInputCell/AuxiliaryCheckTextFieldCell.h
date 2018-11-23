//
//  AuxiliaryCheckTextFieldCell.h
//  BSKYDoctorPro
//
//  Created by 何雷 on 2017/8/29.
//  Copyright © 2017年 ky. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AuxiliaryCheckSectionModel.h"
#import "FollowupUpModel.h"

@class AuxiliaryCheckTextFieldCell;

@protocol AuxiliaryCheckTextFieldCellDelegate <NSObject>

- (void)auxiliaryCheckTextFieldCell:(AuxiliaryCheckTextFieldCell *)cell inputString:(NSString *)string;

@end

@interface AuxiliaryCheckTextFieldCell : UITableViewCell

@property (nonatomic ,strong) FollowupUpModel *upModel;

@property (nonatomic ,strong) AuxiliaryCheckRowModel *rowModel;

@property (nonatomic ,weak) id<AuxiliaryCheckTextFieldCellDelegate> delegate;




@end
