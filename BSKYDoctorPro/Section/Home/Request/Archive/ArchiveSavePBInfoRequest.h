//
//  ArchiveSavePBInfoRequest.h
//  BSKYDoctorPro
//
//  Created by 快医科技 on 2018/1/11.
//  Copyright © 2018年 ky. All rights reserved.
//

#import <BSKYCore/BSKYCore.h>
#import "PersonBaseInfoModel.h"

@interface ArchiveSavePBInfoRequest : BSBaseRequest
@property (nonatomic ,strong)NSString *bodyStr;
@property (nonatomic ,strong)NSDictionary *bodyDic;
@property (nonatomic ,strong)NSDictionary *residentInVM;
@property (nonatomic ,strong)PersonBaseInfoModel *infoModel;
@end
