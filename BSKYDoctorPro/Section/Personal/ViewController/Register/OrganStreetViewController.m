//
//  OrganStreetViewController.m
//  BSKYDoctorPro
//
//  Created by kykj on 2017/11/27.
//  Copyright © 2017年 ky. All rights reserved.
//

#import "OrganStreetViewController.h"
#import "StreetMabeyViewController.h"
#import "OrganTableView.h"

#import "ProvinceCodeRequest.h"
#import "DistrictCodeRequest.h"
#import "StreetOrganRequest.h"

static NSString *identifier = @"OrganStreetTableViewCell";

@interface OrganStreetViewController () <OrganTableViewDelegate>{
    CGFloat       _multiply;
    NSDictionary *_dic;
    NSDictionary *_temp;
}

@property (nonatomic, strong) UIView  *topView;
@property (nonatomic, strong) UILabel *topTitle;
@property (nonatomic, strong) UIImageView *imageView;

@property (nonatomic, strong) UIView *lineView;

@property (nonatomic, strong) OrganTableView *cityView;
@property (nonatomic, strong) OrganTableView *areaView;
@property (nonatomic, strong) OrganTableView *streetView;

@property (nonatomic, strong) ProvinceCodeRequest *provinceRequest;
@property (nonatomic, strong) DistrictCodeRequest *districtRequest;
@property (nonatomic, strong) StreetOrganRequest  *streetRequst;

@end

@implementation OrganStreetViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initView];
    [self initData];
}

- (void)initView {
    
    _multiply = SCREEN_WIDTH/375.0;
    
    self.title = @"选择医疗机构";
    self.view.backgroundColor = [UIColor colorWithHexString:@"#f7f7f7"];
    self.topTitle.center = self.topView.center;
    [self.topView addSubview:self.topTitle];
    [self.topView addSubview:self.imageView];
    [self.view addSubview:self.topView];
    
    self.cityView = [[OrganTableView alloc] init];
    self.cityView.isBackground = YES;
    self.cityView.backgroundColor = [UIColor colorWithHexString:@"#f7f7f7"];
    [self.cityView setSeparatorStyle:UITableViewCellSeparatorStyleSingleLine];
    [self.cityView setSeparatorColor:[UIColor colorWithHexString:@"#dedede"]];
    self.cityView.myDelegate = self;
    [self.view addSubview:self.cityView];
    
    self.lineView = [[UIView alloc] init];
    self.lineView.backgroundColor = [UIColor colorWithHexString:@"#dedede"];
    [self.view addSubview:self.lineView];
    
    self.areaView = [[OrganTableView alloc] init];
    self.areaView.myDelegate = self;
    [self.areaView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    self.areaView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.areaView];
    
    self.streetView = [[OrganTableView alloc] init];
    self.streetView.myDelegate = self;
    [self.streetView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    self.streetView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.streetView];
    [self addContrain];
}

- (void)addContrain {
    
    [self.cityView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.topView.mas_bottom);
        make.left.equalTo(self.view.mas_left);
        make.bottom.equalTo(self.view.mas_bottom).offset(-SafeAreaBottomHeight);
        make.width.equalTo(@(99.5*_multiply));
    }];
    UIView *line = [[UIView alloc] init];
    line.backgroundColor = [UIColor colorWithHexString:@"#dedede"];
    [self.view addSubview:line];
    [line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.topView.mas_bottom);
        make.left.equalTo(self.cityView.mas_right);
        make.bottom.equalTo(self.view.mas_bottom).offset(-SafeAreaBottomHeight);
        make.width.equalTo(@0.5);
    }];
    
    [self.areaView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.topView.mas_bottom);
        make.left.equalTo(line.mas_right);
        make.bottom.equalTo(self.view.mas_bottom).offset(-SafeAreaBottomHeight);
        make.width.equalTo(@(124.5*_multiply));
    }];
    
    [self.lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.topView.mas_bottom);
        make.left.equalTo(self.areaView.mas_right);
        make.bottom.equalTo(self.view.mas_bottom).offset(-SafeAreaBottomHeight);
        make.width.equalTo(@0.5);
    }];
    [self.streetView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.topView.mas_bottom);
        make.left.equalTo(self.lineView.mas_right);
        make.bottom.equalTo(self.view.mas_bottom).offset(-SafeAreaBottomHeight);
        make.width.equalTo(@(150*_multiply));
    }];
}

- (void)initData {
    self.provinceRequest = [[ProvinceCodeRequest alloc] init];
    self.districtRequest = [[DistrictCodeRequest alloc] init];
    self.streetRequst = [[StreetOrganRequest alloc] init];
    
    self.provinceRequest.divisionCode = 51;
    [MBProgressHUD showHud];
    Bsky_WeakSelf
    [self.provinceRequest startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest * _Nonnull request) {
        Bsky_StrongSelf
        self.cityView.tableData = self.provinceRequest.provinceData;
        [MBProgressHUD hideHud];
    } failure:^(__kindof YTKBaseRequest * _Nonnull request) {
        [MBProgressHUD hideHud];
    }];
}

#pragma mark - OrganTableViewDelegate

- (void)didSelectedTabelView:(OrganTableView *)tabelView WithModel:(DivisionCodeModel *)model Index:(NSInteger)index {
    
    [self setToptitleAndImageWithTitle:model.divisionName];
    if (tabelView == self.cityView) {
        self.areaView.tableData = model.children;
        self.streetView.tableData = nil;
    } else if (tabelView == self.areaView) {
        self.districtRequest.parentId = model.divisionId;
        [MBProgressHUD showHud];
        WS(weakSelf);
        [self.districtRequest startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest * _Nonnull request) {
            [MBProgressHUD hideHud];
            weakSelf.streetView.tableData = weakSelf.districtRequest.districtData;
        } failure:^(__kindof YTKBaseRequest * _Nonnull request) {
            [MBProgressHUD hideHud];
        }];
    } else if (tabelView == self.streetView) {
        
        self.streetRequst.divisionId = model.divisionId;
        self.streetRequst.pageSize = @"10";
        self.streetRequst.pageNo = @"1";
        WS(weakSelf);
        [MBProgressHUD showHud];
        [self.streetRequst startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest * _Nonnull request) {
            [MBProgressHUD hideHud];
            if (weakSelf.streetRequst.streetData.count > 1) {
                StreetMabeyViewController *mabeyVC = [[StreetMabeyViewController alloc] init];
                mabeyVC.model = model;
                mabeyVC.dataSource  = weakSelf.streetRequst.streetData;
                [mabeyVC setBlock:^(StreetMabeyViewController *vc, DivisionCodeModel *model) {
                    [vc.navigationController popViewControllerAnimated:NO];
                    if (weakSelf.block) {
                        weakSelf.block(weakSelf, model);
                    }
                }];
                [weakSelf.navigationController pushViewController:mabeyVC animated:YES];
            } else if (weakSelf.streetRequst.streetData.count == 1){
                if (weakSelf.block) {
                    weakSelf.block(weakSelf, weakSelf.streetRequst.streetData[0]);
                }
            } else {
                 [UIView makeToast:@"该街道暂无医疗机构~"];
            }
        } failure:^(__kindof YTKBaseRequest * _Nonnull request) {
            [MBProgressHUD hideHud];
            [UIView makeToast:weakSelf.streetRequst.msg];
        }];
    }
}

- (void)setToptitleAndImageWithTitle:(NSString *)title {
    self.topTitle.text = title;
    [self.topTitle sizeToFit];
    self.imageView.hidden = NO;
    self.topTitle.textColor = [UIColor colorWithHexString:@"#4e7dd3"];
    [self.topTitle mas_updateConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.topView.mas_centerX).offset(-8);
        make.centerY.equalTo(self.topView.mas_centerY);
    }];
    [self.imageView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.topTitle.mas_right).offset(8);
        make.centerY.equalTo(self.topView.mas_centerY);
    }];
}

#pragma mark - getter
- (UIView *)topView {
    if (!_topView) {
        _topView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.width, 30*_multiply)];
        _topView.backgroundColor = [UIColor colorWithHexString:@"#effaff"];
    }
    return _topView;
}

- (UILabel *)topTitle {
    if (!_topTitle) {
        _topTitle = ({
            UILabel *label = [[UILabel alloc] init];
            label.textAlignment = NSTextAlignmentCenter;
            label.textColor = [UIColor colorWithHexString:@"#333333"];
            label.text = @"请选择";
            label.font = [UIFont systemFontOfSize:15*_multiply];
            [label sizeToFit];
            label;
        });
    }
    return _topTitle;
}

- (UIImageView *)imageView {
    if (!_imageView) {
        _imageView = [[UIImageView alloc] init];
        _imageView.image = [UIImage imageNamed:@"ico切换"];
        [_imageView sizeToFit];
        _imageView.hidden = YES;
    }
    return _imageView;
}

@end
