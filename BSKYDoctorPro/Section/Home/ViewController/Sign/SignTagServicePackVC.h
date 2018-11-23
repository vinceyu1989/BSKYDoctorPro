//
//  SignTagServicePackVC.h
//  BSKYDoctorPro
//
//  Created by 何雷 on 2018/1/2.
//  Copyright © 2018年 ky. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BSFamilySignInfoModel.h"
#import "BSSignInfoPushRequest.h"
@class SignTagServicePackVC;
typedef void(^SignServiceVCBlock)(SignTagServicePackVC *vc);

@interface SignTagServicePackVC : UIViewController

@property (nonatomic, assign) BSSignType type;
@property (nonatomic, strong) NSString   *code;
@property (nonatomic, strong) NSString   *telPhone;
@property (nonatomic, strong) BSFamilySignInfoModel *paperChechModel;
@property (nonatomic, strong) SignInfoRequestModel  *eleCheckModel;

@property (nonatomic, copy) SignServiceVCBlock block;
@property (nonatomic, strong, readonly) NSMutableArray *selectTagsArray;
@property (nonatomic, strong, readonly) NSMutableArray *selectPackArray;
@property (nonatomic, assign, readonly) CGFloat packsPrice;

@end
