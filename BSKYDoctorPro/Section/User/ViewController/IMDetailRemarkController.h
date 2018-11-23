//
//  IMDetailRemarkController.h
//  BSKYDoctorPro
//
//  Created by 快医科技 on 2018/5/18.
//  Copyright © 2018年 ky. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^SaveBlock)(NSString *remark);

@interface IMDetailRemarkController : UIViewController
@property (nonatomic ,strong) NSString *text;
@property (nonatomic ,copy) SaveBlock saveBlock;
@end
