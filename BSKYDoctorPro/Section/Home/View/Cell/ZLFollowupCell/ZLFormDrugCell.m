//
//  ZLFormDrugCell.m
//  BSKYDoctorPro
//
//  Created by 何雷 on 2018/3/5.
//  Copyright © 2018年 ky. All rights reserved.
//

#import "ZLFormDrugCell.h"
#import "TeamPickerView.h"
#import "BSTextField.h"
#import "ZLFollowupLastModel.h"

@interface ZLFormDrugCell()

@property (weak, nonatomic) IBOutlet UIView *bgView;
@property (weak, nonatomic) IBOutlet UIButton *deleteBtn;
@property (weak, nonatomic) IBOutlet BSTextField *nameTF;

@property (weak, nonatomic) IBOutlet BSTextField *frequencyTF;
@property (weak, nonatomic) IBOutlet UIButton *frequencyBtn;  // 每日

@property (weak, nonatomic) IBOutlet BSTextField *unitTF;
@property (weak, nonatomic) IBOutlet UIButton *unitBtn;     // 毫升

@property (nonatomic, copy) NSArray * frequencyArray;
@property (nonatomic, copy) NSArray * unitArray;

@end

@implementation ZLFormDrugCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.bgView.layer.borderColor = UIColorFromRGB(0xededed).CGColor;
    self.bgView.layer.borderWidth = 0.5;
    [self.frequencyBtn setCornerRadius:5];
    [self.unitBtn setCornerRadius:5];
    self.frequencyArray = @[@"日",@"小时",@"2日",@"3日",@"周",@"月",@"季度",@"年"];
    self.unitArray = @[@"mg",@"g",@"片",@"粒",@"袋",@"丸",@"个",@"包",@"盒",@"u",@"ml"];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}
- (void)setUiModel:(InterviewInputModel *)uiModel
{
    [super setUiModel:uiModel];
    self.nameTF.rightViewMode =  UITextFieldViewModeNever;
    self.frequencyTF.rightViewMode = UITextFieldViewModeNever;
    self.unitTF.rightViewMode = UITextFieldViewModeNever;
    ZLDrugModel *drugModel = self.uiModel.object;
    self.nameTF.text = drugModel.name;
    self.frequencyTF.text = drugModel.rate;
    self.unitTF.text = drugModel.amount;
    
    if (!drugModel.frequency) {
        drugModel.frequency = self.frequencyArray[0];
    }
    [self.frequencyBtn setTitle:drugModel.frequency forState:UIControlStateNormal];
    
    if (!drugModel.unit) {
        drugModel.unit = self.unitArray[0];
    }
    [self.unitBtn setTitle:drugModel.unit forState:UIControlStateNormal];
    
    
    Bsky_WeakSelf
    self.nameTF.endEditBlock = ^(NSString *text) {
        Bsky_StrongSelf
        ZLDrugModel *model = self.uiModel.object;
        model.name = text;
    };
    self.frequencyTF.endEditBlock = ^(NSString *text) {
        Bsky_StrongSelf
        ZLDrugModel *model = self.uiModel.object;
        model.rate = text;
    };
    self.unitTF.endEditBlock = ^(NSString *text) {
        Bsky_StrongSelf
        ZLDrugModel *model = self.uiModel.object;
        model.amount = text;
    };
}
- (IBAction)deleteBtnPressed:(UIButton *)sender {
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(formBaseCell:configData:)]) {
        [self.delegate formBaseCell:self configData:self.uiModel];
    }
}
- (IBAction)frequencyBtnPressed:(UIButton *)sender {
    [[UIApplication sharedApplication].keyWindow endEditing:YES];
    TeamPickerView *pickerView = [[TeamPickerView alloc]init];
    [pickerView setItems:self.frequencyArray title:@"用法" defaultStr:sender.titleLabel.text];
    Bsky_WeakSelf
    pickerView.selectedIndex = ^(NSInteger index) {
        Bsky_StrongSelf
        [self.frequencyBtn setTitle:self.frequencyArray[index] forState:UIControlStateNormal];
        ZLDrugModel *model = self.uiModel.object;
        model.frequency = self.frequencyArray[index];
    };
    [pickerView show];
}
- (IBAction)unitBtnPressed:(UIButton *)sender {
    
    [[UIApplication sharedApplication].keyWindow endEditing:YES];
    TeamPickerView *pickerView = [[TeamPickerView alloc]init];
    [pickerView setItems:self.unitArray title:@"用量" defaultStr:sender.titleLabel.text];
    Bsky_WeakSelf
    pickerView.selectedIndex = ^(NSInteger index) {
        Bsky_StrongSelf
        [self.unitBtn setTitle:self.unitArray[index] forState:UIControlStateNormal];
        ZLDrugModel *model = self.uiModel.object;
        model.unit = self.unitArray[index];
    };
    [pickerView show];
    
}

@end
