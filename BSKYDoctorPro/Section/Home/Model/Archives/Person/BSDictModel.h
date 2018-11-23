//
//  BSDictModel.h
//  BSKYDoctorPro
//
//  Created by 快医科技 on 2018/1/12.
//  Copyright © 2018年 ky. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BSArchiveModel.h"

@interface BSDictModel : NSObject
@property (nonatomic ,copy)NSString *type;
@property (nonatomic ,strong)NSArray *dictList;
@end
