//
//  BSServiceLog.h
//  BSKYDoctorPro
//
//  Created by LinfengYU on 2017/9/22.
//  Copyright © 2017年 ky. All rights reserved.
//

#import <Foundation/Foundation.h>

//{
//    doctorId = 120;
//    personAge = "25\U5c81";
//    personName = "\U674e\U96ea\U5a07";
//    personSex = 2;
//    serviceLogDate = "2017-09-20";
//    serviceLogID = 4;
//    serviceType = 01008002;
//}

@interface BSServiceLog : NSObject

@property (nonatomic, assign) NSInteger doctorId;
@property (nonatomic, copy) NSString *personAge;
@property (nonatomic, copy) NSString *personName;
@property (nonatomic, copy) NSString *serviceLogDate;
@property (nonatomic, assign) NSInteger personSex;
@property (nonatomic, assign) NSInteger serviceLogID;
@property (nonatomic, copy) NSString *serviceType;

#pragma mark -

@property (nonatomic, copy) NSString *serviceTypeWkt;

@end
