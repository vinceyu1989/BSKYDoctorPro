//
//  MsgContentTableViewCell.h
//  BSKYDoctorPro
//
//  Created by kykj on 2018/4/8.
//  Copyright © 2018年 ky. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^MsgContentCellBlock)(void);

@interface MsgContentTableViewCell : UITableViewCell

@property (nonatomic, copy) NSString *contentStr;
@property (nonatomic, copy) MsgContentCellBlock block;

@end
