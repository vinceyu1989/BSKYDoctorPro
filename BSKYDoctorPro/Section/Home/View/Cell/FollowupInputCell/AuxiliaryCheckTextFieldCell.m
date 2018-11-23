//
//  AuxiliaryCheckTextFieldCell.m
//  BSKYDoctorPro
//
//  Created by 何雷 on 2017/8/29.
//  Copyright © 2017年 ky. All rights reserved.
//

#import "AuxiliaryCheckTextFieldCell.h"
#import "InterviewPickerView.h"

@interface AuxiliaryCheckTextFieldCell()<UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

@property (weak, nonatomic) IBOutlet UITextField *textField;

@property (weak, nonatomic) IBOutlet UIButton *tapBtn;


@end

@implementation AuxiliaryCheckTextFieldCell

+(CGFloat)cellHeight
{
    return 50;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    self.textField.delegate = self;
    [self.tapBtn addTarget:self action:@selector(tapBtnPressed:) forControlEvents:UIControlEventTouchUpInside];
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}
- (void)setRowModel:(AuxiliaryCheckRowModel *)rowModel
{
    _rowModel = rowModel;
    self.titleLabel.text = rowModel.title;
    self.textField.autocorrectionType = UITextAutocorrectionTypeNo;
    self.textField.keyboardType = UIKeyboardTypeNumbersAndPunctuation;
    self.textField.placeholder = @"请输入检测数据";
    self.textField.text = @"";
    if ([_rowModel.content isNotEmptyString]) {
        self.textField.text = rowModel.content;
    }
    self.tapBtn.hidden = YES;
    self.textField.enabled = YES;
    self.textField.returnKeyType = UIReturnKeyDone;
    
    if([rowModel.title containsString:@"其他"])
    {
        self.textField.keyboardType = UIKeyboardTypeDefault;
        self.textField.placeholder = @"请输入其他描述";
    }
    
//    self.tapBtn.hidden = NO;
//    self.textField.enabled = NO;
//    if (!_rowModel.pickerModels || _rowModel.pickerModels.count < 1) {
//
//        self.tapBtn.hidden = YES;
//        self.textField.enabled = YES;
//        self.textField.placeholder = @"请输入其他描述";
//    }
    
}

-(void)tapBtnPressed:(UIButton *)sender
{
    [[[UIApplication sharedApplication] keyWindow] endEditing:YES];
    InterviewPickerView *pickerView = [[InterviewPickerView alloc]init];
    pickerView.items = _rowModel.pickerModels;
    @weakify(self);
    pickerView.selectedComplete = ^(NSString *str ,NSArray *selectItems){
        @strongify(self);
        NSString *contentStr = selectItems[0];
        self.rowModel.content = contentStr;
        self.textField.text = contentStr;
        [self configUpModelWithString:contentStr];
        if (self.delegate && [self.delegate respondsToSelector:@selector(auxiliaryCheckTextFieldCell:inputString:)]) {
            [self.delegate auxiliaryCheckTextFieldCell:self inputString:contentStr];
        }
    };
    [pickerView show];
}
#pragma mark ---- UITextFieldDelegate

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    self.rowModel.content = textField.text;
    [self configUpModelWithString:textField.text];
    if (self.delegate && [self.delegate respondsToSelector:@selector(auxiliaryCheckTextFieldCell:inputString:)]) {
        [self.delegate auxiliaryCheckTextFieldCell:self inputString:textField.text];
    }
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [self.textField resignFirstResponder];
    return YES;
}

#pragma mark ---- 配置upModel

- (void)configUpModelWithString:(NSString *)str
{
    NSNumber *num = @(str.floatValue);
    if (![str isNotEmptyString]) {
        str = nil;
        num = nil;
    }
    if ([self.rowModel.title isEqualToString:@"空腹血糖值(mmol/L)"]) {
        if (![self checkTextValidity:str]) return;
        self.upModel.labora.fastingBloodGlucose = num;
    }
    if ([self.rowModel.title isEqualToString:@"血红蛋白(g/L)"]) {
        if (![self checkTextValidity:str]) return;
        self.upModel.labora.hemoglobin = num;
    }
    else if ([self.rowModel.title isEqualToString:@"白细胞(x10^9/L)"])
    {
        if (![self checkTextValidity:str]) return;
        self.upModel.labora.leukocyte = str;
    }
    else if ([self.rowModel.title isEqualToString:@"血小板(x10^9/L)"])
    {
        if (![self checkTextValidity:str]) return;
        self.upModel.labora.platelet = str;
    }
    else if ([self.rowModel.title isEqualToString:@"其他 "])
    {
        self.upModel.labora.otherBlood = str;
    }
    else if ([self.rowModel.title isEqualToString:@"尿蛋白(mg/mmol-Cr)"])
    {
        if (![self checkTextValidity:str]) return;
        self.upModel.labora.urineProtein = str;
    }
    else if ([self.rowModel.title isEqualToString:@"尿糖"])
    {
        self.upModel.labora.urine = str;
    }
    else if ([self.rowModel.title isEqualToString:@"尿酮体(mg/dl)"])
    {
        if (![self checkTextValidity:str]) return;
        self.upModel.labora.ketone = str;
    }
    else if ([self.rowModel.title isEqualToString:@"尿潜血"])
    {
        self.upModel.labora.occultBloodInUrine = str;
    }
    else if ([self.rowModel.title isEqualToString:@"其他  "])
    {
        self.upModel.labora.otherUrine = str;
    }
    else if ([self.rowModel.title isEqualToString:@"尿微量白蛋白(mg/dl)"])
    {
        if (![self checkTextValidity:str]) return;
        self.upModel.labora.urinaryAlbumin = num;
    }
    else if ([self.rowModel.title isEqualToString:@"血清谷丙转氨酶(U/L)"])
    {
        if (![self checkTextValidity:str]) return;
        self.upModel.labora.serumAla = num;
    }
    else if ([self.rowModel.title isEqualToString:@"血清草转氨酶清(U/L)"])
    {
        if (![self checkTextValidity:str]) return;
        self.upModel.labora.serumAa = num;
    }
    else if ([self.rowModel.title isEqualToString:@"总胆红素(μmol/L)"])
    {
        if (![self checkTextValidity:str]) return;
        self.upModel.labora.totalBilirubin = num;
    }
    else if ([self.rowModel.title isEqualToString:@"结合胆红素(μmol/L)"])
    {
        if (![self checkTextValidity:str]) return;
        self.upModel.labora.bilirubin = num;
    }
    else if ([self.rowModel.title isEqualToString:@"白蛋白(g/L)"])
    {
        if (![self checkTextValidity:str]) return;
        self.upModel.labora.albumin = num;
    }
    else if ([self.rowModel.title isEqualToString:@"乙型肝炎表面抗原(%)"])
    {
        if (![self checkTextValidity:str]) return;
        self.upModel.labora.hepatitisBSurfaceAntigen = str;
    }
    else if ([self.rowModel.title isEqualToString:@"糖化血红蛋白(%)"])
    {
        if (![self checkTextValidity:str]) return;
        self.upModel.labora.glycatedHemoglobin = num;
    }
    else if ([self.rowModel.title isEqualToString:@"血清谷丙转氨酶(U/L)"])
    {
        if (![self checkTextValidity:str]) return;
        self.upModel.labora.serumAla = num;
    }
    else if ([self.rowModel.title isEqualToString:@"总胆固醇(mmol/L)"])
    {
        if (![self checkTextValidity:str]) return;
        self.upModel.labora.totalCholesterol = num;
    }
    else if ([self.rowModel.title isEqualToString:@"甘油三酯(mmol/L)"])
    {
        if (![self checkTextValidity:str]) return;
        self.upModel.labora.triglycerides = num;
    }
    else if ([self.rowModel.title isEqualToString:@"血清低密度脂蛋白胆固醇(mmol/L)"])
    {
        if (![self checkTextValidity:str]) return;
        self.upModel.labora.ldlCholesterol = num;
    }
    else if ([self.rowModel.title isEqualToString:@"血清高密度脂蛋白胆固醇(mmol/L)"])
    {
        if (![self checkTextValidity:str]) return;
        self.upModel.labora.hdlCholesterol = num;
    }
    else if ([self.rowModel.title isEqualToString:@"乙型肝炎表面抗原(%)"])
    {
        if (![self checkTextValidity:str]) return;
        self.upModel.labora.hepatitisBSurfaceAntigen = str;
    }
    else if ([self.rowModel.title isEqualToString:@"血清肌酐(μmol/L)"])
    {
        if (![self checkTextValidity:str]) return;
        self.upModel.labora.serumCreatinine = num;
    }
    else if ([self.rowModel.title isEqualToString:@"血尿素氮(mmol/L)"])
    {
        if (![self checkTextValidity:str]) return;
        self.upModel.labora.bun = num;
    }
    else if ([self.rowModel.title isEqualToString:@"血钾浓度(mmol/L)"])
    {
        if (![self checkTextValidity:str]) return;
        self.upModel.labora.potassiumConcentration = num;
    }
    else if ([self.rowModel.title isEqualToString:@"血钠浓度(mmol/L)"])
    {
        if (![self checkTextValidity:str]) return;
        self.upModel.labora.sodiumConcentration = num;
    }
    else if ([self.rowModel.title isEqualToString:@"其他"])
    {
        self.upModel.labora.otherLaboratory = str;
    }
}
- (BOOL )checkTextValidity:(NSString *)str{
    BOOL sender = YES;
    if (str.length && !([self.textField.text isPureFloat] || [self.textField.text isPureInt])) {
        self.rowModel.content = @"";
        self.textField.text = @"";
        [UIView makeToast:@"请输入有效的数值！"];
        sender = NO;
    }
    return sender;
}
@end
