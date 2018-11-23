//
//  BSTypeDictionaryRequest.h
//  BSKYDoctorPro
//
//  Created by kykj on 2018/1/12.
//  Copyright © 2018年 ky. All rights reserved.
//

#import <BSKYCore/BSKYCore.h>

@interface BSTypeDictionaryRequest : BSBaseRequest

@property (nonatomic, copy) NSString *dictTypes;

@property (nonatomic, strong) NSMutableArray *dictTypesData;

@end
