//
//  BSContactCell.h
//  BSKYDoctorPro
//
//  Created by LinfengYU on 2017/8/22.
//  Copyright © 2017年 ky. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "IMFriendInfoModel.h"

@class BSContactCell;

@protocol BSContactCellDelegate <NSObject>

- (void)bsContactCell:(BSContactCell *)cell onPressAvatar:(NSString *)memberId;

@end

@interface BSContactCell : UITableViewCell

@property (nonatomic, strong) NIMTeam * team;   // 设置团队
@property (nonatomic, strong) NIMUser * user;   // 设置好友
@property (nonatomic, strong) IMFriendInfoModel *model;
@property (weak, nonatomic) IBOutlet UIImageView *genderImageView;
@property (weak, nonatomic) IBOutlet UILabel *ageLabel;
@property (nonatomic, weak) id<BSContactCellDelegate> delegate;


@end
