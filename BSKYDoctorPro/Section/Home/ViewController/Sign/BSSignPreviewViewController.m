                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                //
//  BSSignPreviewViewController.m
//  BSKYDoctorPro
//
//  Created by kykj on 2017/12/28.
//  Copyright © 2017年 ky. All rights reserved.
//

#import "BSSignPreviewViewController.h"
#import "BSSignSuccessViewController.h"
#import "SignPreviewTopInfoCell.h"
#import "SignPreviewOtherInfoCell.h"
#import "SignPreviewRemarkCell.h"
#import "SignPreviewSignalCell.h"

#import "BSSignInfoPushRequest.h"
#import "SignPushPersonInfoModel.h"         
#import "SignSVPackModel.h"

#import "BjcaSignManager.h"

@interface BSSignPreviewViewController () <UITableViewDelegate, UITableViewDataSource, UIGestureRecognizerDelegate>{
    CGFloat _multiply;
    BOOL         _isPopGesture;
    __block BOOL _isBSSDK;
}

@property (nonatomic, strong) UITableView *tabelView;
@property (nonatomic, strong) UIView      *footerView;
@property (nonatomic, strong) UIButton    *backBtn;
@property (nonatomic, strong) UIButton    *inPutBtn;
@property (nonatomic, strong) NSString *teamName;
@property (nonatomic, strong) NSString *teanEmpName;

@property (nonatomic, strong) BjcaSignManager *manager;

@end

@implementation BSSignPreviewViewController

- (void)dealloc {
    self.manager = nil;
    self.pushResponseModel = nil;
    self.pushInfoModel = nil;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initView];
    if ([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
        self.navigationController.interactivePopGestureRecognizer.delegate = self;
    }
}

- (void)initView {
    _multiply = SCREEN_WIDTH/375.0;
    _isPopGesture = NO;
    _isBSSDK = YES;
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:[UIView new]];;
    self.title = @"预览";
    self.view.backgroundColor = [UIColor colorWithHexString:@"#f7f7f7"];
    self.tabelView = ({
        UITableView *table = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        table.backgroundColor = [UIColor colorWithHexString:@"#f7f7f7"];
        [table setSeparatorStyle:UITableViewCellSeparatorStyleNone];
        table.delegate = self;
        table.dataSource = self;
        table.estimatedRowHeight = 200;
        table.rowHeight = UITableViewAutomaticDimension;
        [table registerNib:[SignPreviewTopInfoCell nib] forCellReuseIdentifier:[SignPreviewTopInfoCell cellIdentifier]];
        [table registerNib:[SignPreviewOtherInfoCell nib] forCellReuseIdentifier:[SignPreviewOtherInfoCell cellIdentifier]];
        [table registerNib:[SignPreviewRemarkCell nib] forCellReuseIdentifier:[SignPreviewRemarkCell cellIdentifier]];
        [table registerNib:[SignPreviewSignalCell nib] forCellReuseIdentifier:[SignPreviewSignalCell cellIdentifier]];
        [self.view addSubview:table];
        table;
    });
    
    self.backBtn = ({
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        [btn addTarget:self action:@selector(backBtnPressed) forControlEvents:UIControlEventTouchUpInside];
        [btn setTitle:@"上一步" forState:UIControlStateNormal];
        [btn setTitleColor:[UIColor colorWithHexString:@"#4e7dd3"] forState:UIControlStateNormal];
        [btn setTitleColor:[UIColor colorWithHexString:@"#a6bee9"] forState:UIControlStateHighlighted];;
        btn.titleLabel.font = [UIFont systemFontOfSize:_multiply*18.0];
        [self.view addSubview:btn];
        btn;
    });
    
    self.inPutBtn = ({
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        [btn setBackgroundImage:[UIImage imageWithColor:[UIColor colorWithHexString:@"#4e7dd3"]] forState:UIControlStateNormal];
        [btn setBackgroundImage:[UIImage imageWithColor:[UIColor colorWithHexString:@"#273e69"]] forState:UIControlStateHighlighted];
        [btn addTarget:self action:@selector(inPutBtnPressed) forControlEvents:UIControlEventTouchUpInside];
        [btn setTitle:@"提交" forState:UIControlStateNormal];
        [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];;
        btn.titleLabel.font = [UIFont systemFontOfSize:_multiply*18.0];
        [self.view addSubview:btn];
        btn;
    });
    
    [self addContraint];
    [self.tabelView reloadData];
}

- (void)addContraint {
    [self.tabelView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.equalTo(self.view);
        make.bottom.equalTo(self.view.mas_bottom).offset(-45*_multiply-SafeAreaBottomHeight);
    }];
    
    [self.backBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.mas_left);
        make.bottom.equalTo(self.view.mas_bottom).offset(-SafeAreaBottomHeight);
        make.width.equalTo(@(SCREEN_WIDTH/2.0));
        make.height.equalTo(@(45*_multiply));
    }];
    
    [self.inPutBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.view.mas_right);
        make.bottom.equalTo(self.view.mas_bottom).offset(-SafeAreaBottomHeight);
        make.width.equalTo(@(SCREEN_WIDTH/2.0));
        make.height.equalTo(@(45*_multiply));
    }];
}
#pragma mark - button pressed
- (void)backBtnPressed {
    _isPopGesture = NO;
    [BjcaSignManager bjca_removeCert];
    if (self.deleteBlock) {
        self.deleteBlock(self);
    }
}

//*<开始ca签约 >/
- (void)inPutBtnPressed {
    if (self.pushResponseModel.uniqueId && _isBSSDK==YES) {
        _isBSSDK = NO;
        [self yiwangqianSDKHandle];
    }
}

- (void)yiwangqianSDKHandle {
    if (!self.manager) {
        self.manager = [BjcaSignManager initWithContainnerVC:self];
    }
    
    [self.manager setServerURL:[BSAppManager sharedInstance].signServerType];
   
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        _isBSSDK = YES;
    });
    // 判断是否存在证书
    if ([BjcaSignManager existsCert]) {
        [self signSuccessHandler];
        return;
    }
    // 2.进去医网签页面 下载医生证书 签章
    [self.manager startUrl:[BSAppManager sharedInstance].signClientId pageType:PageTypeDownLoad];
}

- (void)signSuccessHandler {
    WS(weakSelf);
    [weakSelf.manager signRecipe:self.pushResponseModel.uniqueId userClientId:[BSAppManager sharedInstance].signClientId response:^(BusinessSignetType businessType, id result) {
        NSString * groupIdstr = result[@"status"];
        if ([groupIdstr isEqualToString:@"0"]) {
            [UIView makeToast:@"签名成功"];
//          NSData *_decodedImageData   = [[NSData alloc] initWithBase64Encoding:result[@"stampPic"]];
//          UIImage *_decodedImage = [UIImage imageWithData:_decodedImageData];
            BSSignSuccessViewController *success_vc = [[BSSignSuccessViewController alloc] init];
            [success_vc setBlock:^(BSSignSuccessViewController *vc) {
                [vc dismissViewControllerAnimated:NO completion:nil];
                [weakSelf.navigationController popToRootViewControllerAnimated:YES];
            }];
            [weakSelf presentViewController:success_vc animated:YES completion:nil];
        } else {
            if (![result[@"status"] isEqualToString:@"3000"]) {
                [UIView makeToast:[NSString stringWithFormat:@"%@,%@",result[@"status"],result[@"message"]]];
                [weakSelf.manager startDoctor:[BSAppManager sharedInstance].signClientId];
            }
        }
    }];
}

#pragma mark - setter
- (void)setPushInfoModel:(SignInfoRequestModel *)pushInfoModel {
    _pushInfoModel = pushInfoModel;
}

- (void)setPushResponseModel:(SignInfoRespondseModel *)pushResponseModel {
    _pushResponseModel = pushResponseModel;
}

- (void)setTeamNameWithName:(NSString *)teamName TeamEmpName:(NSString *)teamEmpName {
    _teamName = teamName;
    _teanEmpName = teamEmpName;
}

- (BOOL)isPopGesture {
    return _isPopGesture;
}

#pragma mark - private
//*<居中显示  距离边界间距 >/
- (CGFloat)returnStringHeightWithStr:(NSString *)str Width:(CGFloat)width{
    CGFloat labelHeight = [str boundingRectWithSize:CGSizeMake(width, 0)
                                            options:NSStringDrawingUsesLineFragmentOrigin
                                         attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14]}
                                            context:nil].size.height;
    return labelHeight;
}
#pragma mark - tabelView Delegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 4;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 1) {
        if (self.pushInfoModel) {
            return self.pushInfoModel.signPersonList.count;
        }
        return 0;
    } else if (section == 2 && self.pushInfoModel.remark.length == 0) {
        return 0;
    }
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = nil;
    switch (indexPath.section) {
        case 0:
        {
            cell = [tableView dequeueReusableCellWithIdentifier:[SignPreviewTopInfoCell cellIdentifier] forIndexPath:indexPath];
            [(SignPreviewTopInfoCell *)cell setModel:self.pushInfoModel];
            [(SignPreviewTopInfoCell *)cell setTeamName:self.teamName TeamEmpName:self.teanEmpName];
        }
            break;
        case 1:
        {
            if (!self.pushInfoModel || self.pushInfoModel.signPersonList.count == 0) {
                return cell;
            }
            cell = [tableView dequeueReusableCellWithIdentifier:[SignPreviewOtherInfoCell cellIdentifier] forIndexPath:indexPath];
            SignPushPersonInfoModel *model = (SignPushPersonInfoModel *)self.pushInfoModel.signPersonList[indexPath.row];
            [(SignPreviewOtherInfoCell *)cell setModel:model];
        }
            break;
        case 2:
        {
            if (self.pushInfoModel.remark.length == 0) {
                return cell;
            }
            cell = [tableView dequeueReusableCellWithIdentifier:[SignPreviewRemarkCell cellIdentifier] forIndexPath:indexPath];
            [(SignPreviewRemarkCell *)cell setContentString:self.pushInfoModel.remark];
        }
            break;
        case 3:
        {
            cell = [tableView dequeueReusableCellWithIdentifier:[SignPreviewSignalCell cellIdentifier] forIndexPath:indexPath];
            [(SignPreviewSignalCell *)cell setImageViewWithImageStr:self.pushInfoModel.personSignBase64];
        }
            break;
    }
    return cell;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    if (!self.footerView) {
        self.footerView = [[UIView alloc]initWithFrame:CGRectZero];
    }
    return self.footerView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 10;
}

#pragma mark - UIGestureRecognizerDelegate
- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer {
    _isPopGesture = YES;
//    [self backBtnPressed];
    return YES;
}

@end
