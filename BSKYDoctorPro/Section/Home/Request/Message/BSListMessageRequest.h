//
//  BSListMessageRequest.h
//  BSKYDoctorPro
//
//  Created by kykj on 2018/4/10.
//  Copyright © 2018年 ky. All rights reserved.
//

#import <BSKYCore/BSKYCore.h>

@interface BSListMessageRequest : BSBaseRequest

@property (nonatomic, copy) NSString *type;//消息类型
@property (nonatomic, copy) NSNumber *pageSize;
@property (nonatomic, copy) NSNumber *pageNo;

@property (nonatomic, strong) NSMutableArray *msgListData;

@end
