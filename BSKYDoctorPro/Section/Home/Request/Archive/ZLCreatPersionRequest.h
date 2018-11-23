//
//  ZLCreatPersionRequest.h
//  BSKYDoctorPro
//
//  Created by 快医科技 on 2018/2/28.
//  Copyright © 2018年 ky. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ZLPersonModel.h"

@interface ZLCreatPersionRequest : BSBaseRequest
@property (nonatomic ,strong)NSString *bodyStr;
@property (nonatomic ,strong)NSDictionary *bodyDic;
@property (nonatomic ,strong)NSDictionary *residentForm;
@property (nonatomic ,strong)ZLPersonModel *infoModel;
@end
