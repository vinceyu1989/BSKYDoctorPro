//
//  ZLDiseaseRequest.h
//  BSKYDoctorPro
//
//  Created by 快医科技 on 2018/3/5.
//  Copyright © 2018年 ky. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ZLDiseaseRequest : BSBaseRequest
@property (nonatomic ,strong)NSString * searchKey;
@property (nonatomic ,strong)NSArray *dataArray;
@property (nonatomic ,assign)NSUInteger pageSize;
@property (nonatomic ,assign)NSUInteger pageIndex;
@end
