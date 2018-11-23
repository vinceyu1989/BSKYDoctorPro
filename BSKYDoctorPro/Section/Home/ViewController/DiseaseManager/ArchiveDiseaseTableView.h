//
//  ArchiveDiseaseTableView.h
//  BSKYDoctorPro
//
//  Created by vince on 2018/10/23.
//  Copyright © 2018年 ky. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ArchiveDiseaseDataManager.h"

@interface ArchiveDiseaseTableView : UITableView
@property (nonatomic ,strong) ArchiveDiseaseDataManager *dataManager;
- (instancetype)initWithFrame:(CGRect)frame style:(UITableViewStyle)style withModel:(ArchiveDiseaseDataManager *)model;
@end
