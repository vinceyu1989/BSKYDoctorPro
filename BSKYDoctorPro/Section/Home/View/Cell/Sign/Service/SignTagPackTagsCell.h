//
//  SignTagPackTagsCell.h
//  BSKYDoctorPro
//
//  Created by 何雷 on 2018/1/2.
//  Copyright © 2018年 ky. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^SignTagPackTagsCellBlock)(NSInteger index);

@interface SignTagPackTagsCell : UITableViewCell

@property (nonatomic ,strong) NSMutableArray *tags;
@property (nonatomic, copy) SignTagPackTagsCellBlock tagBlock;

@end
