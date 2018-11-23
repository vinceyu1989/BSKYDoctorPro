//
//  ArchivePickerTableViewCell.h
//  BSKYDoctorPro
//
//  Created by 快医科技 on 2018/1/2.
//  Copyright © 2018年 ky. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BSTextField.h"
#import "BSArchiveModel.h"
#import "FollowupUpModel.h"
#import "FollowupDoctorModel.h"

typedef  void(^ArchiveEndEditBlock)(id model);


@protocol ZLArchivePickerTableViewCellDelegate <NSObject>
- (void)pickAction:(id )model;
@end

@interface ZLArchivePickerTableViewCell : UITableViewCell
@property (nonatomic ,strong)BSArchiveModel *model;
@property (nonatomic ,weak) id<ZLArchivePickerTableViewCellDelegate> delegate;
@property (nonatomic ,copy) ArchiveEndEditBlock endBlock;
@end
