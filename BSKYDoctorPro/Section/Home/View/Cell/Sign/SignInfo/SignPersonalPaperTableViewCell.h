//
//  SignPersonalPaperTableViewCell.h
//  BSKYDoctorPro
//
//  Created by kykj on 2018/4/23.
//  Copyright © 2018年 ky. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SignPushPersonInfoModel.h"

typedef NS_ENUM(NSUInteger, SignPersonalPaperType) {
    SignPersonalPaperTypeMore = 0,    //更多
    SignPersonalPaperTypeDelete = 1,  //删除
    SignPersonalPaperTypeUpload = 2,
    SignPersonalChangeArchive = 3,  //修改档案
};

typedef void(^SignPersonalPaperCellBlock)(NSInteger index,SignPersonalPaperType event);

@interface SignPersonalPaperTableViewCell : UITableViewCell

@property (nonatomic, copy) SignPersonalPaperCellBlock choosePaperBlock;
@property (nonatomic, strong) SignPushPersonInfoModel *model;
@property (nonatomic, strong) UIImage *uploadImage;
- (void)setModel:(SignPushPersonInfoModel *)model WithMaster:(NSString *)masterName phone:(NSString *)phone;

@end
