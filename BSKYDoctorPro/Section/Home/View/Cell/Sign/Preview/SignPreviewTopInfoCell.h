//
//  SignPreviewTopInfoCell.h
//  BSKYDoctorPro
//
//  Created by kykj on 2018/1/3.
//  Copyright © 2018年 ky. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BSSignInfoPushRequest.h"

@interface SignPreviewTopInfoCell : UITableViewCell

@property (nonatomic, strong) SignInfoRequestModel *model;
- (void)setTeamName:(NSString *)teamName TeamEmpName:(NSString *)teamEmpName;

@end
