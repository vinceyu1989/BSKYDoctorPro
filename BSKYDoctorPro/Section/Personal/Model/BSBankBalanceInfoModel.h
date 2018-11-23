//
//  BSBankBalanceInfoModel.h
//  BSKYDoctorPro
//
//  Created by kykj on 2018/4/12.
//  Copyright © 2018年 ky. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BSBankBalanceInfoModel : NSObject

@property (nonatomic, copy) NSNumber *tradeAmount;    // 收益金额
@property (nonatomic, copy) NSNumber *virtualBalance; // 账户余额

@end
