//
//  BSAppVersionRequest.h
//  BSKYDoctorPro
//
//  Created by LinfengYU on 2017/9/22.
//  Copyright © 2017年 ky. All rights reserved.
//

#import <Foundation/Foundation.h>

@class VersionModel;

@interface BSAppVersionRequest : BSBaseRequest

@property (nonatomic ,strong) VersionModel *versionModel;

@property (nonatomic ,assign) BOOL isAudit;   // 是否是审核模式

@end

@interface VersionModel : NSObject
//{"executeTimeMs":2,"data":{"auditStatus":"0","versionDesc":"1.测试审核\r\n2.测试医生端","mandatoryUpdate":"0","downloadUrl":"","versionName":"测试审核版本","versionNum":"V3.2.0","auditStatusNum":"3.2.0"},"code":"200","msg":"获取成功。"}

@property (nonatomic, strong) NSString * auditStatus;
@property (nonatomic, strong) NSString * auditStatusNum;
@property (nonatomic, strong) NSString * downloadUrl;
@property (nonatomic, strong) NSString * mandatoryUpdate;  //是否强制更新,通过该字段判断是否需做更新操作 0不强制更新,1强制更新,9不需更新(即已是最新版)
@property (nonatomic, strong) NSString * versionDesc;
@property (nonatomic, strong) NSString * versionName;
@property (nonatomic, strong) NSString * versionNum;

@end
