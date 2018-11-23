//
//  DivisionCodeModel.h
//  BSKYDoctorPro
//
//  Created by kykj on 2017/11/30.
//  Copyright © 2017年 ky. All rights reserved.
//

#import <BSKYCore/BSKYCore.h>

@interface DivisionCodeModel : BSBaseRequest

@property (nonatomic, copy) NSString *divisionName;
@property (nonatomic, copy) NSString *divisionId;
@property (nonatomic, copy) NSString *divisionFullName;
@property (nonatomic, copy) NSString *divisionCode;

@property (nonatomic, strong) NSMutableArray *children;

@end
