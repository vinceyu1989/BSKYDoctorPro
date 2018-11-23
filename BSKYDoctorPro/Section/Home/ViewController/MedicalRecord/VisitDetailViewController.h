//
//  VisitDetailViewController.h
//  BSKYDoctorPro
//
//  Created by vince on 2018/9/5.
//  Copyright © 2018年 ky. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "VisitListModel.h"

@interface VisitDetailViewController : UIViewController<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic ,strong) VisitListModel *model;
@end
