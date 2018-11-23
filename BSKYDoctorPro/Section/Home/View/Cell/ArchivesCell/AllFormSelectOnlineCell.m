//
//  AllFormSelectOnlineCell.m
//  BSKYDoctorPro
//
//  Created by 快医科技 on 2018/1/4.
//  Copyright © 2018年 ky. All rights reserved.
//

#import "AllFormsSelectOnlineCell.h"

@interface AllFormsSelectOnlineCell()

@property (nonatomic ,strong) UILabel *titleLabel;

@property (nonatomic ,strong) UILabel *waringLabel;

@property (nonatomic ,strong) UIView *line;

@property (nonatomic ,strong) UIButton *prevBtn;

@end

@implementation AllFormsSelectOnlineCell

static NSInteger const kAllFormsRadioCellBtnTag = 650;

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.titleLabel = [[UILabel alloc]init];
        self.titleLabel.font = [UIFont systemFontOfSize:14];
        self.titleLabel.textColor = UIColorFromRGB(0x666666);
        [self addSubview:self.titleLabel];
        [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.bottom.equalTo(self);
            make.left.equalTo(self.mas_left).offset(15);
            make.height.equalTo(@50);
        }];
        
        self.waringLabel = [[UILabel alloc]init];
        self.waringLabel.font = [UIFont systemFontOfSize:17];
        self.waringLabel.textColor = UIColorFromRGB(0xff2a2a);
        self.waringLabel.text = @"*";
        [self addSubview:self.waringLabel];
        [self.waringLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.titleLabel.mas_right);
            make.centerY.equalTo(self.titleLabel.mas_centerY);
        }];
        
        self.line = [[UIView alloc]init];
        self.line.backgroundColor = UIColorFromRGB(0xededed);
        [self addSubview:self.line];
        [self.line mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.mas_left).offset(15);
            make.bottom.right.equalTo(self);
            make.height.equalTo(@(0.5));
        }];
    }
    return self;
}
- (void)setModel:(BSArchiveModel *)model
{
    _model = model;
    self.titleLabel.text = _model.title;
    self.waringLabel.hidden = !_model.isRequired;
    self.prevBtn = nil;
    for (UIView *btn in self.subviews) {
        if ([btn isKindOfClass:[UIButton class]] && btn.tag >= kAllFormsRadioCellBtnTag) {
            [btn removeFromSuperview];
        }
    }
    NSArray *options = model.selectModel.options;
    if (![model.selectModel.options isNotEmptyArray]) {
        return;
    }
    CGFloat allBtnWith = 0;
    
    for (NSInteger i = options.count-1; i >= 0; i--) {
        NSString *title = [[options objectAtIndex:i] valueForKey:@"title"];
        NSString *value = [[options objectAtIndex:i] valueForKey:@"value"];
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        [btn setTitle:title forState:UIControlStateNormal];
        btn.titleLabel.font = [UIFont systemFontOfSize:14];
        [btn setTitleColor:UIColorFromRGB(0x333333) forState:UIControlStateNormal];
        [btn setBackgroundImage:[UIImage yy_imageWithColor:[UIColor whiteColor]] forState:UIControlStateNormal];
        [btn setBackgroundImage:[UIImage yy_imageWithColor:[UIColor clearColor]] forState:UIControlStateHighlighted];
        [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
        [btn setBackgroundImage:[UIImage yy_imageWithColor:UIColorFromRGB(0x7fc6f3)] forState:UIControlStateSelected];
        [btn sizeToFit];
        btn.layer.borderColor = UIColorFromRGB(0xcccccc).CGColor;
        btn.layer.borderWidth = 1.0;
        [btn setCornerRadius:15];
        btn.tag = kAllFormsRadioCellBtnTag + i;
        [btn addTarget:self action:@selector(btnPressed:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:btn];
        
        allBtnWith = allBtnWith + btn.width+20+10;
        if ([self.model.value isEqualToString:value]) {
            [btn setSelectedAndChangeBorderColor:YES];
            self.prevBtn = btn;
        }
    }
    CGFloat btnMargin = 10;
    [self.titleLabel sizeToFit];
    if (self.width - 30 - self.titleLabel.width - allBtnWith < 0) {
        btnMargin = 5;
    }
    for (NSInteger i = options.count-1; i >= 0; i--) {
        UIButton *btn = [self viewWithTag:kAllFormsRadioCellBtnTag + i];
        UIView *view = [self viewWithTag:btn.tag+1];
        if (view) {
            [btn mas_makeConstraints:^(MASConstraintMaker *make) {
                make.right.equalTo(view.mas_left).offset(-btnMargin);
                make.centerY.equalTo(self.mas_centerY);
                make.height.equalTo(@30);
                make.width.equalTo(@(btn.width+20));
            }];
        }
        else
        {
            [btn mas_makeConstraints:^(MASConstraintMaker *make) {
                make.right.equalTo(self.mas_right).offset(-15);
                make.centerY.equalTo(self.mas_centerY);
                make.height.equalTo(@30);
                make.width.equalTo(@(btn.width+20));
            }];
        }
    }
}

- (void)awakeFromNib {
    [super awakeFromNib];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
}
- (void)btnPressed:(UIButton *)sender
{
    [sender setSelectedAndChangeBorderColor:!sender.selected];
    if (self.prevBtn && self.prevBtn != sender) {
        [self.prevBtn setSelectedAndChangeBorderColor:NO];
    }
    self.prevBtn = sender;
    
    NSString *str = @"";
    NSInteger index = -100;
    
    if (sender.selected) {
        str = sender.titleLabel.text;
        index = sender.tag - kAllFormsRadioCellBtnTag;
//        index = (NSInteger)pow(2, index);
        self.model.value = [[self.model.selectModel.options objectAtIndex:index] valueForKey:@"value"];
    }
    
    
//    [self configUpModelWithIndex:index];
}

@end
