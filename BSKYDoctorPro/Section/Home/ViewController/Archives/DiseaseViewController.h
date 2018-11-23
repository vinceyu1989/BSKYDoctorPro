//
//  DiseaseViewController.h
//  BSKYDoctorPro
//
//  Created by 快医科技 on 2018/3/5.
//  Copyright © 2018年 ky. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^CompeleteBlock)(NSArray *options);

@interface DiseaseViewController : UIViewController
@property (nonatomic ,copy) CompeleteBlock block;
@property (nonatomic ,assign) NSUInteger selectCount;
@property (nonatomic ,strong)NSMutableArray *selectedArray;
@end
