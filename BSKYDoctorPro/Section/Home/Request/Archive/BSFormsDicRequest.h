//
//  BSFormsDicRequest.h
//  BSKYDoctorPro
//
//  Created by 快医科技 on 2018/1/9.
//  Copyright © 2018年 ky. All rights reserved.
//

#import <BSKYCore/BSKYCore.h>

@interface BSFormsDicRequest : BSBaseRequest
@property (nonatomic ,strong) NSArray *dictTypes;
@property (nonatomic ,strong) NSArray *dictArray;
@end
