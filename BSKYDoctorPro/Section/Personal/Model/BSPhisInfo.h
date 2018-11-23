//
//  BSPhisInfo.h
//  BSKYDoctorPro
//
//  Created by LinfengYU on 2017/9/19.
//  Copyright © 2017年 ky. All rights reserved.
//

#import <Foundation/Foundation.h>

//{"EmployeeID":"DB42E8423067C945A5BE45F5FAEB06C4","OrgId":"AB5EC46E84F34EFD82673A55D0F97972","OrgName":"攀枝花市仁和区布德镇卫生院","OrgType":2,"UserName":"李海阳","RegionCodeList":["510411106","510411107"],"account":"bdzwsylhy"}

@interface BSPhisInfo : NSObject

@property (nonatomic, copy) NSString *EmployeeID;       // 医生对应的公卫id
@property (nonatomic, copy) NSString *OrgId;            // 机构id
@property (nonatomic, copy) NSString *OrgName;          // 机构名称
@property (nonatomic, assign) NSInteger OrgType;        // 机构类型
@property (nonatomic, copy) NSString *UserName;         // 医生名
@property (nonatomic, copy) NSString *account;          // 公卫账号

@end
