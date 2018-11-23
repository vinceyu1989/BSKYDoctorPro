//
//  SignInputTextCell.m
//  BSKYDoctorPro
//
//  Created by 何雷 on 2017/12/28.
//  Copyright © 2017年 ky. All rights reserved.
//

#import "SignInputTextCell.h"
#import "BSDatePickerView.h"
#import "TeamPickerView.h"
#import "BSSignTeamMembersRequest.h"
#import "BSSignLabelModel.h"
#import "SignTeamMembersModel.h"

@interface SignInputTextCell ()
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *requiredIcon;
@property (weak, nonatomic) IBOutlet UIView *line;

@property (nonatomic, strong) BSSignTeamMembersRequest *teamMemberRequest;

@end

@implementation SignInputTextCell

- (void)awakeFromNib {
    [super awakeFromNib];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

- (void)setUiModel:(InterviewInputModel *)uiModel
{
    _uiModel = uiModel;
    self.titleLabel.text = _uiModel.title;
    self.requiredIcon.hidden = !_uiModel.isRequired;
    self.contentTF.placeholder = _uiModel.placeholder;
    if (_uiModel.contentStr.length != 0) {
        self.contentTF.text = _uiModel.contentStr;
    } else {
        self.contentTF.text = @"";
    }
    self.contentTF.tapAcitonBlock = nil;
    self.contentTF.endEditBlock = nil;
    Bsky_WeakSelf
    if ([_uiModel.title isEqualToString:@"签约团队"]) {
        self.contentTF.text = self.teamModel.teamName;
        self.contentTF.tapAcitonBlock = ^{
            Bsky_StrongSelf
            TeamPickerView *pickerView = [[TeamPickerView alloc]init];
            NSMutableArray *arr = [NSMutableArray arrayWithCapacity:self.cellData.count];
            for (int i=0; i<self.cellData.count; i++) {
                SignTeamsInfoModel *model = (SignTeamsInfoModel *)self.cellData[i];
                [arr addObject:model.teamName];
            }
            [pickerView setItems:arr title:self.uiModel.title defaultStr:self.uiModel.contentStr];
            pickerView.selectedIndex = ^(NSInteger index)  {
                Bsky_StrongSelf
                SignTeamsInfoModel *info = (SignTeamsInfoModel *)self.cellData[index];
                self.uiModel.contentStr = info.teamName;
                self.contentTF.text = info.teamName;
                if (self.block) {
                    self.block(info);
                }
            };
            [pickerView show];
        };
        
    } else if ([_uiModel.title isEqualToString:@"签约渠道"]) {
        self.contentTF.tapAcitonBlock = ^{
            Bsky_StrongSelf
            TeamPickerView *pickerView = [[TeamPickerView alloc]init];
            __block NSMutableArray *arr = [NSMutableArray arrayWithCapacity:self.cellData.count];
            for (int i=0; i<self.cellData.count; i++) {
                BSSignLabelModel *model = (BSSignLabelModel *)self.cellData[i];
                [arr addObject:model.dictName];
            }
            [pickerView setItems:arr title:self.uiModel.title defaultStr:self.uiModel.contentStr];
            pickerView.selectedIndex = ^(NSInteger index)  {
                Bsky_StrongSelf
                if (index >= arr.count) return ;
                self.uiModel.contentStr = arr[index];
                self.contentTF.text = self.uiModel.contentStr;
                if (self.block) {
                    self.block(self.cellData[index]);
                }
            };
            [pickerView show];
        };
    } else if ([_uiModel.title isEqualToString:@"经办成员"]) {
        self.contentTF.tapAcitonBlock = ^{
            Bsky_StrongSelf
            if (self.teamModel && self.teamModel.teamId.length == 0) {
                [UIView makeToast:@"请选择签约团队(默认团队可能未包含该医生)~"];
                return;
            }
            if (!self.teamMemberRequest) {
                self.teamMemberRequest = [[BSSignTeamMembersRequest alloc] init];
            }
            self.teamMemberRequest.teamId = self.teamModel.teamId;
            [MBProgressHUD showHud];
            [self.teamMemberRequest startWithCompletionBlockWithSuccess:^(__kindof BSSignTeamMembersRequest * _Nonnull request) {
                Bsky_StrongSelf
                [MBProgressHUD hideHud];
                if (request.teamMembersData.count != 0) {
                    TeamPickerView *pickerView = [[TeamPickerView alloc]init];
                    NSMutableArray *arr = [NSMutableArray arrayWithCapacity:request.teamMembersData.count];
                    for (int i=0; i<request.teamMembersData.count; i++) {
                        SignTeamMembersModel *model = (SignTeamMembersModel *)request.teamMembersData[i];
                        [arr addObject:model.memberName];
                    }
                    NSMutableArray *teamArr = [NSMutableArray arrayWithCapacity:request.teamMembersData.count];
                    for (int i=0; i<request.teamMembersData.count; i++) {
                        SignTeamMembersModel *model = (SignTeamMembersModel *)request.teamMembersData[i];
                        NSString *phone = model.phone.length != 0 ? model.phone : @"";
                        NSArray *arrs = @[model.memberName,phone];
                        [teamArr addObject:arrs];
                    }
                    [pickerView setItems:arr title:self.uiModel.title defaultStr:self.uiModel.contentStr];
                    pickerView.selectedIndex = ^(NSInteger index)  {
                        Bsky_StrongSelf
                        self.uiModel.contentStr = arr[index];
                        self.contentTF.text = self.uiModel.contentStr;
                        SignTeamMembersModel *models = (SignTeamMembersModel *)self.teamMemberRequest.teamMembersData[index];
                        NSMutableArray *info = [NSMutableArray arrayWithCapacity:3];
                        [info addObject:models.memberName];
                        [info addObject:models.employeeId];
                        [info addObject:teamArr];
                        if (self.block) {
                            self.block(info);
                        }
                    };
                    [pickerView show];
                }
            } failure:^(__kindof BSSignTeamMembersRequest * _Nonnull request) {
                [MBProgressHUD hideHud];
                [UIView makeToast:request.msg];
            }];
        };
    } else if ([_uiModel.title isEqualToString:@"开始时间"]) {
        NSString *min = [[[NSDate date] dateByAddingYears:-2] stringWithFormat:@"yyyy-MM-dd"];
        NSString *max = [[[NSDate date] dateByAddingYears:2] stringWithFormat:@"yyyy-MM-dd"];
        self.contentTF.text = [[NSDate date] stringWithFormat:@"yyyy-MM-dd"];
        self.contentTF.tapAcitonBlock = ^{
            Bsky_StrongSelf
            [BSDatePickerView showDatePickerWithTitle:self.uiModel.title dateType:UIDatePickerModeDate defaultSelValue:self.contentTF.text minDateStr:min maxDateStr:max isAutoSelect:NO isDelete:NO resultBlock:^(NSString *selectValue) {
                Bsky_StrongSelf
                self.contentTF.text = selectValue;
                self.uiModel.contentStr = selectValue;
                if (self.block) {
                    self.block(selectValue);
                }
            }];
        };
    } else if ([_uiModel.title isEqualToString:@"结束时间"]) {
        NSString *min = [[[NSDate date] dateByAddingYears:-1] stringWithFormat:@"yyyy-MM-dd"];
        NSString *max = [[[NSDate date] dateByAddingYears:3] stringWithFormat:@"yyyy-MM-dd"];
        self.contentTF.text = [[[NSDate date] dateByAddingYears:1] stringWithFormat:@"yyyy-MM-dd"];;
        self.contentTF.tapAcitonBlock = ^{
            Bsky_StrongSelf
            [BSDatePickerView showDatePickerWithTitle:self.uiModel.title dateType:UIDatePickerModeDate defaultSelValue:self.contentTF.text minDateStr:min maxDateStr:max isAutoSelect:NO isDelete:NO resultBlock:^(NSString *selectValue) {
                Bsky_StrongSelf
                self.contentTF.text = selectValue;
                self.uiModel.contentStr = selectValue;
                if (self.block) {
                    self.block(selectValue);
                }
            }];
        };
    } else if ([_uiModel.title isEqualToString:@"签约代表"]) {
        self.contentTF.endEditBlock = ^(NSString *text) {
            NSLog(@"输入====>%@",text);
            self.contentTF.text = text;
            self.uiModel.contentStr = text;
            if (self.block) {
                self.block(text);
            }
        };
    }
}

- (void)setCellData:(NSMutableArray *)cellData {
    _cellData = cellData;
}

- (void)setTeamModel:(SignTeamsInfoModel *)teamModel {
    _teamModel = teamModel;
}

@end
