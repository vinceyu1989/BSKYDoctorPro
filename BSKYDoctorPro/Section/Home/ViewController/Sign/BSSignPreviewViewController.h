//
//  BSSignPreviewViewController.h
//  BSKYDoctorPro
//
//  Created by kykj on 2017/12/28.
//  Copyright © 2017年 ky. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BSSignInfoPushRequest.h"
@class BSSignPreviewViewController;
typedef void(^SignDeleteBlock)(BSSignPreviewViewController *vc);
@interface BSSignPreviewViewController : UIViewController

@property (nonatomic, strong) SignInfoRequestModel   *pushInfoModel;
@property (nonatomic, strong) SignInfoRespondseModel *pushResponseModel;
@property (nonatomic, copy) SignDeleteBlock deleteBlock;
@property (nonatomic, assign, readonly) BOOL isPopGesture;
- (void)setTeamNameWithName:(NSString *)teamName TeamEmpName:(NSString *)teamEmpName;

@end
