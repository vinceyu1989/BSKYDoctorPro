//
//  SignSVPackContentModel.h
//  BSKYDoctorPro
//
//  Created by kykj on 2018/1/22.
//  Copyright © 2018年 ky. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SignSVPackContentModel : NSObject

@property (nonatomic, copy) NSString *freCompare; //比较
@property (nonatomic, copy) NSNumber *freNum;     //次数
@property (nonatomic, copy) NSString *name;       //服务包名称
@property (nonatomic, copy) NSString *remark;     //备注
@property (nonatomic, copy) NSString *servicePackId; //服务包id

@end
