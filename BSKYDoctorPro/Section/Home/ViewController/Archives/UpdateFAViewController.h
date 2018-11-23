//
//  UpdateFAViewController.h
//  BSKYDoctorPro
//
//  Created by 快医科技 on 2018/4/3.
//  Copyright © 2018年 ky. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ArchiveFamilyDataManager.h"
#import "ArchiveFamilyTableView.h"
#import "FamilyListModel.h"

typedef void(^UpdateFABlock)(FamilyArchiveModel *arhciveModel);
@interface UpdateFAViewController : UIViewController
@property (nonatomic ,strong) FamilyListModel *listModel;
@property (nonatomic ,strong) ArchiveFamilyDataManager *dataManager;
@property (nonatomic ,strong) ArchiveFamilyTableView *contentTableView;
@property (nonatomic ,strong)FamilyArchiveModel *familyModel;
@property (nonatomic ,strong)FamilyDetailModel *detailModel;
@property (nonatomic ,copy) UpdateFABlock updateBlock;
@end
