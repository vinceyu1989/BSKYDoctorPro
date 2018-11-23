//
//  InterviewMedicateCell.m
//  BSKYDoctorPro
//
//  Created by 何雷 on 2017/9/6.
//  Copyright © 2017年 ky. All rights reserved.
//

#import "InterviewMedicateCell.h"
#import "TeamPickerView.h"

@interface InterviewMedicateCell()<UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UIView *bgView;
@property (weak, nonatomic) IBOutlet UIButton *deleteBtn;
@property (weak, nonatomic) IBOutlet UITextField *nameTF;
@property (weak, nonatomic) IBOutlet UITextField *rateTF;
@property (weak, nonatomic) IBOutlet UITextField *numTF;
@property (weak, nonatomic) IBOutlet UILabel *unitLabel;
@property (weak, nonatomic) IBOutlet UITextField *remarkTF;
@property (nonatomic ,copy) NSArray *unitArray;

@end

@implementation InterviewMedicateCell

+(CGFloat)cellHeight
{
    return 262;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    [self initView];
    self.unitArray = @[@"mg",@"ml",@"g",@"片",@"粒",@"袋",@"瓶",@"支",@"盒",@"U"];
}
- (void)initView
{
    self.bgView.layer.borderColor = UIColorFromRGB(0xededed).CGColor;
    self.bgView.layer.borderWidth = 0.5;
    [self.deleteBtn setImage:[UIImage imageNamed:@"delete_icon_pressed"] forState:UIControlStateHighlighted];
    self.nameTF.delegate = self;
    self.nameTF.returnKeyType = UIReturnKeyDone;
    
    self.rateTF.delegate = self;
    self.rateTF.returnKeyType = UIReturnKeyDone;
    
    self.numTF.delegate = self;
    self.numTF.returnKeyType = UIReturnKeyDone;
    
    self.remarkTF.delegate = self;
    self.remarkTF.returnKeyType = UIReturnKeyDone;
    
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}
- (IBAction)deleteBtnPressed:(UIButton *)sender {
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(interviewMedicateCellDelete:)]) {
        [self.delegate interviewMedicateCellDelete:self];
    }
}
- (void)setModel:(InterviewInputModel *)model
{
    _model = model;
    if ([_model.object isKindOfClass:[Drug class]]) {
        self.drug = _model.object;
        self.insulinDrug = nil;
    }
    else if ([_model.object isKindOfClass:[InsulinDrug class]]) {
        self.insulinDrug = _model.object;
        self.drug = nil;
    }
}
- (void)setDrug:(Drug *)drug
{
    _drug = drug;
    if (!_drug)  return;
    
    self.nameTF.text = _drug.cmDrugName;
    self.rateTF.text = _drug.dailyTimes;
    self.numTF.text = _drug.eachDose;
    if ([_drug.remark isNotEmptyString]) {
        self.unitLabel.text = _drug.remark;
        self.unitLabel.textColor = UIColorFromRGB(0x333333);
    }
    else
    {
        self.unitLabel.text = @"请选择单位";
        self.unitLabel.textColor = UIColorFromRGBA(0xaaaaaa, 0.7);
    }
    
    self.remarkTF.text = _drug.remark1;
    
}
- (void)setInsulinDrug:(InsulinDrug *)insulinDrug
{
    _insulinDrug = insulinDrug;
    if (!_insulinDrug)   return;
    
    self.nameTF.text = _insulinDrug.drugs;
    self.rateTF.text = _insulinDrug.dailyTimes;
    if (_insulinDrug.eachDose.floatValue <= 0) {
        self.numTF.text = @"";
    }
    else
    {
        self.numTF.text = [NSString stringWithFormat:@"%.f",_insulinDrug.eachDose.floatValue];
    }
    if ([_insulinDrug.remark isNotEmptyString]) {
        self.unitLabel.text = _insulinDrug.remark;
        self.unitLabel.textColor = UIColorFromRGB(0x333333);
    }
    else
    {
        self.unitLabel.text = @"请选择单位";
        self.unitLabel.textColor = UIColorFromRGBA(0xaaaaaa, 0.7);
    }
    
    self.remarkTF.text = _insulinDrug.remark1;
}
#pragma mark ---- UITextFieldDelegate

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    if (self.drug) {
        if (textField == self.nameTF) {
            self.drug.cmDrugName = textField.text;
        }
        else if (textField == self.rateTF)
        {
            self.drug.dailyTimes = textField.text;
        }
        else if (textField == self.numTF)
        {
            self.drug.eachDose = textField.text;
        }
        else
        {
            self.drug.remark1 = textField.text;
        }
        
    }
    else if (self.insulinDrug)
    {
        if (textField == self.nameTF) {
            self.insulinDrug.drugs = textField.text;
        }
        else if (textField == self.rateTF)
        {
            self.insulinDrug.dailyTimes = textField.text;
        }
        else if (textField == self.numTF)
        {
            self.insulinDrug.eachDose = @(textField.text.floatValue);
        }
        else
        {
            self.insulinDrug.remark1 = textField.text;
        }
    }
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}
- (IBAction)unitBtnPressed:(UIButton *)sender {
    
    [self.nameTF resignFirstResponder];
    [self.rateTF resignFirstResponder];
    [self.numTF resignFirstResponder];
    [self.remarkTF resignFirstResponder];
    
    @weakify(self);
    TeamPickerView *pickerView = [[TeamPickerView alloc]init];
    [pickerView setItems:self.unitArray title:@"选择单位" defaultStr:nil];
    pickerView.selectedIndex = ^(NSInteger index)
    {
        @strongify(self);
        if (self.drug) {
            
            self.drug.remark = self.unitArray[index];
        }
        else if (self.insulinDrug)
        {
            self.insulinDrug.remark = self.unitArray[index];
        }
        self.unitLabel.textColor = UIColorFromRGB(0x333333);
        self.unitLabel.text = self.unitArray[index];
    };
    [pickerView show];
}

@end
