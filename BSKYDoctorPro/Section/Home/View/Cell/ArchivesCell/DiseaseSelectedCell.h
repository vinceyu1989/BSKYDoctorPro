//
//  DiseaseSelectedCell.h
//  BSKYDoctorPro
//
//  Created by 快医科技 on 2018/3/5.
//  Copyright © 2018年 ky. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZLDiseaseModel.h"

typedef void(^DeleteBlock)(ZLDiseaseModel *model);

@interface DiseaseSelectedCell : UICollectionViewCell
@property (nonatomic ,strong)ZLDiseaseModel *model;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UIView *lineView;
@property (weak, nonatomic) IBOutlet UIButton *deleteBtn;
@property (nonatomic ,copy) DeleteBlock deleteBlock;
@end
