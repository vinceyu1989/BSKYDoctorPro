//
//  SignPersonalPaperTableViewCell.m
//  BSKYDoctorPro
//
//  Created by kykj on 2018/4/23.
//  Copyright © 2018年 ky. All rights reserved.
//

#import "SignPersonalPaperTableViewCell.h"
#import "SignSVPackModel.h"

@interface SignPersonalPaperTableViewCell ()

@property (weak, nonatomic) IBOutlet UIView *backView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *isMasterLabel;
@property (weak, nonatomic) IBOutlet UIImageView *sexImage;
@property (weak, nonatomic) IBOutlet UILabel *ageLabel;
@property (weak, nonatomic) IBOutlet UILabel *IDCardLabel;
@property (weak, nonatomic) IBOutlet UILabel *tagLabel;
@property (weak, nonatomic) IBOutlet UILabel *serverLabel;
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;
@property (weak, nonatomic) IBOutlet UIImageView *profileImage;

@property (weak, nonatomic) IBOutlet UIButton *deleteBtn;
@property (weak, nonatomic) IBOutlet UIButton *moreBtn;
@property (weak, nonatomic) IBOutlet UIButton *uploadBtn;
@property (weak, nonatomic) IBOutlet UILabel  *phoneLabel;

@end

@implementation SignPersonalPaperTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.backView.layer.borderColor = UIColorFromRGB(0xededed).CGColor;
    self.backView.layer.borderWidth = 0.5;
    self.isMasterLabel.layer.borderColor = [UIColor colorWithHexString:@"#00AAFF"].CGColor;
    self.isMasterLabel.layer.borderWidth = 1;
    if (self.uploadImage) {
        [self.uploadBtn setImage:_uploadImage forState:UIControlStateNormal];
    }else {
        [self.uploadBtn setImage:nil forState:UIControlStateNormal];
    }
}

- (IBAction)respondToMore:(id)sender {
    if (self.choosePaperBlock) {
        self.choosePaperBlock(self.tag,SignPersonalPaperTypeMore);
    }
}

- (IBAction)repondToUpload:(id)sender {
    if (self.choosePaperBlock) {
        self.choosePaperBlock(self.tag,SignPersonalPaperTypeUpload);
    }
}

- (IBAction)respondToDelete:(id)sender {
    if (self.choosePaperBlock) {
        self.choosePaperBlock(self.tag,SignPersonalPaperTypeDelete);
    }
}
- (IBAction)respondesToChangeCode:(id)sender {
    if (self.choosePaperBlock) {
        self.choosePaperBlock(self.tag,SignPersonalChangeArchive);
    }
}

- (void)setUploadImage:(UIImage *)uploadImage {
    if (uploadImage == nil) {
        [self.profileImage setImage:[UIImage imageNamed:@"camera"]];
    } else {
        _uploadImage = uploadImage;
        [self.profileImage setImage:uploadImage];
    }
}

- (void)setModel:(SignPushPersonInfoModel *)model WithMaster:(NSString *)masterName phone:(NSString *)phone{
    _model = model;
    self.nameLabel.text = model.personName;
    self.ageLabel.text = model.personAge;
    self.phoneLabel.text = [phone isNotEmptyString] ? phone : kModelEmptyString;
    self.IDCardLabel.text = [NSString idCardStrByReplacingCharactersWithAsterisk:model.personIdcard];
    self.isMasterLabel.hidden = ![model.personName containsString:masterName];
    self.tagLabel.text = [self stringByArray:model.tags];
    self.priceLabel.text = [NSString getMoneyStringWithMoneyNumber:[model.fee floatValue]];
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
        self.serverLabel.text = str;
    } else {
        self.serverLabel.text = @"";
    }
    
    NSString *typeSex = [_model.personIdcard sexStrFromIdentityCard];
    if ([typeSex isEqualToString:@"1"]) {
        self.sexImage.image = [UIImage imageNamed:@"man"];
    } else if ([typeSex isEqualToString:@"2"]) {
        self.sexImage.image = [UIImage imageNamed:@"women"];
    } else {
        self.sexImage.image = nil;
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
    // Configure the view for the selected state
}

@end
