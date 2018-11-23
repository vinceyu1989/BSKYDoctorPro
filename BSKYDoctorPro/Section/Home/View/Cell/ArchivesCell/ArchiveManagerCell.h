//
//  ArchiveManagerCell.h
//  BSKYDoctorPro
//
//  Created by 快医科技 on 2018/1/18.
//  Copyright © 2018年 ky. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ArchiveManagerCell : UITableViewCell
@property (nonatomic ,strong) id model;
@property (nonatomic ,copy) NSArray *dataArray;
@property (nonatomic ,weak) id listModel;
@end
