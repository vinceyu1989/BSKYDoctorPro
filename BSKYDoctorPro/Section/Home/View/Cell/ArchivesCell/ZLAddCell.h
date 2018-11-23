//
//  AddCell.h
//  BSKYDoctorPro
//
//  Created by 快医科技 on 2018/1/5.
//  Copyright © 2018年 ky. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BSArchiveModel.h"

@class ZLAddCell;
@protocol ZLAddCellDelegate <NSObject>
- (void)delectAction:(UITableViewCell *)cell;
@end

@interface ZLAddCell : UITableViewCell
@property (nonatomic ,strong) BSArchiveModel *model;
@property (nonatomic ,weak) id<ZLAddCellDelegate> delegate;
@property (weak, nonatomic) IBOutlet UIButton *deleteBtn;
@end
