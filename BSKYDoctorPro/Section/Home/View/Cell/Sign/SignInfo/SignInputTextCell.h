//
//  SignInputTextCell.h
//  BSKYDoctorPro
//
//  Created by 何雷 on 2017/12/28.
//  Copyright © 2017年 ky. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "InterviewInputModel.h"
#import "BSTextField.h"
#import "SignTeamsInfoModel.h"

typedef void(^SignInputTextCellBlock)(id content);

@interface SignInputTextCell : UITableViewCell

@property (weak, nonatomic) IBOutlet BSTextField *contentTF;
@property (nonatomic ,strong) InterviewInputModel *uiModel;
@property (nonatomic, strong) SignTeamsInfoModel  *teamModel;
@property (nonatomic, strong) NSMutableArray *cellData;

@property (nonatomic, copy) SignInputTextCellBlock block;

@end
