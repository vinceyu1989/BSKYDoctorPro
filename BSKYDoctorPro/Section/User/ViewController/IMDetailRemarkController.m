//
//  IMDetailRemarkController.m
//  BSKYDoctorPro
//
//  Created by 快医科技 on 2018/5/18.
//  Copyright © 2018年 ky. All rights reserved.
//

#import "IMDetailRemarkController.h"
#import "CATPlaceHolderTextView.h"

@interface IMDetailRemarkController () <UITextViewDelegate>
@property (nonatomic ,strong) CATPlaceHolderTextView *textView;
@property (nonatomic ,strong) UIButton *saveBtn;
@property (nonatomic ,strong) UIView *textBackView;
@end

@implementation IMDetailRemarkController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self creatUI];
}
- (void)creatUI{
    self.title = @"备注";
    self.view.backgroundColor = UIColorFromRGB(0xf7f7f7);
    
    [self.view addSubview:self.textBackView];
    [self.textBackView addSubview:self.textView];
    [self.view addSubview:self.saveBtn];
    
    [self.textBackView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.equalTo(@0);
        make.height.mas_equalTo(200);
    }];
    
    [self.textView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.mas_equalTo(15);
        make.bottom.right.mas_equalTo(-15);
    }];
    [self.saveBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.textBackView.mas_bottom).offset(30);
        make.left.mas_equalTo(15);
        make.right.mas_equalTo(-15);
        make.height.mas_equalTo(50);
    }];
}
- (void)setText:(NSString *)text{
    _text = text;
    self.textView.text = text;
}
- (UIView *)textBackView{
    if (!_textBackView) {
        _textBackView = [[UIView alloc] init];
        
    }
    return _textBackView;
}
- (CATPlaceHolderTextView *)textView{
    if (!_textView) {
        _textView = [[CATPlaceHolderTextView alloc] init];
        _textView.placeholder = @"请输入备注信息";
        _textView.delegate = self;
    }
    return _textView;
}
- (UIButton *)saveBtn{
    if (!_saveBtn) {
        _saveBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _saveBtn.backgroundColor = UIColorFromRGB(0x4e7dd3);
        [_saveBtn setTitle:@"保存" forState:UIControlStateNormal];
        _saveBtn.layer.cornerRadius = 5.0;
        [_saveBtn addTarget:self action:@selector(saveAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _saveBtn;
}
- (void)saveAction{
    if (!self.textView.text.length) {
        [UIView makeToast:@"请输入备注信息！"];
        return;
    }
    self.saveBlock(self.textView.text);
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
- (void)textViewDidChange:(UITextView *)textView{
    if (textView.text.length > 16) {
        textView.text = [textView.text substringToIndex:16];
    }
}
@end
