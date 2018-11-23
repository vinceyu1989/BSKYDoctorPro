//
//  BSBankIncomeDetailRequest.h
//  BSKYDoctorPro
//
//  Created by kykj on 2018/4/12.
//  Copyright © 2018年 ky. All rights reserved.
//

#import <BSKYCore/BSKYCore.h>

@interface BSBankIncomeDetailRequest : BSBaseRequest

@property (nonatomic, copy) NSNumber *pageSize;
@property (nonatomic, copy) NSNumber *pageNo;

@property (nonatomic, strong) NSMutableArray *incomeDetailData;

@end
