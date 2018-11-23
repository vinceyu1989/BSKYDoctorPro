//
//  BSGetFriendsListRequest.h
//  BSKYDoctorPro
//
//  Created by kykj on 2018/5/17.
//  Copyright © 2018年 ky. All rights reserved.
//

#import "BSBaseRequest.h"

@interface BSGetFriendsListRequest : BSBaseRequest

@property (nonatomic, copy) NSString *codeStr;
@property (nonatomic, copy) NSString *pageSize;
@property (nonatomic, copy) NSString *pageNo;

@property (nonatomic, strong) NSMutableArray *searchData;

@end
