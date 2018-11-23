//
//  ResidentFilterView.h
//  BSKYDoctorPro
//
//  Created by 何雷 on 2018/1/16.
//  Copyright © 2018年 ky. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ResidentSearchRequest.h"

@interface ResidentFilterView : UIView

@property (nonatomic, strong) ResidentSearchRequestPutModel * putModel;

@property (nonatomic ,copy) void (^selectedComplete)(void);

- (void)show;

- (void)resetBtnPressed:(UIButton *)sender;  // 置空

@end
