//
//  SignFamilyPersonShowCell.h
//  BSKYDoctorPro
//
//  Created by kykj on 2018/1/4.
//  Copyright © 2018年 ky. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SignFamilyMembersModel.h"

@protocol FamilyPersonShowCellDelegate;

@interface SignFamilyPersonShowCell : UITableViewCell

@property (nonatomic, strong) SignFamilyMembersModel *model;
@property (nonatomic, weak) id<FamilyPersonShowCellDelegate> delegate;
- (void)setCellDataWithHead:(BOOL)isHead selectEnable:(BOOL)enable;
- (void)setIsSelected:(BOOL)selected;
- (void)setFileTypeWithText:(NSString *)text;

@end

@protocol FamilyPersonShowCellDelegate <NSObject>

@optional
- (void)isChooseShowCell:(SignFamilyPersonShowCell *)cell;

@end
