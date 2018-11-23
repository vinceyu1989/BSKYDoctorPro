//
//  BSZhiQuRequest.h
//  BSKYDoctorPro
//
//  Created by LinfengYU on 2017/8/30.
//  Copyright © 2017年 ky. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BSH5UrlRequest : BSBaseRequest

@property (nonatomic, assign) BOOL needToken;

@property (nonatomic, copy) NSString *type;

@property (nonatomic, copy) NSString * otherParam;

@property (nonatomic, copy) NSString *urlString;    // 返回的url地址

@end
