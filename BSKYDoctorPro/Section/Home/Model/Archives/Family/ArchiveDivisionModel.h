//
//  ArchiveDivisionModel.h
//  BSKYDoctorPro
//
//  Created by 快医科技 on 2018/1/17.
//  Copyright © 2018年 ky. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ArchiveDivisionModel : NSObject
@property (nonatomic, copy) NSString *divisionName;
@property (nonatomic, copy) NSString *divisionId;
@property (nonatomic, copy) NSString *divisionFullName;
@property (nonatomic, copy) NSString *divisionCode;

@property (nonatomic, strong) NSMutableArray *children;
@end
