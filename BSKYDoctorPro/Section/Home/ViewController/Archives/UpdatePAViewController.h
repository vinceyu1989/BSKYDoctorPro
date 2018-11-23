//
//  UpdatePAViewController.h
//  BSKYDoctorPro
//
//  Created by 快医科技 on 2018/4/3.
//  Copyright © 2018年 ky. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PersonBaseInfoModel.h"
#import "ArchiveBSInfoTableView.h"
#import "ArchivePersonHistoryTableView.h"
#import "ArchivePersonDataManager.h"

typedef void(^UpdatePABlock)(NSString *photo);

@interface UpdatePAViewController : UIViewController
@property (nonatomic ,strong) ArchiveBSInfoTableView *bsTableView;
@property (nonatomic ,strong) ArchivePersonDataManager *dataManager;
@property (nonatomic ,strong) ArchivePersonHistoryTableView *hyTableView;
@property (nonatomic ,strong) PersonBaseInfoModel *personModel;
@property (nonatomic ,copy) UpdatePABlock updateBlock;
@property (nonatomic ,weak) FamilyListModel *listModel;
@property (nonatomic ,copy) NSString *personId;
@end
