//
//  SignTagPackPackCell.m
//  BSKYDoctorPro
//
//  Created by 何雷 on 2018/1/2.
//  Copyright © 2018年 ky. All rights reserved.
//

#import "SignTagPackPackCell.h"

@interface SignTagPackPackCell ()

@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;
@property (weak, nonatomic) IBOutlet UILabel *remarkLabel;
@property (weak, nonatomic) IBOutlet UIButton *isSelectedBtn;

@end

@implementation SignTagPackPackCell

- (void)awakeFromNib {
    [super awakeFromNib];
}

- (void)setModel:(SignSVPackModel *)model {
    _model = model;
    self.nameLabel.text = _model.serviceName;
    self.priceLabel.text = [NSString getMoneyStringWithMoneyNumber:[_model.fee doubleValue]];
    self.remarkLabel.text = _model.appObject;
}

- (void)setIsSelect:(BOOL)isSelect {
    self.isSelectedBtn.selected = isSelect;
    [self layoutIfNeeded];
}

- (BOOL)isSelect {
    return self.isSelectedBtn.selected;
}

- (IBAction)isSelectedPressed:(id)sender {
    self.isSelectedBtn.selected = !self.isSelectedBtn.selected;
    if (self.packBlock) {
        self.packBlock(self.model);
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

@end
