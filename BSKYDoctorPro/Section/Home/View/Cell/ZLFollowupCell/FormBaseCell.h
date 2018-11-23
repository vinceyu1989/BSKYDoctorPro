//
//  FormBaseCell.h
//  BSKYDoctorPro
//
//  Created by 何雷 on 2018/2/28.
//  Copyright © 2018年 ky. All rights reserved.
//

#import <UIKit/UIKit.h>

@class FormBaseCell;

@protocol FormBaseCellDelegate <NSObject>

- (void)formBaseCell:(FormBaseCell *)cell configData:(InterviewInputModel *)uiModel;

@end

@interface FormBaseCell : UITableViewCell

@property (nonatomic, strong) InterviewInputModel * uiModel;

@property (nonatomic ,weak) id<FormBaseCellDelegate> delegate;

@end
