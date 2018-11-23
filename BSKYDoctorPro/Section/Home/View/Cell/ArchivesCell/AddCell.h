//
//  AddCell.h
//  BSKYDoctorPro
//
//  Created by 快医科技 on 2018/1/5.
//  Copyright © 2018年 ky. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BSArchiveModel.h"

@interface AddCell : UITableViewCell
@property (nonatomic ,strong) BSArchiveModel *model;
@property (weak, nonatomic) IBOutlet UIButton *deleteBtn;
@end
