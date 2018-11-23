//
//  PEController.m
//  BSKYDoctorPro
//
//  Created by vince on 2018/9/29.
//  Copyright © 2018年 ky. All rights reserved.
//

#import "PEController.h"

@interface PEController ()
@property (nonatomic ,strong) UIScrollView *scrollView;
@property (nonatomic ,strong) UIImageView *imageView;
@property (nonatomic ,strong) UIButton *callBtn;
@end

@implementation PEController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self creatUI];
}
- (void)creatUI{
    
    self.title = @"无纸化体检";
    
//    [self.view addSubview:self.scrollView];
//    self.scrollView.contentSize = CGSizeMake(kScreenWidth, self.imageView.height + 150);
//    self.imageView.backgroundColor = [UIColor grayColor];
//    self.scrollView.backgroundColor = [UIColor greenColor];
//    self.callBtn.backgroundColor = [UIColor redColor];
//    [self.scrollView addSubview:self.imageView];
//    [self.scrollView addSubview:self.callBtn];
//    self.callBtn.centerX = kScreenWidth / 2.0;
//    self.callBtn.centerY = self.imageView.height - self.callBtn.height / 2.0;
    
    UIImage *image = [UIImage imageNamed:@"detail_image"];
    CGFloat width = kScreenWidth;
    CGFloat sender = width / image.size.width;
    CGFloat height = sender * image.size.height;
//    _imageView.frame = CGRectMake(0, 0, width, height);
    self.imageView.image = image;
    
    UIImage *callImage = [UIImage imageNamed:@"call_image"];
    [self.callBtn setImage:callImage forState:UIControlStateNormal];
    [self.scrollView setContentSize:CGSizeMake(width, height)];
    
    [self.view addSubview:self.scrollView];
    [self.scrollView addSubview:self.imageView];
    [self.scrollView addSubview:self.callBtn];
    
    [self.scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.bottom.equalTo(@0);
    }];
    [self.imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.equalTo(@0);
        make.height.mas_equalTo(height);
        make.width.mas_equalTo(width);
    }];
    [self.callBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.scrollView.mas_centerX);
        make.bottom.equalTo(self.imageView.mas_bottom).offset(-20 * sender);
        make.size.mas_equalTo(callImage.size);
    }];
    
    
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)callAction{
    NSString *telStr = [NSString stringWithFormat:@"tel://%@",@"02886694856"];
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:telStr]];
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
- (UIScrollView *)scrollView{
    if (!_scrollView) {
        _scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight)];
        
    }
    return _scrollView;
}
- (UIButton *)callBtn{
    if (!_callBtn) {
        _callBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//        UIImage *image = [UIImage imageNamed:@"call_image"];
//        [_callBtn setImage:image forState:UIControlStateNormal];
//
//        [_callBtn setSize:image.size];
        [_callBtn addTarget:self action:@selector(callAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _callBtn;
}
- (UIImageView *)imageView{
    if (!_imageView) {
        _imageView = [[UIImageView alloc] init];
//        UIImage *image = [UIImage imageNamed:@"detail_image"];
//        CGFloat width = kScreenWidth;
//        CGFloat height = width / image.size.width * image.size.height;
//        _imageView.frame = CGRectMake(0, 0, width, height);
//        _imageView.image = image;
    }
    return _imageView;
}
@end
