//
//  NTEResidentManageVC.h
//  BSKYDoctorPro
//
//  Created by vince on 2018/11/13.
//  Copyright © 2018年 ky. All rights reserved.
//

#import "ResidentManageVC.h"
#import "PersonColligationModel.h"

NS_ASSUME_NONNULL_BEGIN

typedef void(^NIMResidentSelectBlock)(PersonColligationModel *model);

@interface NTEResidentManageVC : ResidentManageVC
@property (nonatomic ,copy) NIMResidentSelectBlock selectBlock;
@end

NS_ASSUME_NONNULL_END
