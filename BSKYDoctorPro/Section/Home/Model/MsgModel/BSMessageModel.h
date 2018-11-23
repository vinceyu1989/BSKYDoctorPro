//
//  BSMessageModel.h
//  BSKYDoctorPro
//
//  Created by kykj on 2018/4/10.
//  Copyright © 2018年 ky. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BSMessageModel : NSObject

@property (nonatomic, copy) NSString *newsContent; //通知内容
@property (nonatomic, copy) NSString *publishDate; //时间
@property (nonatomic, copy) NSNumber *total;       //未读总数
//通知类型:01009001系统消息，01009002服务消息，01009003订单消息，01009004收入消息
@property (nonatomic, copy) NSString *type;
//消息标题
@property (nonatomic, copy) NSString *newsTitleType;

@end
