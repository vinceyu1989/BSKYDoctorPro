//
//  IncomeDetailTableViewCell.h
//  BSKYDoctorPro
//
//  Created by kykj on 2018/4/9.
//  Copyright © 2018年 ky. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BSBankIncomeDetailModel.h"

@interface IncomeDetailTableViewCell : UITableViewCell

- (void)updateCellData:(BSBankIncomeDetailModel *)model;

@end
