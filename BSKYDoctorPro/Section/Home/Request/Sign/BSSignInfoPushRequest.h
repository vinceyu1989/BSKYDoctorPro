//
//  BSSignInfoPushRequest.h
//  BSKYDoctorPro
//
//  Created by kykj on 2018/1/12.
//  Copyright © 2018年 ky. All rights reserved.
//

#import <BSKYCore/BSKYCore.h>
@class SignInfoRespondseModel;
@interface BSSignInfoPushRequest : BSBaseRequest

@property (nonatomic, copy) NSDictionary *signForm;

@property (nonatomic, strong) NSMutableArray *respondseModelArr;

@end

@interface SignInfoRequestModel: NSObject

@property (nonatomic, copy) NSString *teamId;
@property (nonatomic, copy) NSString *channel;          //签约渠道
@property (nonatomic, copy) NSString *teamEmpId;        //签团队成员ID-经办人ID
@property (nonatomic, copy) NSArray  *teamEmpNames;     //团队成员姓名-Array[string]
@property (nonatomic, copy) NSString *signPerson;       //签约代表-姓名
@property (nonatomic, copy) NSArray  *signPersonList;   //签约人列表-每一个居民信息
@property (nonatomic, copy) NSString *startTime;          //开始时间yyyy-MM-dd
@property (nonatomic, copy) NSString *endTime;            //结束时间
@property (nonatomic, copy) NSString *remark;             //remark
@property (nonatomic, copy) NSString *personSignBase64;   //居民签名

@end

@interface SignInfoRespondseModel: NSObject

@property (nonatomic, copy) NSNumber *signId;//保存的签约记录主键-需删除时传入该值 ,
@property (nonatomic, copy) NSString *uniqueId;//同步CA后返回的uniqueId，用于医生(批量)签名
- (void)decryptModel;
@end



