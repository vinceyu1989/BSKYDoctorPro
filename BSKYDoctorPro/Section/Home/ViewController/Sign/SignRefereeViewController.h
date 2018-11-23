//
//  SignRefereeViewController.h
//  BSKYDoctorPro
//
//  Created by kykj on 2018/1/3.
//  Copyright © 2018年 ky. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BSFamilySignInfoModel.h"
#import "BSSignInfoPushRequest.h"
@class SignRefereeViewController;
typedef void(^SignRefereeVCBlock)(SignRefereeViewController *vc,id content,id other);

@interface SignRefereeViewController : UIViewController

@property (nonatomic, copy) SignRefereeVCBlock block;
@property (nonatomic, assign) BSSignType type;
@property (nonatomic, strong) NSString *masterName;
@property (nonatomic, strong) NSMutableArray *personCode;
@property (nonatomic, strong) BSFamilySignInfoModel *paperCheckPacksModel;
@property (nonatomic, strong) SignInfoRequestModel  *eleCheckPacksModel;

@end

