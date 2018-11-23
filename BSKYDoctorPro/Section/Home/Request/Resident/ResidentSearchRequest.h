//
//  ResidentSearchRequest.h
//  BSKYDoctorPro
//
//  Created by 何雷 on 2018/1/17.
//  Copyright © 2018年 ky. All rights reserved.
//

#import <BSKYCore/BSKYCore.h>
#import "PersonColligationModel.h"

@class ResidentSearchRequestPutModel;

@interface ResidentSearchRequest : BSBaseRequest

@property (nonatomic, strong) ResidentSearchRequestPutModel * putModel;   // 参数

@property (nonatomic, copy) NSArray * dataList;

@end

@interface ResidentSearchRequestPutModel : NSObject

@property (nonatomic, copy) NSString * cmKind;
@property (nonatomic, copy) NSString * gender;
@property (nonatomic, copy) NSString * isFlowing;
@property (nonatomic, copy) NSString * isPoor;
@property (nonatomic, copy) NSString * isStatus;
@property (nonatomic, copy) NSString * itemPerfect;
@property (nonatomic, copy) NSString * keyCode;
@property (nonatomic, copy) NSString * keyValue;
@property (nonatomic, copy) NSString * pageIndex;
@property (nonatomic, copy) NSString * pageSize;
@property (nonatomic, copy) NSString * isSign;

@end


