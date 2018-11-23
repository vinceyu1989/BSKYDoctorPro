//
//  IMDataManager.h
//  BSKYDoctorPro
//
//  Created by 快医科技 on 2018/5/17.
//  Copyright © 2018年 ky. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void(^IMConfigSuccessBlock)();

@interface IMDataManager : NSObject
@property (nonatomic ,strong) NSMutableDictionary *IMSelectOptions;

+ (IMDataManager *)dataManager;
- (void)getLabelOptionDicBlock:(IMConfigSuccessBlock )block;
@end
