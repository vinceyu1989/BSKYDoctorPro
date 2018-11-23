//
//  SignPersonalInfoCell.h
//  BSKYDoctorPro
//
//  Created by 何雷 on 2017/12/29.
//  Copyright © 2017年 ky. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SignPushPersonInfoModel.h"

typedef NS_ENUM(NSUInteger, SignPersonalInfoType) {
    SignPersonalInfoTypeMore = 0,    //更多
    SignPersonalInfoTypeDelete = 1,  //删除
    SignPersonalInfoTypeChange = 2,  //修改档案
};

typedef void(^SignPersonalInfoCellBlock)(NSInteger index,SignPersonalInfoType event);

@interface SignPersonalInfoCell : UITableViewCell

@property (nonatomic, copy) SignPersonalInfoCellBlock chooseBlock;
@property (nonatomic, strong) SignPushPersonInfoModel *model;
- (void)setModel:(SignPushPersonInfoModel *)model WithMaster:(NSString *)masterName phone:(NSString *)phone;

@end
