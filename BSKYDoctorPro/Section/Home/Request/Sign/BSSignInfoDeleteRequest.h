//
//  BSSignInfoDeleteRequest.h
//  BSKYDoctorPro
//
//  Created by kykj on 2018/1/12.
//  Copyright © 2018年 ky. All rights reserved.
//

#import <BSKYCore/BSKYCore.h>

@interface BSSignInfoDeleteRequest : BSBaseRequest

@property (nonatomic, copy) NSString *signIds; //待删除的签约数据ids，由','分割

@end
