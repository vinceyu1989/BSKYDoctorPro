//
//  AddSubCell.m
//  BSKYDoctorPro
//
//  Created by 快医科技 on 2018/1/5.
//  Copyright © 2018年 ky. All rights reserved.
//

#import "ZLAddSubCell.h"
#import "ArchivePersonDataManager.h"
#import "ZLDiseaseModel.h"

@interface ZLAddSubCell ()
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *contentLabel;

@end

@implementation ZLAddSubCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.contentLabel.lineBreakMode = NSLineBreakByTruncatingTail;
    
    self.contentLabel.numberOfLines = 2;
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
    if ([self.model.code isEqualToString:@"disease"] && !self.model.contentStr.length){
        NSMutableString *textStr = [[NSMutableString alloc] init];
        NSMutableArray *textArray = [NSMutableArray arrayWithArray:self.model.selectModel.selectArray];
        if (self.model.selectModel.others.count){
            [textArray addObjectsFromArray:self.model.selectModel.others];
        }
        for (NSUInteger i = 0 ; i< [textArray count] ; i ++){
            id object = [textArray objectAtIndex:i];
            if ([object isKindOfClass:[ArchiveSelectOptionModel class]]){
                ArchiveSelectOptionModel *selectOption = (ArchiveSelectOptionModel *)object;
                if (![selectOption.title isEqualToString:@"其他"]){
                    [textStr appendString:selectOption.title];
                    if (i != textArray.count - 1){
                        [textStr appendString:@"、"];
                    }
                }
            }else if ([object isKindOfClass:[ZLDiseaseModel class]]){
                ZLDiseaseModel *selectOption = (ZLDiseaseModel *)object;
                [textStr appendString:selectOption.name];
                if (i != textArray.count - 1){
                    [textStr appendString:@"、"];
                }
            }
            
        }
        return textStr;
    }else{
        return _model.contentStr;
    }
}
@end
