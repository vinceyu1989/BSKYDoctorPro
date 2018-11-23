//
//  AllFormsAddCell.h
//  BSKYDoctorPro
//
//  Created by 快医科技 on 2018/1/4.
//  Copyright © 2018年 ky. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BSArchiveModel.h"

@class AllFormsAddCell;
@protocol AllFormsAddCellDelegate <NSObject>

- (void)allFormsAddCellAddClick:(AllFormsAddCell *)cell;

@end

@interface AllFormsAddCell : UITableViewCell
@property (nonatomic ,strong) BSArchiveModel *model;
@property (nonatomic ,weak) id<AllFormsAddCellDelegate> delegate;
@end

