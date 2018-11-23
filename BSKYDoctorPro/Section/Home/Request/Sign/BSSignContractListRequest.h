//
//  BSSignContractListRequest.h
//  BSKYDoctorPro
//
//  Created by 何雷 on 2018/4/10.
//  Copyright © 2018年 ky. All rights reserved.
//

#import <BSKYCore/BSKYCore.h>

@interface BSSignContractListRequest : BSBaseRequest

@property (nonatomic, copy) NSString *cardIdOrName;     //居民身份证号或姓名
@property (nonatomic, copy) NSString *teamId;
@property (nonatomic, copy) NSString *status;           //签约状态（1.待审 2.已通过 3.未通过 4.服务到期 5.解约 6.续约）
@property (nonatomic, copy) NSString *doctorId;         //经办人(医生)在公卫的ID值
@property (nonatomic, copy) NSNumber *pageSize;
@property (nonatomic, copy) NSNumber *pageIndex;
@property (nonatomic, copy) NSNumber *ignoreType;

@property (nonatomic, strong) NSMutableArray *dataList;

@property (nonatomic, assign) ResidentRefreshStatus refreshStatus;  // 刷新状态

@end

@interface SignContractModel : NSObject

@property (nonatomic, copy) NSString * address;
@property (nonatomic, copy) NSString * age;
@property (nonatomic, copy) NSString * attachfile;
@property (nonatomic, copy) NSString * cardId;
@property (nonatomic, copy) NSString * channel;
@property (nonatomic, copy) NSString * contractId;
@property (nonatomic, copy) NSString * endTime;
@property (nonatomic, copy) NSString * gender;
@property (nonatomic, copy) NSString * otherRemark;
@property (nonatomic, copy) NSString * personName;
@property (nonatomic, copy) NSString * startTime;
@property (nonatomic, copy) NSString * tags;
@property (nonatomic, copy) NSString * teamName;    // 签约团队
@property (nonatomic, copy) NSString * signPerson;  // 签约代表
@property (nonatomic, copy) NSString * createEmp;   // 经办人
- (void)decryptModel;
@end
