//
//  SignSVPackModel.h
//  BSKYDoctorPro
//
//  Created by kykj on 2018/1/13.
//  Copyright © 2018年 ky. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SignSVPackModel : NSObject

@property (nonatomic, copy) NSString *appObject; 
@property (nonatomic, copy) NSString *fee;          //价格 ,
@property (nonatomic, copy) NSString *lev;          //等级：1、机构级 2、县级 ,
@property (nonatomic, copy) NSString *remark;       //备注 ,
@property (nonatomic, copy) NSString *serviceId;    //服务包id ,
@property (nonatomic, copy) NSString *serviceName;  //服务包名称

@end
