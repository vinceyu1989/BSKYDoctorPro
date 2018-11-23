//
//  SignPreviewOtherInfoCell.m
//  BSKYDoctorPro
//
//  Created by kykj on 2018/1/2.
//  Copyright © 2018年 ky. All rights reserved.
//

#import "SignPreviewOtherInfoCell.h"
#import "SignSVPackModel.h"

@interface SignPreviewOtherInfoCell ()

@property (weak, nonatomic) IBOutlet UILabel *serverLabel;
@property (weak, nonatomic) IBOutlet UILabel *genderLbel;
@property (weak, nonatomic) IBOutlet UILabel *ageLabel;
@property (weak, nonatomic) IBOutlet UILabel *idCardLabel;
@property (weak, nonatomic) IBOutlet UILabel *crowdLabel;
@property (weak, nonatomic) IBOutlet UILabel *serverPackageLabel;
@property (weak, nonatomic) IBOutlet UILabel *chargeLabel;

@end

@implementation SignPreviewOtherInfoCell

- (void)awakeFromNib {
    [super awakeFromNib];
}

- (void)setModel:(SignPushPersonInfoModel *)model {
    _model = model;
    self.serverLabel.text = [_model.personName decryptCBCStr];
    NSString *typeSex = [[_model.personIdcard decryptCBCStr] sexStrFromIdentityCard];
    if ([typeSex isEqualToString:@"1"]) {
        self.genderLbel.text = @"男";
    } else if ([typeSex isEqualToString:@"2"]) {
        self.genderLbel.text = @"女";
    } else {
        self.genderLbel.text = @"";
    }
    self.ageLabel.text = _model.personAge;
    self.idCardLabel.text = [NSString idCardStrByReplacingCharactersWithAsterisk:[_model.personIdcard decryptCBCStr]];
    self.crowdLabel.text = [self stringByArray:_model.tags];
    if (_model.contractServices.count != 0) {
        NSMutableArray *arr = [NSMutableArray arrayWithCapacity:_model.contractServices.count];
        for (int i = 0; i<_model.contractServices.count; i++) {
            SignSVPackModel *models = (SignSVPackModel *)_model.contractServices[i];
            [arr addObject:models.serviceName];
        }
        self.serverPackageLabel.text = [self stringByArray:arr];
    }
    self.chargeLabel.text = [NSString getMoneyStringWithMoneyNumber:[_model.fee floatValue]];
}

- (NSString *)stringByArray:(NSArray *)array {
    NSString *str = @"";
    if (array.count != 0) {
        for (int i = 0; i<array.count; i++) {
            if (i == 0) {
                str = array[i];
            } else {
                str = [str stringByAppendingString:[NSString stringWithFormat:@"、%@",array[i]]];
            }
        }
    }
    return str;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    // Configure the view for the selected state
}

@end
