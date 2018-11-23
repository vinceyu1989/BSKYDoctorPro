//
//  ResidentFilterCell.h
//  BSKYDoctorPro
//
//  Created by 何雷 on 2018/1/16.
//  Copyright © 2018年 ky. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ResidentFilterCell : UICollectionViewCell

@property (nonatomic, assign) BOOL isSelected;

@property (weak, nonatomic) IBOutlet UILabel *contentLabel;

@end
