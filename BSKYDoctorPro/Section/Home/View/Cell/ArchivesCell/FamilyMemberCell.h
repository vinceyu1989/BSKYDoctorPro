//
//  FamilyMemberCell.h
//  BSKYDoctorPro
//
//  Created by 快医科技 on 2018/1/18.
//  Copyright © 2018年 ky. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FamilyListModel.h"


@interface FamilyMemberCell : UITableViewCell
@property (nonatomic ,strong) FamilyMemberListModel *model;
@property (nonatomic ,weak) FamilyListModel *listModel;
@end
