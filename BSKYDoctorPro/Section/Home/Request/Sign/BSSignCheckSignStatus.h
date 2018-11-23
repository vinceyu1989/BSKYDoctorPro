//
//  BSSignCheckSignStatus.h
//  BSKYDoctorPro
//
//  Created by kykj on 2018/1/18.
//  Copyright © 2018年 ky. All rights reserved.
//

#import <BSKYCore/BSKYCore.h>

@interface BSSignCheckSignStatus : BSBaseRequest

@property (nonatomic, copy) NSString *cardIds;     //居民身份证号或姓名
@property (nonatomic, copy) NSString *doctorId;   //经办人(医生)在公卫的ID值
@property (nonatomic, copy) NSNumber *pageSize;
@property (nonatomic, copy) NSNumber *pageIndex;

@property (nonatomic, strong) NSMutableArray *signStatusArr;

@end

@interface SignCheckSignStatusRespondse : NSObject

@property (nonatomic, copy) NSString *personName;
@property (nonatomic, copy) NSString *cardId;
@property (nonatomic, copy) NSNumber *hasSigned;
- (void)decryptModel;
@end
