//
//  DiseaseCell.h
//  BSKYDoctorPro
//
//  Created by 快医科技 on 2018/3/5.
//  Copyright © 2018年 ky. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZLDiseaseModel.h"

@interface DiseaseCell : UITableViewCell
@property (nonatomic ,strong)ZLDiseaseModel *model;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *codeLabel;
@end
