//
//  ArchiveSuccessView.m
//  BSKYDoctorPro
//
//  Created by 快医科技 on 2018/3/22.
//  Copyright © 2018年 ky. All rights reserved.
//

#import "ArchiveSuccessView.h"

@implementation ArchiveSuccessView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [[NSBundle mainBundle] loadNibNamed:@"ArchiveSuccessView" owner:nil options:nil].firstObject;
    if (self) {
        [self setFrame:frame];
    }
    return self;
}
- (IBAction)backAction:(id)sender {
    [self removeFromSuperview];
    if (self.backBlock) {
        
        self.backBlock();
    }
}
- (void)show{
    [[UIApplication sharedApplication].keyWindow addSubview:self];
}
@end
