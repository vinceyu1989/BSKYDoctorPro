//
//  ZLMemberListRequest.h
//  BSKYDoctorPro
//
//  Created by 快医科技 on 2018/2/28.
//  Copyright © 2018年 ky. All rights reserved.
//

#import <BSKYCore/BSKYCore.h>

@interface ZLMemberListRequest : BSBaseRequest
@property (nonatomic ,strong)NSString *familyID;
@property (nonatomic ,strong)NSArray *dataArray;
@end
