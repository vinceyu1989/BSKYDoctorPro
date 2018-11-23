//
//  ZLPersonTableView.h
//  BSKYDoctorPro
//
//  Created by 快医科技 on 2018/3/1.
//  Copyright © 2018年 ky. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ArchivePersonDataManager.h"

typedef void(^ScrollTableBlock)(NSUInteger index);

@interface ZLPersonTableView : UITableView
@property (nonatomic ,strong) ArchivePersonDataManager *dataManager;
@property (nonatomic ,copy) ScrollTableBlock scrollBlock;
- (instancetype)initWithFrame:(CGRect)frame style:(UITableViewStyle)style withModel:(ArchivePersonDataManager *)model;
@end

