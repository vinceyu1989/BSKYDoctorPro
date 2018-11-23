//
//  ResidentRefreshCell.h
//  BSKYDoctorPro
//
//  Created by 何雷 on 2018/1/20.
//  Copyright © 2018年 ky. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ResidentRefreshView.h"
#import "UIButton+BSKY.h"

@interface ResidentRefreshCell : UITableViewCell

@property (nonatomic, strong) ResidentRefreshView * refreshView;

@property (nonatomic, assign) ResidentRefreshStatus refreshStatus;

@end
