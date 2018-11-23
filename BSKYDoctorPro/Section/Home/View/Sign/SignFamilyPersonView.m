//
//  SignFamilyPersonView.m
//  BSKYDoctorPro
//
//  Created by kykj on 2018/1/4.
//  Copyright © 2018年 ky. All rights reserved.
//

#import "SignFamilyPersonView.h"
#import "SignFamilyPersonShowCell.h"
#import "BSSignFamilyMemberRequest.h"
#import "BSSignCheckSignStatus.h"

@class SignFamilyMembersModel;

typedef void(^completBlock)(BOOL isSign);

@interface SignFamilyPersonView () <UITableViewDelegate, UITableViewDataSource, FamilyPersonShowCellDelegate>

@property (nonatomic, strong) UIView      *maskView;
@property (nonatomic, strong) UIView      *contentView;
@property (nonatomic, strong) UILabel     *titleLabel;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) UIView      *lineView;
@property (nonatomic, strong) UIButton    *cancelBtn;
@property (nonatomic, strong) UIButton    *ensureBtn;

@property (nonatomic, strong) BSSignFamilyMemberRequest *memberRequest;
@property (nonatomic, strong) BSSignCheckSignStatus     *checkStatusRequest;
@property (nonatomic, assign) NSInteger currentIndx;
@property (nonatomic, strong) NSMutableArray *tableData;
@property (nonatomic, strong) NSMutableArray *selectArr;
@property (nonatomic, strong) NSMutableArray *enableArr;
@property (nonatomic, strong) NSMutableArray *selectModelArr;

@end

@implementation SignFamilyPersonView

- (instancetype)init {
    self= [super init];
    if (self) {
        [self initView];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame {
    self= [super initWithFrame:frame];
    if (self) {
        [self initView];
    }
    return self;
}

- (void)initView {
    self.memberRequest = [[BSSignFamilyMemberRequest alloc] init];
    self.checkStatusRequest = [[BSSignCheckSignStatus alloc] init];
    self.currentIndx = 0;
    self.tableData = [NSMutableArray array];
    self.selectArr = [NSMutableArray array];
    self.selectModelArr = [NSMutableArray array];
    self.enableArr = [NSMutableArray array];
    [[UIApplication sharedApplication].keyWindow addSubview:self];
    [self setFrame:[UIScreen mainScreen].bounds];
    
    self.maskView = [[UIView alloc] initWithFrame:self.bounds];
    self.maskView.backgroundColor = [UIColor blackColor];
    self.maskView.alpha = 0.3;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismissView)];
    [self.maskView addGestureRecognizer:tap];
    [self addSubview:self.maskView];
    
    self.contentView = [[UIView alloc] init];
    self.contentView.layer.cornerRadius = 5;
    self.contentView.layer.masksToBounds = YES;
    self.contentView.backgroundColor = [UIColor whiteColor];
    [self addSubview:self.contentView];
    
    self.titleLabel = [[UILabel alloc] init];
    self.titleLabel.text = @"请选择需要签约的对象";
    self.titleLabel.font = [UIFont systemFontOfSize:15];
    self.titleLabel.textColor = [UIColor colorWithHexString:@"#333333"];
    self.titleLabel.textAlignment = NSTextAlignmentCenter;
    [self.contentView addSubview:self.titleLabel];
    
    self.tableView  = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    self.tableView.showsHorizontalScrollIndicator = NO;
    self.tableView.showsVerticalScrollIndicator = NO;
    self.tableView.estimatedRowHeight = 80;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.tableView registerNib:[SignFamilyPersonShowCell nib] forCellReuseIdentifier:[SignFamilyPersonShowCell cellIdentifier]];
    [self.contentView addSubview:self.tableView];
    
    self.cancelBtn = ({
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        [btn setTitle:@"取消" forState:UIControlStateNormal];
        [btn setTitleColor:[UIColor colorWithHexString:@"#4e7dd3"] forState:UIControlStateNormal];
        [btn setTitleColor:[UIColor colorWithHexString:@"#a6bee9"] forState:UIControlStateDisabled];
        [btn.titleLabel setFont:[UIFont systemFontOfSize:18]];
        [btn addTarget:self action:@selector(dismissView) forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:btn];
        btn;
    });
    
    self.ensureBtn = ({
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        [btn setTitle:@"确定" forState:UIControlStateNormal];
        [btn setTitleColor:[UIColor colorWithHexString:@"#4e7dd3"] forState:UIControlStateNormal];
        [btn setTitleColor:[UIColor colorWithHexString:@"#a6bee9"] forState:UIControlStateDisabled];
        [btn.titleLabel setFont:[UIFont systemFontOfSize:18]];
        [btn addTarget:self action:@selector(ensurePressed) forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:btn];
        btn;
    });
    self.lineView = [[UIView alloc] init];
    self.lineView.backgroundColor = [UIColor colorWithHexString:@"#dedede"];
    [self.contentView addSubview:self.lineView];
    [self addContraint];
}

- (void)addContraint {
    [self.contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left).offset(40);
        make.right.equalTo(self.mas_right).offset(-40);
        make.centerY.equalTo(self.mas_centerY);
        make.height.equalTo(@305);
    }];
    
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.contentView);
        make.top.equalTo(self.contentView.mas_top);
        make.height.equalTo(@45);
    }];
    [self addLinesWithTextField:self.titleLabel];

    [self.lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.contentView.mas_bottom).offset(-10);
        make.centerX.equalTo(self.contentView.mas_centerX);
        make.height.equalTo(@20);
        make.width.equalTo(@0.7);
    }];
    
    [self.cancelBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.contentView.mas_bottom);
        make.left.equalTo(self.contentView.mas_left).offset((self.width-80)/4-40);
        make.height.equalTo(@40);
        make.width.equalTo(@80);
    }];
    
    [self.ensureBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.contentView.mas_bottom);
        make.right.equalTo(self.contentView.mas_right).offset(-(self.width-80)/4+40);
        make.height.equalTo(@40);
        make.width.equalTo(@80);
    }];
    
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.contentView);
        make.top.equalTo(self.titleLabel.mas_bottom).offset(0.7);
        make.bottom.equalTo(self.cancelBtn.mas_top).offset(-0.7);
    }];
    [self addLinesWithTextField:self.tableView];
}

- (void)addLinesWithTextField:(UIView *)view {
    UIView*underLine = [[UIView alloc] init];
    underLine.backgroundColor = UIColorFromRGB(0xdedede);
    [self.contentView addSubview:underLine];
    [underLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.left.right.equalTo(view);
        make.height.equalTo(@0.7);
    }];
}

- (void)ensurePressed {
    if (self.selectModelArr.count != 0) {
        if (self.selectModelArr.count > 6) {
            [UIView makeToast:@"一次最多仅能签约6个居民"];
            return;
        }
        if (self.delegate && [self.delegate respondsToSelector:@selector(chooseFamilyPersonNum:)]) {
            [self.delegate chooseFamilyPersonNum:self.selectModelArr];
        }
        [self dismissView];
    } else {
        [UIView makeToast:@"未选择签约居民"];
    }
}

#pragma mark - private
- (void)requestToInfo {
    if (!self.model) {
        return;
    }
    self.memberRequest.familyId = self.model.familyID;
    WS(weakSelf);
    [MBProgressHUD showHud];
    [self.memberRequest startWithCompletionBlockWithSuccess:^(__kindof BSSignFamilyMemberRequest * _Nonnull request) {
        [MBProgressHUD hideHud];
        if (request.familyMembersData.count != 0) {
            weakSelf.tableData = [NSMutableArray arrayWithArray:request.familyMembersData];
            [weakSelf.tableView reloadData];
//            [weakSelf checkSignInfoStatusWithIdcard:request.familyMembersData];
        }
    } failure:^(__kindof BSSignFamilyMemberRequest * _Nonnull request) {
        [MBProgressHUD hideHud];
        [UIView makeToast:request.msg];
    }];
}

- (void)setModel:(SignFamilyArchiveModel *)model {
    _model = model;
    [self requestToInfo];
}

- (void)showView {
    CGAffineTransform translation = CGAffineTransformMakeTranslation(self.width, -self.height);
    CGAffineTransform scaleTranslation = CGAffineTransformScale(translation, 0.6, 0.6);
    self.transform = scaleTranslation;
    [UIView animateWithDuration:0.5 animations:^{
        self.transform = CGAffineTransformIdentity;
    } completion:^(BOOL finished) {
        
    }];
}

- (void)dismissView {
    [UIView animateWithDuration:0.5 animations:^{
        CGAffineTransform translation = CGAffineTransformMakeTranslation(-self.width, self.height);
        CGAffineTransform scaleTranslation = CGAffineTransformScale(translation, 0.6, 0.6);
        self.transform = scaleTranslation;
    } completion:^(BOOL finished) {
        for (UIView *view in self.contentView.subviews) {
            [view removeFromSuperview];
        }
        for (UIView *view in self.subviews) {
            [view removeFromSuperview];
        }
        [self removeFromSuperview];
    }];
    self.checkStatusRequest = nil;
    self.memberRequest = nil;
    if (self.delegate && [self.delegate respondsToSelector:@selector(dismissFamilyView)]) {
        [self.delegate dismissFamilyView];
    }
}

#pragma mark - tableView Delegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.tableData.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:[SignFamilyPersonShowCell cellIdentifier]];
    if (self.tableData.count != 0) {
        SignFamilyPersonShowCell *tabelCell = (SignFamilyPersonShowCell *)cell;
        tabelCell.model = (SignFamilyMembersModel *)self.tableData[indexPath.row];
        tabelCell.delegate = self;
        BOOL ishead = [tabelCell.model.name isEqualToString:self.model.masterName];
        BOOL isSelected = [self.selectArr containsObject:tabelCell.model.personCode];
        cell.tag = 500+indexPath.row;
//        BOOL selectEnable = YES;
//        if (self.checkStatusRequest && self.checkStatusRequest.signStatusArr.count != 0) {
//            SignCheckSignStatusRespondse *check = (SignCheckSignStatusRespondse *)self.checkStatusRequest.signStatusArr[indexPath.row];
//            selectEnable = [check.hasSigned boolValue];
//        }
        [(SignFamilyPersonShowCell *)cell setCellDataWithHead:ishead selectEnable:YES];
        [(SignFamilyPersonShowCell *)cell setIsSelected:isSelected];
    }
    return cell;
}

- (void)isChooseShowCell:(SignFamilyPersonShowCell *)cell {
    if (![self.selectArr containsObject:cell.model.personCode]) {
        [self.selectArr addObject:cell.model.personCode];
        [self.selectModelArr addObject:cell.model];
    } else {
        [self.selectModelArr removeObject:cell.model];
        [self.selectArr removeObject:cell.model.personCode];
    }
    [self.tableView reloadData];
}

- (void)checkSignInfoStatusWithIdcard:(NSArray *)idCardArr {
//    NSString *str = @"";
//    for (int i = 0; i<idCardArr.count; i++) {
//        SignFamilyMembersModel *model = (SignFamilyMembersModel *)idCardArr[i];
//        if (i==0) {
//            str = model.cardID;
//        } else {
//            str = [NSString stringWithFormat:@"%@,%@",str,model.cardID];
//        }
//    }
//    self.checkStatusRequest.cardIds = str;
//    WS(weakSelf);
//    [self.checkStatusRequest startWithCompletionBlockWithSuccess:^(__kindof BSSignCheckSignStatus * _Nonnull request) {
//        [weakSelf.tableView reloadData];
//    } failure:^(__kindof BSSignCheckSignStatus * _Nonnull request) {
//        [UIView makeToast:request.msg];
//    }];
}

@end
