//
//  ArchiveUpdatePBinfoRequest.h
//  BSKYDoctorPro
//
//  Created by 快医科技 on 2018/1/25.
//  Copyright © 2018年 ky. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PersonBaseInfoModel.h"

@interface ArchiveUpdatePBinfoRequest : BSBaseRequest
@property (nonatomic ,strong)NSDictionary *residentInVM;
@property (nonatomic ,strong)PersonBaseInfoModel *infoModel;
@end
