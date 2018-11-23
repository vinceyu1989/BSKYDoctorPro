//
//  BSVerifyStatusRequest.h
//  BSKYDoctorPro
//
//  Created by LinfengYU on 2017/9/22.
//  Copyright © 2017年 ky. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BSVerifyStatusRequest : BSBaseRequest

@property (nonatomic, assign) PhisVerifyStatus verifyStatus;

@property (nonatomic, copy) NSString *verifyMessage;

@end
