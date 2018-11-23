//
//  InStationMessageViewController.h
//  BSKYDoctorPro
//
//  Created by kykj on 2018/4/8.
//  Copyright © 2018年 ky. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BSMessageModel.h"

typedef void(^InStationMsgBlock)(NSInteger msgNum);

@interface BSInStationMsgViewController : UIViewController
@property (nonatomic, copy) InStationMsgBlock block;
@end
