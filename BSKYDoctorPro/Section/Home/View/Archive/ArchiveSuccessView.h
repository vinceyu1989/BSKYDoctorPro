//
//  ArchiveSuccessView.h
//  BSKYDoctorPro
//
//  Created by 快医科技 on 2018/3/22.
//  Copyright © 2018年 ky. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^BackBlock)(void);

@interface ArchiveSuccessView : UIView
@property (nonatomic ,copy) BackBlock backBlock;
- (void)show;
@end
