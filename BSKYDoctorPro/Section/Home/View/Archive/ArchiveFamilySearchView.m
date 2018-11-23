//
//  ArchiveFamilySearchView.m
//  BSKYDoctorPro
//
//  Created by 快医科技 on 2018/1/17.
//  Copyright © 2018年 ky. All rights reserved.
//

#import "ArchiveFamilySearchView.h"

@interface ArchiveFamilySearchView ()
@property (weak, nonatomic) IBOutlet UIView *contentView;
@property (weak, nonatomic) IBOutlet UIImageView *searchIcon;
@property (weak, nonatomic) IBOutlet UIButton *QRBtn;
@property (weak, nonatomic) IBOutlet UIButton *searchBtn;

@end

@implementation ArchiveFamilySearchView
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self) {
        
    }
    return self;
}
- (void)awakeFromNib{
    [super awakeFromNib];
    self.backgroundColor = UIColorFromRGB(0xf7f7f7);
    self.contentView.layer.cornerRadius = 5;
    self.contentView.layer.borderWidth = 0.5;
    self.contentView.backgroundColor = [UIColor whiteColor];
    self.contentView.layer.borderColor = UIColorFromRGB(0xdedede).CGColor;
    
    self.searchBtn.backgroundColor =UIColorFromRGB(0x4e7dd3);
    [self.searchBtn setTitle:@"搜索" forState:UIControlStateNormal];
    [self.searchBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    self.searchBtn.layer.cornerRadius = 10;
}
- (IBAction)searchAction:(id)sender {
    if (self.searchBlock) {
        NSString *str = [_searchTextField.text copy];
        self.searchBlock(str);
    }
}
- (IBAction)QRCheckAtcion:(id)sender {
    if (self.qrBlock) {
        self.qrBlock();
    }
}
- (void)setHasQR:(BOOL)hasQR{
    _hasQR = hasQR;
    self.QRBtn.hidden = !_hasQR;
}
- (void)setPlaceholder:(NSString *)placeholder{
    _placeholder = placeholder;
    self.searchTextField.placeholder = _placeholder;
}
@end
