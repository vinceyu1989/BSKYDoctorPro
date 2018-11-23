//
//  SignPersonalInfoCell.m
//  BSKYDoctorPro
//
//  Created by 何雷 on 2017/12/29.
//  Copyright © 2017年 ky. All rights reserved.
//

#import "SignPersonalInfoCell.h"
#import "SignSVPackModel.h"

@interface SignPersonalInfoCell() <UIActionSheetDelegate>
@property (weak, nonatomic) IBOutlet UIView *backView;
@property (weak, nonatomic) IBOutlet UIButton *deleteBtn;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *tagLabel;
@property (weak, nonatomic) IBOutlet UIImageView *sexImageView;
@property (weak, nonatomic) IBOutlet UILabel *ageLabel;
@property (weak, nonatomic) IBOutlet UILabel *idNumLabel;
@property (weak, nonatomic) IBOutlet UIButton *moreBtn;
@property (weak, nonatomic) IBOutlet UILabel *crowdTagLabel;
@property (weak, nonatomic) IBOutlet UILabel *servicePackLabel;
@property (weak, nonatomic) IBOutlet UILabel *moneyLabel;
@property (weak, nonatomic) IBOutlet UILabel *phoneLabel;

@end

@implementation SignPersonalInfoCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.backView.layer.borderColor = UIColorFromRGB(0xededed).CGColor;
    self.backView.layer.borderWidth = 0.5;
    self.tagLabel.layer.borderColor = [UIColor colorWithHexString:@"#00AAFF"].CGColor;
    self.tagLabel.layer.borderWidth = 1;
}

- (IBAction)deleteBtnPressed:(id)sender {
    if (self.chooseBlock) {
        self.chooseBlock(self.tag,SignPersonalInfoTypeDelete);
    }
}
- (IBAction)moreBtnPressed:(id)sender {
    if (self.chooseBlock) {
        self.chooseBlock(self.tag,SignPersonalInfoTypeMore);
    }
}
- (IBAction)respondesToChangeArchive:(id)sender {
    if (self.chooseBlock) {
        self.chooseBlock(self.tag,SignPersonalInfoTypeChange);
    }
}

- (void)setModel:(SignPushPersonInfoModel *)model WithMaster:(NSString *)masterName phone:(NSString *)phone{
    _model = model;
    self.nameLabel.text = model.personName;
    self.ageLabel.text = model.personAge;
    self.phoneLabel.text = [phone isNotEmptyString] ? phone : kModelEmptyString;
    self.idNumLabel.text = [NSString idCardStrByReplacingCharactersWithAsterisk:model.personIdcard];
    self.tagLabel.hidden = ![model.personName containsString:masterName];
    self.crowdTagLabel.text = [self stringByArray:model.tags];
    self.moneyLabel.text = [NSString getMoneyStringWithMoneyNumber:[model.fee floatValue]];
    if (model.contractServices.count != 0) {
        NSString *str = @"";
        for (int i = 0; i<model.contractServices.count; i++) {
            SignSVPackModel *models = (SignSVPackModel *)model.contractServices[i];
            if (i == 0) {
                str = models.serviceName;
            } else {
                str = [str stringByAppendingString:[NSString stringWithFormat:@"、%@",models.serviceName]];
            }
        }
        self.servicePackLabel.text = str;
    } else {
        self.servicePackLabel.text = @"";
    }
    
    NSString *typeSex = [_model.personIdcard sexStrFromIdentityCard];
    if ([typeSex isEqualToString:@"1"]) {
        self.sexImageView.image = [UIImage imageNamed:@"man"];
    } else if ([typeSex isEqualToString:@"2"]) {
        self.sexImageView.image = [UIImage imageNamed:@"women"];
    } else {
        self.sexImageView.image = nil;
    }
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
}

@end
