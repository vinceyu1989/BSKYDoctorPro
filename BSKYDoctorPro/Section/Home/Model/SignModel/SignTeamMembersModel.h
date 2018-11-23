//
//  SignTeamMembersModel.h
//  BSKYDoctorPro
//
//  Created by kykj on 2018/1/12.
//  Copyright © 2018年 ky. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SignTeamMembersModel : NSObject

@property (nonatomic, copy) NSString *employeeId; //团队成员ID
@property (nonatomic, copy) NSString *memberName;
@property (nonatomic, copy) NSString *phone;
- (void)decryptModel;
@end
