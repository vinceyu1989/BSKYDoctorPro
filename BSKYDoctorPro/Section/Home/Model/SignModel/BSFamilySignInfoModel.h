//
//  BSFamilySignInfoModel.h
//  BSKYDoctorPro
//
//  Created by kykj on 2018/4/24.
//  Copyright © 2018年 ky. All rights reserved.
//

#import "BSBaseRequest.h"

@interface BSFamilySignInfoModel : BSBaseRequest

@property (nonatomic, copy) NSString *teamID;
@property (nonatomic, copy) NSString *channel;          //签约渠道
@property (nonatomic, copy) NSString *teamEmpId;        //签团队成员ID-经办人ID
@property (nonatomic, copy) NSString *signPerson;       //签约代表-姓名
@property (nonatomic, copy) NSArray  *list;             //签约信息
@property (nonatomic, copy) NSString *startTime;          //开始时间yyyy-MM-dd
@property (nonatomic, copy) NSString *endTime;            //结束时间
@property (nonatomic, copy) NSString *otheremark;         //remark
@property (nonatomic, copy) NSString *ID;
- (void)encryptModel;
@end
