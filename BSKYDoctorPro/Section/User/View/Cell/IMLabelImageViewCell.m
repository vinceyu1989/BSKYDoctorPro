//
//  IMLabelImageViewCell.m
//  BSKYDoctorPro
//
//  Created by 快医科技 on 2018/5/23.
//  Copyright © 2018年 ky. All rights reserved.
//

#import "IMLabelImageViewCell.h"

@interface IMLabelImageViewCell ()
@property (nonatomic ,strong) UIImageView *labelImageView;
@end

@implementation IMLabelImageViewCell
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self.contentView addSubview:self.labelImageView];
        [self.labelImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.bottom.left.right.equalTo(self.contentView);
        }];
    }
    return self;
}
- (UIImageView *)labelImageView{
    if (!_labelImageView) {
        _labelImageView = [[UIImageView alloc] init];
    }
    return _labelImageView;
}
- (void)setModel:(ArchiveSelectOptionModel *)model{
    _model = model;
    [self setLabelImage:model.value.integerValue];
}
- (void)setLabelImage:(NSInteger )value{
    [self.labelImageView setImage:[UIImage imageNamed:[NSString stringWithFormat:@"im_label_%ld",value]]];
}
@end
