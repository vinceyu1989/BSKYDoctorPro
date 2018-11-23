//
//  SignServiceDetailTopCell.m
//  BSKYDoctorPro
//
//  Created by kykj on 2018/1/3.
//  Copyright © 2018年 ky. All rights reserved.
//

#import "SignServiceDetailTopCell.h"

@interface SignServiceDetailTopCell ()

@property (weak, nonatomic) IBOutlet UIImageView *serviceImage;
@property (weak, nonatomic) IBOutlet UILabel *serviceName;
@property (weak, nonatomic) IBOutlet UILabel *serviceTime;
@property (weak, nonatomic) IBOutlet UILabel *serviceCharge;

@end

@implementation SignServiceDetailTopCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setModel:(SignSVPackModel *)model {
    _model = model;
    self.serviceName.text = _model.serviceName;
    self.serviceCharge.text = [NSString getMoneyStringWithMoneyNumber:[_model.fee floatValue]];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    // Configure the view for the selected state
}

@end
