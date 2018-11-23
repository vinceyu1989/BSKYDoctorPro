//
//  VisitListModel.h
//  BSKYDoctorPro
//
//  Created by vince on 2018/9/5.
//  Copyright © 2018年 ky. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface VisitListModel : NSObject
@property (nonatomic ,copy) NSString *assessment;
@property (nonatomic ,copy) NSString *createTime;
@property (nonatomic ,copy) NSString *doctorId;
@property (nonatomic ,copy) NSString *doctorName;
@property (nonatomic ,copy) NSString *listId;
@property (nonatomic ,copy) NSString *name;
@property (nonatomic ,copy) NSString *orgName;
@property (nonatomic ,copy) NSString *personId;
@property (nonatomic ,copy) NSString *rn;
- (void)decryptModel;
@end
