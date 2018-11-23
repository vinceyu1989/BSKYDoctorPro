//
//  BSFollowupCreatorCell.h
//  BSKYDoctorPro
//
//  Created by LinfengYU on 2017/8/29.
//  Copyright © 2017年 ky. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BSFollowupCreatorCell : UITableViewCell

@property (nonatomic, copy) void (^diabetesBlock)();
@property (nonatomic, copy) void (^hypertensionBlock)();
@property (nonatomic, copy) void (^highGlucoseBlock)();
@property (nonatomic, copy) void (^mentalDiseaseBlock)();

@end
