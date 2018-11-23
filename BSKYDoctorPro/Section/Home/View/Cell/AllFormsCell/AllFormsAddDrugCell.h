//
//  AllFormsAddDrugCell.h
//  BSKYDoctorPro
//
//  Created by 何雷 on 2017/11/28.
//  Copyright © 2017年 ky. All rights reserved.
//

#import <UIKit/UIKit.h>

@class AllFormsAddDrugCell;

@protocol AllFormsAddDrugCellDelegate <NSObject>

- (void)allFormsAddDrugCellAddClick:(AllFormsAddDrugCell *)cell;

@end

@interface AllFormsAddDrugCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

@property (nonatomic ,weak) id<AllFormsAddDrugCellDelegate> delegate;

@end
