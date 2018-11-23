//
//  CreatPAViewController.h
//  BSKYDoctorPro
//
//  Created by 快医科技 on 2017/12/29.
//  Copyright © 2017年 ky. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ArchivePersonDataManager.h"
#import "BSArchiveModel.h"
#import "AllFormsSectionCell.h"
#import "AllFormsSelectTableViewCell.h"
#import "AllFormsSelectOnlineCell.h"
#import "ArchiveBSInfoTableView.h"
#import "ArchivePersonHistoryTableView.h"
#import "FamilyListModel.h"
#import "FamilyArchiveModel.h"
#import "PersonBaseInfoModel.h"
#import "ZLPersonModel.h"

@interface CreatPAViewController : UIViewController
@property (nonatomic ,strong) FamilyListModel *familyModel;
@property (nonatomic ,strong) FamilyArchiveModel *archiveFamilyModel;
@property (nonatomic ,strong) ArchiveBSInfoTableView *bsTableView;
@property (nonatomic ,strong) ArchivePersonDataManager *dataManager;
@property (nonatomic ,strong) ArchivePersonHistoryTableView *hyTableView;
@property (nonatomic ,strong) PersonBaseInfoModel *personModel;
@property (nonatomic ,strong) ZLPersonModel *zlPersonModel;
@end
