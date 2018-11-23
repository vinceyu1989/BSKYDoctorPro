//
//  SignTagServicePackVC.m
//  BSKYDoctorPro
//
//  Created by 何雷 on 2018/1/2.
//  Copyright © 2018年 ky. All rights reserved.
//

#import "SignTagServicePackVC.h"
#import "SignTagPackSectionCell.h"
#import "SignTagPackTagsCell.h"
#import "SignTagPackPackCell.h"
#import "SignServiceDetailViewController.h"
#import "BSSignSVPacksRequest.h"
#import "BSSignTagsReqeust.h"
#import "SignSVPackModel.h"
#import "BSSignLabelModel.h"
#import "SignTagPackPersonInfoCell.h"
#import "BSSignVerificationTagsRequest.h"
#import "BSSignVerificationSVPRequest.h"
#import "ResidentSearchRequest.h"
#import "PersonColligationModel.h"

typedef void(^completeBlock)(BOOL complete);

@interface SignTagServicePackVC ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic ,strong) UITableView *tableView;
@property (nonatomic ,strong) UIView *footerView;
@property (nonatomic ,strong) UIButton *commitBtn;

@property (nonatomic, strong) NSMutableArray *tableData;
@property (nonatomic, strong) NSMutableArray *tagsData;
@property (nonatomic, strong) NSMutableArray *selectTagsArr;
@property (nonatomic, strong) NSMutableArray *selectPackArr;
@property (nonatomic, assign) CGFloat packPrice;

@property (nonatomic, strong) BSSignSVPacksRequest    *serviceRequest;
@property (nonatomic, strong) BSSignTagsReqeust       *tagsRequest;
@property (nonatomic, strong) ResidentSearchRequest   *searchRequest;
@property (nonatomic, strong) PersonColligationModel  *paperModel;

@property (nonatomic, strong) BSSignVerificationSVPRequest  *checkSVPRequest;
@property (nonatomic, strong) BSSignVerificationTagsRequest *checkTagsRequest;

@end

@implementation SignTagServicePackVC

static CGFloat const kSignTagServicePackVCBtnHeight = 45;

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"签约标签及服务包";
    self.selectTagsArr = [NSMutableArray array];
    self.selectPackArr = [NSMutableArray array];
    self.packPrice = 0.0;
    [self.view addSubview:self.tableView];
    [self.view addSubview:self.commitBtn];
    self.serviceRequest = [[BSSignSVPacksRequest alloc] init];
    
    WS(weakSelf);
    [self.serviceRequest startWithCompletionBlockWithSuccess:^(__kindof BSSignSVPacksRequest * _Nonnull request) {
        if (request.packsData.count != 0) {
            weakSelf.tableData = [NSMutableArray arrayWithArray:request.packsData];
            [weakSelf reloadViewData];
        }
    } failure:^(__kindof BSSignSVPacksRequest * _Nonnull request) {
        [UIView makeToast:request.msg];
    }];
    self.searchRequest = [[ResidentSearchRequest alloc] init];
    self.checkSVPRequest = [[BSSignVerificationSVPRequest alloc] init];
    self.checkTagsRequest = [[BSSignVerificationTagsRequest alloc] init];
    self.searchRequest.putModel.keyCode = @"3";
    self.searchRequest.putModel.keyValue = self.code;
    self.searchRequest.putModel.pageSize = @"10";
    self.searchRequest.putModel.pageIndex = @"1";
    [self.searchRequest startWithCompletionBlockWithSuccess:^(__kindof ResidentSearchRequest * _Nonnull request) {
        if (request.dataList.count != 0) {
            weakSelf.paperModel = (PersonColligationModel *)request.dataList[0];
            weakSelf.telPhone = weakSelf.paperModel.telphone;
            [weakSelf reloadViewData];
        }
    } failure:^(__kindof ResidentSearchRequest * _Nonnull request) {
        [UIView makeToast:request.msg];
    }];
    [self getDufaultServerTags];
}
//*<获取人群标签 >/
- (void)getDufaultServerTags {
    self.tagsRequest = [[BSSignTagsReqeust alloc] init];
    Bsky_WeakSelf
    [self.tagsRequest startWithCompletionBlockWithSuccess:^(__kindof BSSignTagsReqeust * _Nonnull request) {
        Bsky_StrongSelf
        if (request.tagsData.count != 0) {
            self.tagsData = [NSMutableArray arrayWithArray:request.tagsData];
            [self reloadViewData];
        }
    } failure:^(__kindof BSSignTagsReqeust * _Nonnull request) {
        [UIView makeToast:request.msg];
    }];
}

- (void)reloadViewData {
    if (self.tagsData.count != 0 && self.tableData.count != 0) {
        if (self.paperModel.name.length != 0 ) {
            [self.tableView reloadData];
        }
    }
}

#pragma mark - btn pressed
- (void)respondsToCommit {
    if (self.selectPackArr.count == 0) {
        [UIView makeToast:@"请选择服务包"];
    } else if (self.selectTagsArr.count == 0) {
        [UIView makeToast:@"请选择人群标签"];
    } else {
        NSString *tags = @"";
        for (int i = 0; i<self.selectTagsArr.count; i++) {
            NSString *temp = [self returnTagWithTag:self.selectTagsArr[i]];
            if (temp.length != 0) {
                tags = tags.length == 0 ? [tags stringByAppendingString:temp] : [tags stringByAppendingString:[NSString stringWithFormat:@",%@",temp]];
            }
        }
        if (tags.length != 0) {
            [self checkTags:tags];
        } else {
            if (self.selectTagsArr.count != 0) {
                if (self.block) {
                    self.block(self);
                }
            }
        }
    }
}

- (void)checkTags:(NSString *)tag {
    self.checkTagsRequest.personId = self.paperModel.idField;
    self.checkTagsRequest.tags = tag;
    WS(weakSelf);
    [MBProgressHUD showHud];
    [self.checkTagsRequest startWithCompletionBlockWithSuccess:^(__kindof BSSignVerificationTagsRequest * _Nonnull request) {
        [MBProgressHUD hideHud];
        if (request.code == 200) {
            if (weakSelf.block) {
                weakSelf.block(weakSelf);
            }
        } else {
            [UIView makeToast:request.msg];
        }
    } failure:^(__kindof BSSignVerificationTagsRequest * _Nonnull request) {
        [MBProgressHUD hideHud];
        [UIView makeToast:request.msg];
    }];
}

- (void)setPaperChechModel:(BSFamilySignInfoModel *)paperChechModel {
    _paperChechModel = paperChechModel;
}
- (void)setEleCheckModel:(SignInfoRequestModel *)eleCheckModel {
    _eleCheckModel = eleCheckModel;
}

- (void)checkServerPacks:(NSString *)serviceId completeBlock:(completeBlock)complete {
    self.checkSVPRequest.personId = self.paperModel.idField;
    self.checkSVPRequest.teamId = [_paperChechModel.teamID isNotEmpty] ? _paperChechModel.teamID : _eleCheckModel.teamId;
    self.checkSVPRequest.servicesId = serviceId;
    self.checkSVPRequest.startTime = [_paperChechModel.startTime isNotEmpty] ? _paperChechModel.startTime : _eleCheckModel.startTime;
    self.checkSVPRequest.endTime = [_paperChechModel.endTime isNotEmpty] ? _paperChechModel.endTime : _eleCheckModel.endTime;
    [MBProgressHUD showHud];
    [self.checkSVPRequest startWithCompletionBlockWithSuccess:^(__kindof BSSignVerificationSVPRequest * _Nonnull request) {
        [MBProgressHUD hideHud];
        if (request.code == 200) {
            complete(YES);
        } else {
            complete(NO);
            [UIView makeToast:request.msg];
        }
    } failure:^(__kindof BSSignVerificationSVPRequest * _Nonnull request) {
        [MBProgressHUD hideHud];
        complete(NO);
        [UIView makeToast:request.msg];
    }];
}

- (NSString *)returnTagWithTag:(BSSignLabelModel *)model {
    NSString *tag = model.dictName;
    if ([tag containsString:@"儿童"]) {
        return @"儿童";
    } else if ([tag containsString:@"老年人"]) {
        return @"老年人";
    } else if ([tag containsString:@"精神病"]) {
        return @"精神病";
    } else if ([tag containsString:@"高血压"]) {
        return @"高血压";
    } else if ([tag containsString:@"糖尿病"]) {
        return @"糖尿病";
    } else if ([tag containsString:@"结核病"]) {
        return @"结核病";
    } else if ([tag containsString:@"孕产妇"]) {
        return @"孕产妇";
    } else {
        return @"";
    }
}

#pragma mark - UITableViewDataSource UITableViewDelegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    switch (section) {
        case 0:
            return 1;
        case 1:
            return 2;
        case 2:
            return self.tableData.count+1;
        default:
            return 0;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = nil;
    if (indexPath.section == 0) {
        cell = [tableView dequeueReusableCellWithIdentifier:[SignTagPackPersonInfoCell cellIdentifier] forIndexPath:indexPath];
        [(SignTagPackPersonInfoCell *)cell setModel:self.paperModel];
    } else if (indexPath.row == 0) {
        cell = [tableView dequeueReusableCellWithIdentifier:[SignTagPackSectionCell cellIdentifier] forIndexPath:indexPath];
        SignTagPackSectionCell *tableCell = (SignTagPackSectionCell *)cell;
        tableCell.titleLabel.text = indexPath.section == 1 ? @"签约人群特征或标签(多选)" : @"签约服务包(多选)";
    } else {
        switch (indexPath.section) {
            case 1: {
                cell = [self tableTagsView:tableView atIndexPath:indexPath];
            }
                break;
            case 2: {
                cell = [self tablePacksView:tableView atIndexPath:indexPath];
            }
                break;
            default:
                break;
        }
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (UITableViewCell *)tableTagsView:(UITableView *)tableView atIndexPath:(NSIndexPath *)indexPath {
    SignTagPackTagsCell *tableCell = [tableView dequeueReusableCellWithIdentifier:[SignTagPackTagsCell cellIdentifier] forIndexPath:indexPath];
    tableCell.tags = self.tagsData;
    WS(weakSelf);
    [tableCell setTagBlock:^(NSInteger index) {
        BSSignLabelModel *model = (BSSignLabelModel *)weakSelf.tagsData[index];
        if (![weakSelf.selectTagsArr containsObject:model]) {
            [weakSelf.selectTagsArr addObject:model];
        } else {
            [weakSelf.selectTagsArr removeObject:model];
        }
    }];
    return tableCell;
}

- (UITableViewCell *)tablePacksView:(UITableView *)tableView atIndexPath:(NSIndexPath *)indexPath {
    SignTagPackPackCell *tableCell = [tableView dequeueReusableCellWithIdentifier:[SignTagPackPackCell cellIdentifier] forIndexPath:indexPath];
    tableCell.model = (SignSVPackModel *)self.tableData[indexPath.row-1];
    BOOL select = [self.selectPackArr containsObject:tableCell.model];
    tableCell.isSelect = select;
    WS(weakSelf);
    [tableCell setPackBlock:^(SignSVPackModel *model) {
        if (tableCell.isSelect == NO) {
            [weakSelf packsTotalPriceWithPrice:model];
        } else {
            [weakSelf checkServerPacks:model.serviceId completeBlock:^(BOOL complete) {
                if (complete == YES) {
                    [weakSelf packsTotalPriceWithPrice:model];
                }
            }];
        }
    }];
    return tableCell;
}

- (void)packsTotalPriceWithPrice:(SignSVPackModel *)model {
    CGFloat price = [model.fee floatValue];
    if (![self.selectPackArr containsObject:model]) {
        self.packPrice += price;
        [self.selectPackArr addObject:model];
    } else {
        self.packPrice = self.packPrice <= 0.0f ? 0.0f : self.packPrice-price;
        [self.selectPackArr removeObject:model];
    }
    [self.tableView reloadData];
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
//*<跳转详情 >/
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    SignServiceDetailViewController *detail_vc = [[SignServiceDetailViewController alloc] init];
    if (indexPath.row -1 >= self.tagsData.count) return;
    SignSVPackModel *model = (SignSVPackModel *)self.tableData[indexPath.row-1];
    detail_vc.model = model;
    [self.navigationController pushViewController:detail_vc animated:YES];
}
#pragma mark - getter  setter
- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, self.view.width, self.view.height-TOP_BAR_HEIGHT-kSignTagServicePackVCBtnHeight-SafeAreaBottomHeight) style:UITableViewStylePlain];
        _tableView.backgroundColor = UIColorFromRGB(0xf7f7f7);
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.estimatedRowHeight = 100;
        _tableView.rowHeight = UITableViewAutomaticDimension;
        _tableView.dataSource = self;
        _tableView.delegate = self;
        [_tableView registerNib:[SignTagPackSectionCell nib] forCellReuseIdentifier:[SignTagPackSectionCell cellIdentifier]];
        [_tableView registerClass:[SignTagPackTagsCell class] forCellReuseIdentifier:[SignTagPackTagsCell cellIdentifier]];
        [_tableView registerNib:[SignTagPackPackCell nib] forCellReuseIdentifier:[SignTagPackPackCell cellIdentifier]];
        [_tableView registerNib:[SignTagPackPersonInfoCell nib] forCellReuseIdentifier:[SignTagPackPersonInfoCell cellIdentifier]];
        
    }
    return _tableView;
}

- (UIButton *)commitBtn {
    if (!_commitBtn) {
        _commitBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _commitBtn.frame = CGRectMake(0, self.view.height - TOP_BAR_HEIGHT - kSignTagServicePackVCBtnHeight - SafeAreaBottomHeight, self.view.width, kSignTagServicePackVCBtnHeight);
        _commitBtn.backgroundColor = UIColorFromRGB(0x4e7dd3);
        _commitBtn.titleLabel.font = [UIFont systemFontOfSize:18];
        [_commitBtn setTitle:@"确定" forState:UIControlStateNormal];
        [_commitBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_commitBtn addTarget:self action:@selector(respondsToCommit) forControlEvents:UIControlEventTouchUpInside];
    }
    return _commitBtn;
}

- (NSMutableArray *)selectPackArray {
    return self.selectPackArr;
}

- (NSMutableArray *)selectTagsArray {
    NSMutableArray *arr = [NSMutableArray arrayWithCapacity:self.selectTagsArr.count];
    for (int i = 0; i<self.selectTagsArr.count; i++) {
        BSSignLabelModel *model = (BSSignLabelModel *)self.selectTagsArr[i];
        [arr addObject:model.dictName];
    }
    return arr;
}

- (CGFloat)packsPrice {
    return self.packPrice;
}

@end
