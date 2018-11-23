//
//  ArchivePersonHistoryTableView.h
//  BSKYDoctorPro
//
//  Created by 快医科技 on 2018/1/4.
//  Copyright © 2018年 ky. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ArchivePersonDataManager.h"
#import "AllFormsAddCell.h"

@interface ArchivePersonHistoryTableView : UITableView
@property (nonatomic ,strong) ArchivePersonDataManager *dataManager;
- (instancetype)initWithFrame:(CGRect)frame style:(UITableViewStyle)style withModel:(ArchivePersonDataManager *)model;
@end
