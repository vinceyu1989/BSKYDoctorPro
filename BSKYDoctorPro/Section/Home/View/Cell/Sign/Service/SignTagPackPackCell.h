//
//  SignTagPackPackCell.h
//  BSKYDoctorPro
//
//  Created by 何雷 on 2018/1/2.
//  Copyright © 2018年 ky. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SignSVPackModel.h"

typedef void(^SignTagPackPackCellBlock)(SignSVPackModel *model);
@interface SignTagPackPackCell : UITableViewCell

@property (nonatomic, copy) SignTagPackPackCellBlock packBlock;
@property (nonatomic, strong) SignSVPackModel *model;
@property (nonatomic, assign) BOOL isSelect;

@end
