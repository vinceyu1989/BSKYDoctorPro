//
//  ArchiveFamilyTableView.h
//  BSKYDoctorPro
//
//  Created by 快医科技 on 2018/1/16.
//  Copyright © 2018年 ky. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ArchiveFamilyDataManager.h"

@interface ArchiveFamilyTableView : UITableView
@property (nonatomic ,strong) ArchiveFamilyDataManager *dataManager;
- (instancetype)initWithFrame:(CGRect)frame style:(UITableViewStyle)style withModel:(ArchiveFamilyDataManager *)model;
@end
