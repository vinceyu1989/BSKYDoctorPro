//
//  IMDetailController.h
//  BSKYDoctorPro
//
//  Created by 快医科技 on 2018/5/15.
//  Copyright © 2018年 ky. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <NIMSDK/NIMSDK.h>
#import "IMFriendInfoModel.h"

@protocol IMDetailControllerDelegate<NSObject>
- (void)delectFriendSuccess:(NIMUser *)user;
- (void)addFriendSuccess:(NIMUser *)user;
@end

typedef enum : NSUInteger {
    IMDetailTypeDetail = 0,
    IMDetailTypeAdd    = 1,
} IMDetailType;

typedef enum : NSUInteger {
    IMDetailAccountTypeDoctor   = 0,
    IMDetailAccountTypePatient  = 1,
} IMDetailAccountType;

typedef void(^UpdateSuccessBlock)(void);

@interface IMDetailController : UIViewController
@property (nonatomic ,weak) id<IMDetailControllerDelegate> delegate;
- (instancetype)initWithUser:(NSString *)userId;
@property (nonatomic ,strong) IMFriendInfoModel *friendUser;
@end

