//
//  AuxiliaryCheckSelectCell.m
//  BSKYDoctorPro
//
//  Created by 何雷 on 2017/8/30.
//  Copyright © 2017年 ky. All rights reserved.
//

#import "AuxiliaryCheckSelectCell.h"

@interface AuxiliaryCheckSelectCell()

@end

@implementation AuxiliaryCheckSelectCell

static NSInteger const kAuxiliaryCheckSelectCellBtnTag = 400;    // 列

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        UIView *line = [[UIView alloc]init];
        line.backgroundColor = UIColorFromRGB(0xededed);
        [self addSubview:line];
        [line mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.mas_left).offset(40);
            make.bottom.right.equalTo(self);
            make.height.equalTo(@(0.5));
        }];
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}
- (void)setModel:(AuxiliaryCheckSectionModel *)model
{
    _model = model;
    NSArray *dataArray = model.data;
    for (UIView *view in self.subviews) {
        if (view.tag >= kAuxiliaryCheckSelectCellBtnTag ) {
            [view removeFromSuperview];
        }
    }
    for (int i = 0; i<dataArray.count; i++) {
        
        AuxiliaryCheckRowModel *rowModel = dataArray[i];
        
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.frame = CGRectMake(40+60*i+10*i, 10, 60, 30);
        [btn setBackgroundImage:[UIImage imageWithColor:[UIColor whiteColor] size:btn.bounds.size] forState:UIControlStateNormal];
        [btn setBackgroundImage:[UIImage imageWithColor:UIColorFromRGB(0x4e7dd3) size:btn.bounds.size] forState:UIControlStateSelected];
        [btn setTitleColor:UIColorFromRGB(0x4e7dd3) forState:UIControlStateNormal];
        [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
        [btn setTitle:rowModel.title forState:UIControlStateNormal];
        btn.titleLabel.font = [UIFont systemFontOfSize:14];
        btn.layer.borderColor = UIColorFromRGB(0x4e7dd3).CGColor;
        btn.layer.borderWidth = 1.0;
        [btn setCornerRadius:btn.height/2];
        btn.tag = kAuxiliaryCheckSelectCellBtnTag+ i;
        [btn addTarget:self action:@selector(btnPressed:) forControlEvents:UIControlEventTouchUpInside];
        btn.selected = [rowModel.title isEqualToString:rowModel.content];
        
        [self addSubview:btn];
        
    }
    for (int i = 0;i< dataArray.count; i++) {
        
        UIButton *btn = (UIButton *)[self viewWithTag:kAuxiliaryCheckSelectCellBtnTag+i];
        btn.selected = NO;
        AuxiliaryCheckRowModel *rowModel = dataArray[i];
        if ([rowModel.title isEqualToString:rowModel.content]) {
            btn.selected = YES;
        }
    }
}

- (void)btnPressed:(UIButton *)sender
{
    NSInteger index = sender.tag - kAuxiliaryCheckSelectCellBtnTag;
    NSArray *dataArray = self.model.data;
    
    for (int i = 0;i< self.model.data.count; i++) {
        
        UIButton *btn = (UIButton *)[self viewWithTag:kAuxiliaryCheckSelectCellBtnTag+i];
        AuxiliaryCheckRowModel *rowModel = dataArray[i];
        
        if (i == index) {
            btn.selected = !btn.selected;
            rowModel.content = sender.selected ? rowModel.title : @"";
        }
        else
        {
            btn.selected = NO;
            rowModel.content = @"";
        }
    }
    AuxiliaryCheckRowModel *rowModel1 = dataArray[index];
    if (![rowModel1.content isNotEmptyString]) {
        index = -100;
    }
    
    [self configUpModelWithIndex:index];
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(auxiliaryCheckSelectCell:selectIndex:)]) {
        [self.delegate auxiliaryCheckSelectCell:self selectIndex:index];
    }
}
- (void)configUpModelWithIndex:(NSInteger)index
{
    NSString *str = nil;
    NSNumber *num = nil;
    if (index >= 0) {
        index = (NSInteger)pow(2, index);
        str = [NSString stringWithFormat:@"%ld",(long)index];
        num = @(index);
    }
    if ([self.model.title isEqualToString:@"心电图"]) {
        self.upModel.labora.ecg = str;
    }
    else if ([self.model.title isEqualToString:@"大便潜血"]) {
        self.upModel.labora.fecalOccultBlood = num;
    }
    else if ([self.model.title isEqualToString:@"胸部X线片"]) {
        self.upModel.labora.chestXRay = str;
    }
    else if ([self.model.title isEqualToString:@"B超"]) {
        self.upModel.labora.bUltrasonicWave = str;
    }
    else if ([self.model.title isEqualToString:@"宫颈涂片"]) {
        self.upModel.labora.cervicalSmear = str;
    }
}

@end
