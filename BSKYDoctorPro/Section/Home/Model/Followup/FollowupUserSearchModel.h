//
//  FollowupUserSearchModel.h
//  BSKYDoctorPro
//
//  Created by 何雷 on 2017/9/13.
//  Copyright © 2017年 ky. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FollowupUserSearchModel : NSObject

@property (nonatomic, copy) NSString * age;
@property (nonatomic, copy) NSString * currentAddress;
@property (nonatomic, copy) NSString * idField;
@property (nonatomic, copy) NSString * idCard;
@property (nonatomic, copy) NSString * name;
@property (nonatomic, copy) NSString * sex;
@property (nonatomic, copy) NSString * tel;
- (void)decryptModel;
@end
