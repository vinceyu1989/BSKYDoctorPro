//
//  BSBankIncomeDetailModel.h
//  BSKYDoctorPro
//
//  Created by kykj on 2018/4/12.
//  Copyright © 2018年 ky. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BSBankIncomeDetailModel : NSObject

@property (nonatomic, copy) NSNumber *tradeAmount;  //交易金额
@property (nonatomic, copy) NSNumber *tradeBalance; //交易后余额
@property (nonatomic, copy) NSString *tradeDate;    //交易时间
@property (nonatomic, copy) NSString *tradeDirection;//交易方向payment_trade_direction
@property (nonatomic, copy) NSString *tradeType;    //交易类型payment_trade_type）

@end
