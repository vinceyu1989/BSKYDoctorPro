//
//  FamilyInfoView.m
//  BSKYDoctorPro
//
//  Created by 快医科技 on 2018/1/18.
//  Copyright © 2018年 ky. All rights reserved.
//

#import "FamilyInfoView.h"

@interface FamilyInfoView ()


@end

@implementation FamilyInfoView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
- (void)awakeFromNib{
    [super awakeFromNib];
    self.address.lineBreakMode = NSLineBreakByTruncatingTail;
    self.address.numberOfLines = 2;
}
- (void)setModel:(id )model{
    _model = model;
    if ([model isKindOfClass:[ZLFamilyListModel class]]) {
        self.name.text = [_model valueForKey:@"masterName"];
        self.tel.text = [[_model valueForKey:@"telNumber"] secretStrFromPhoneStr];
        self.code.text = [_model valueForKey:@"familyArchiveId"];
        NSString *str = [[_model valueForKey:@"familyAddress"] stringByReplacingOccurrencesOfString:@">" withString:@""];
        str = [str stringByReplacingOccurrencesOfString:@" " withString:@""];
        self.address.text = str;
    }else if([model isKindOfClass:[FamilyListModel class]]) {
        self.name.text = [_model valueForKey:@"MasterName"];
        self.tel.text = [[_model valueForKey:@"TelNumber"] secretStrFromPhoneStr];
        self.code.text = [_model valueForKey:@"FamilyCode"];
        NSString *str = [[_model valueForKey:@"FamilyAddress"] stringByReplacingOccurrencesOfString:@">" withString:@""];
        str = [str stringByReplacingOccurrencesOfString:@" " withString:@""];
        self.address.text = str;
    }
//    [self layoutIfNeeded];
    self.address.lineBreakMode = NSLineBreakByTruncatingTail;
    self.address.numberOfLines = 2;
    [self.address sizeToFit];
    CGFloat height = self.address.height > 50 ? 50 : self.address.height;
    
    if (!self.address.text.length) {
        height = 18;
    }
    [self.address mas_updateConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(height).priorityHigh();
       
    }];
}
@end
