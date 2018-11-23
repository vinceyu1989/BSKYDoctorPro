//
//  CreatFAViewController.h
//  BSKYDoctorPro
//
//  Created by 快医科技 on 2017/12/29.
//  Copyright © 2017年 ky. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ArchiveFamilyDataManager.h"
#import "ArchiveFamilyTableView.h"


@interface CreatFAViewController : UIViewController
@property (nonatomic ,strong) ArchiveFamilyDataManager *dataManager;
@property (nonatomic ,strong) ArchiveFamilyTableView *contentTableView;
@end
