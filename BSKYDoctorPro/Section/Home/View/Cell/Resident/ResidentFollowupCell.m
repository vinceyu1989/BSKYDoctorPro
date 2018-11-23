//
//  ResidentFollowupCell.m
//  BSKYDoctorPro
//
//  Created by 何雷 on 2018/1/19.
//  Copyright © 2018年 ky. All rights reserved.
//

#import "ResidentFollowupCell.h"
#import "ResidentRefreshView.h"

@interface ResidentFollowupCell()

@property (weak, nonatomic) IBOutlet UILabel *numLabel;
@property (weak, nonatomic) IBOutlet UILabel *latestLabel;
@property (weak, nonatomic) IBOutlet UILabel *nextTimeLabel;
@property (weak, nonatomic) IBOutlet UIButton *historyBtn;
@property (weak, nonatomic) IBOutlet UIButton *startBtn;
@property (weak, nonatomic) IBOutlet ResidentRefreshView *refreshView;

@end

@implementation ResidentFollowupCell

- (void)awakeFromNib {
    [super awakeFromNib];
    [self.historyBtn addUnderLine];
    [self.startBtn addBorderLine];
}
- (void)setModel:(ResidentFollowupUiModel *)model
{
    _model = model;
    self.contentView.hidden = !_model.isExpansion;
    self.refreshView.hidden = [_model.count isNotEmptyString];
    if (!self.refreshView.hidden) {
        if (_model.isAnimation) {
            [self.refreshView startRefresh];
            self.refreshView.userInteractionEnabled = NO;
        }
        else
        {
            [self.refreshView stopRefresh];
            self.refreshView.userInteractionEnabled = YES;
        }
    }
    self.numLabel.text = [NSString stringWithFormat:@"%@次",_model.count];
    self.latestLabel.text = _model.lastTime;
    self.nextTimeLabel.text = _model.nextTime;
}
- (IBAction)historyBtnPressed:(UIButton *)sender {
    if (self.delegate && [self.delegate respondsToSelector:@selector(residentFollowupCellExamineBtnPressed:)]) {
        [self.delegate residentFollowupCellExamineBtnPressed:self];
    }
    
}
- (IBAction)startBtnPressed:(UIButton *)sender {
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(residentFollowupCellAddBtnPressed:)]) {
        [self.delegate residentFollowupCellAddBtnPressed:self];
    }
}

@end

@implementation ResidentFollowupUiModel

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.isExpansion = NO;
        self.isAnimation = YES;
    }
    return self;
}

@end
