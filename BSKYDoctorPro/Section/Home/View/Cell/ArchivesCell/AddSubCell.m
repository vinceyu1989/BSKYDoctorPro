//
//  AddSubCell.m
//  BSKYDoctorPro
//
//  Created by 快医科技 on 2018/1/5.
//  Copyright © 2018年 ky. All rights reserved.
//

#import "AddSubCell.h"
#import "ArchivePersonDataManager.h"

@interface AddSubCell ()
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *contentLabel;

@end

@implementation AddSubCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.contentLabel.lineBreakMode = NSLineBreakByWordWrapping;
    self.contentLabel.numberOfLines = 0;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (void)setModel:(BSArchiveModel *)model{
    _model = model;
    self.titleLabel.text = _model.title;
    self.contentLabel.text = [self treatmentModelValue];
}
- (NSString *)treatmentModelValue{
    NSMutableString *string = [[NSMutableString alloc] init];
    if ([self.model.code isEqualToString:@"disease"]) {
        
        NSArray *diseaseArray = _model.selectModel.options;
        for (ArchiveSelectOptionModel *disease in diseaseArray) {
            if (self.model.value.integerValue & disease.value.integerValue) {
                if (!string.length) {
                    [string appendString:disease.title];
                }else{
                    [string appendFormat:@"、%@",disease.title];
                }
            }
        }
        return string;
    }else{
        return _model.contentStr;
    }
}
@end
