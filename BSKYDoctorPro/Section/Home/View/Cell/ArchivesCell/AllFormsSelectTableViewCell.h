//
//  AllFormsSelectTableViewCell.h
//  BSKYDoctorPro
//
//  Created by 快医科技 on 2018/1/3.
//  Copyright © 2018年 ky. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BSArchiveModel.h"
#import "FollowupUpModel.h"
#import "AllFormsSelectTableViewCell.h"

typedef void(^reloadCellLayout)(UITableViewCell *cell);

@interface AllFormsSelectTableViewCell : UITableViewCell
@property (nonatomic ,strong) BSArchiveModel *model;
@property (nonatomic ,copy) reloadCellLayout reloadLayout;
@property (nonatomic ,assign) BOOL isCollapsible; //textView 是否可收缩
@property (nonatomic ,assign) CGFloat cellWidth;
@end
