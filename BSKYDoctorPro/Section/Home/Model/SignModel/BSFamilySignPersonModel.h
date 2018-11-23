//
//  BSFamilySignPersonModel.h
//  BSKYDoctorPro
//
//  Created by kykj on 2018/4/24.
//  Copyright © 2018年 ky. All rights reserved.
//

#import "BSBaseRequest.h"

@interface BSFamilySignPersonModel : BSBaseRequest

@property (nonatomic, copy) NSString *attachfile;       //合同照片-base64 ,
@property (nonatomic, copy) NSArray  *contractServices; //服务包 ,
@property (nonatomic, copy) NSArray  *tags;             //人群标签
@property (nonatomic, copy) NSString *personId;        //居民在基卫ID ,
@property (nonatomic, copy) NSNumber *fee;              //费用 ,
@property (nonatomic, strong) NSMutableDictionary *contractSmsContent;
- (void)encryptModel;
@end
