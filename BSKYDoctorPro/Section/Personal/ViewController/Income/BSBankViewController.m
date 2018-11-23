//
//  BSBankViewController.m
//  BSKYDoctorPro
//
//  Created by kykj on 2018/4/9.
//  Copyright © 2018年 ky. All rights reserved.
//

#import "BSBankViewController.h"
#import "BindingCardViewController.h"
#import "BSFindBCardRequest.h"
#import "BSTypeDictionaryRequest.h"
#import "BSBankInfoModel.h"
#import "BSTypeDictionaryModel.h"

@interface BSBankViewController ()

@property (weak, nonatomic) IBOutlet UIView *addBankView;
@property (weak, nonatomic) IBOutlet UIView *bankView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *bankNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *cardLabel;
@property (weak, nonatomic) IBOutlet UIButton *changeBtn;

@property (nonatomic, strong) BSTypeDictionaryRequest *dicTypeRequest;
@property (nonatomic, strong) BSFindBCardRequest      *findCardRequest;
@property (nonatomic, strong) BSBankInfoModel *model;

@end

@implementation BSBankViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initData];
    [self initView];
}

- (void)initData {
    self.title = @"我的银行卡";
    self.dicTypeRequest = [[BSTypeDictionaryRequest alloc] init];
    self.findCardRequest = [[BSFindBCardRequest alloc] init];
    self.model = [[BSBankInfoModel alloc] init];
    [self.changeBtn setCornerRadius:5];
    [self.changeBtn setBorderColor:[UIColor whiteColor] width:1];
    [self getTypeWithBCInfo];
    [self getBCInfoRequest];
}

//*<获取银行卡开户行 >/
- (void)getTypeWithBCInfo {
    __block NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSArray *data =  (NSArray *)[defaults objectForKey:@"payment_virtual_opening_type"];
    if (data && data.count != 0) {
        NSMutableArray*info = [BSTypeDictionaryModel mj_objectArrayWithKeyValuesArray:data];
        for (BSTypeDictionaryModel *type in info) {
            self.model.bankBranch = type.value;
        }
        return;
    }
    
    self.dicTypeRequest.dictTypes = @"payment_virtual_opening_type";
    Bsky_WeakSelf
    [self.dicTypeRequest startWithCompletionBlockWithSuccess:^(__kindof BSTypeDictionaryRequest * _Nonnull request) {
        Bsky_StrongSelf
        if (request.dictTypesData.count != 0) {
            for (BSTypeDictionaryModel *type in request.dictTypesData) {
                self.model.bankBranch = type.value;
            }
            NSMutableArray *arr = [NSMutableArray mj_keyValuesArrayWithObjectArray:request.dictTypesData];
            [defaults setObject:arr forKey:@"payment_virtual_opening_type"];
        }
    } failure:^(__kindof BSTypeDictionaryRequest * _Nonnull request) {
        [UIView makeToast:request.msg];
    }];
}

- (void)getBCInfoRequest {
    WS(weakSelf);
    [self.findCardRequest startWithCompletionBlockWithSuccess:^(__kindof BSFindBCardRequest * _Nonnull request) {
        if (request.model && [request.model.userId isNotEmptyString]) {
            weakSelf.model = request.model;
            [weakSelf refreshView];
        }
    } failure:^(__kindof BSFindBCardRequest * _Nonnull request) {
        [UIView makeToast:request.msg];
    }];
}

- (void)initView {
    [self.addBankView setCornerRadius:7.5];
    [self.addBankView setCornerShadowColor:[UIColor blackColor]
                                   opacity:0.3
                                    offset:CGSizeZero
                                blurRadius:3];
    [self.bankView setCornerRadius:7.5];
    self.addBankView.hidden = NO;
    self.bankView.hidden = YES;
}

- (void)refreshView {
    self.nameLabel.text = self.model.bankOwner;
    self.bankNameLabel.text = self.model.bankBranch;
    self.cardLabel.text = [self stringByAddBlankCharacter:self.model.bankAccount interval:4];
    
    self.addBankView.hidden = YES;
    self.bankView.hidden = NO;
    [self.view layoutIfNeeded];
}

- (NSString *)stringByAddBlankCharacter:(NSString *)str interval:(NSInteger)interval{
    NSInteger index = str.length/interval;
    for (int i = 1; i<=index; i++) {
        NSInteger len = i*interval+i-1;
        NSString *a = [str substringToIndex:len];
        str = [str stringByReplacingOccurrencesOfString:a withString:[NSString stringWithFormat:@"%@ ",a]];
    }
    return str;
}

- (IBAction)respondToAddCard:(id)sender {
    BindingCardViewController *binding_vc = [[BindingCardViewController alloc] init];
    binding_vc.title = @"绑定银行卡";
    [binding_vc setBlcok:^(BindingCardViewController *vc) {
        [vc.navigationController popViewControllerAnimated:YES];
        [self getBCInfoRequest];
    }];
    [self.navigationController pushViewController:binding_vc animated:YES];
}

- (IBAction)respondToChangeBank:(id)sender {
    BindingCardViewController *binding_vc = [[BindingCardViewController alloc] init];
    binding_vc.title = @"修改银行卡";
    binding_vc.model = self.model;
    [binding_vc setBlcok:^(BindingCardViewController *vc) {
        [vc.navigationController popViewControllerAnimated:YES];
        [self getBCInfoRequest];
    }];
    [self.navigationController pushViewController:binding_vc animated:YES];
}


@end
