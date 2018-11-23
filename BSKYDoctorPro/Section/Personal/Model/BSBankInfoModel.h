//
//  BSBankInfoModel.h
//  BSKYDoctorPro
//
//  Created by kykj on 2018/4/11.
//  Copyright © 2018年 ky. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BSBankInfoModel : NSObject

@property (nonatomic, copy) NSString *bankAccount;  //银行卡卡号
@property (nonatomic, copy) NSString *bankBranch;   //银行卡开户支行（payment_virtual_opening_type）
@property (nonatomic, copy) NSString *bankId;       //主键 ,
@property (nonatomic, copy) NSString *bankOwner;    //户名 ,
@property (nonatomic, copy) NSString *userId;       //虚拟账户ID

@end
