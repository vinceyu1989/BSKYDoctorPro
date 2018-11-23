//
//  FollowupSymptomCell.h
//  BSKYDoctorPro
//
//  Created by 何雷 on 2017/11/22.
//  Copyright © 2017年 ky. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FollowupSymptomCell : UITableViewCell

@property (nonatomic ,assign) FollowupType type;

@property (nonatomic ,assign) NSInteger contentIndex;   // 配置默认显示

@property (nonatomic ,copy) NSString *otherStr;  // 默认显示其他

@property (nonatomic, copy)  void (^contentBlock)(NSString *otherStr,NSInteger contentIndex);  // 返回数据


@end
