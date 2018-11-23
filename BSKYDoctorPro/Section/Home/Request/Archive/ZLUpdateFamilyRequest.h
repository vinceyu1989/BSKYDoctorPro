//
//  ZLUpdateFamilyRequest.h
//  BSKYDoctorPro
//
//  Created by 快医科技 on 2018/2/28.
//  Copyright © 2018年 ky. All rights reserved.
//

#import <BSKYCore/BSKYCore.h>

@interface ZLUpdateFamilyRequest : BSBaseRequest
@property (nonatomic ,strong)NSString *bodyStr;
@property (nonatomic ,strong)NSDictionary *bodyDic;
@property (nonatomic ,strong)NSDictionary *updateFamilyArchiveForm;
//@property (nonatomic ,strong)ZLPersonModel *infoModel;
@end
