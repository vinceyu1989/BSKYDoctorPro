//
//  BSHomeWorkRemindRequest.h
//  BSKYDoctorPro
//
//  Created by vince on 2018/8/16.
//  Copyright © 2018年 ky. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BSHomeWorkRemindRequest : BSBaseRequest
@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *tipsType;
@property (nonatomic, copy) NSString *orgID;
@property (nonatomic, copy) NSString *doctorId;
@property (nonatomic, copy) NSString *pageSize;
@property (nonatomic, copy) NSString *pageIndex;
@property (nonatomic, assign) BOOL remind;
@end
