//
//  BSFollowupViewController.m
//  BSKYDoctorPro
//
//  Created by LinfengYU on 2017/8/28.
//  Copyright © 2017年 ky. All rights reserved.
//

#import "BSFollowupViewController.h"
#import "BSFollowupView.h"
#import "BSFollowupCountRequest.h"
#import "BSFollowupListRequest.h"
#import "BSFollowupSearchRequest.h"

#import "BSFollowupListViewController.h"
#import "BSSearchPatientViewController.h"
#import "ZLSearchPersonalVC.h"

@interface BSFollowupViewController () <BSFollowupViewDataSource, BSFollowupViewDelegate>

@property (nonatomic, retain) BSFollowupView *followupView;
@property (nonatomic, copy) NSArray *eventsByDayList;

@property (nonatomic, copy) NSString *currentMonth;

@end

@implementation BSFollowupViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupView];
    
    if (!self.currentMonth) {
        NSString* month = [[NSDateFormatter monthFormatter] stringFromDate:[NSDate date]];
        self.currentMonth = month;
    }
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self loadDataWithMonth:self.currentMonth];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [MBProgressHUD hideHud];
}
#pragma mark -

/**
 加载数据

 @param month 2017-08
 */
- (void)loadDataWithMonth:(NSString*)month {
    WS(weakSelf);
    BSFollowupCountRequest* request = [BSFollowupCountRequest new];
    request.month = month;
    
    [MBProgressHUD showHud];
    [request startWithCompletionBlockWithSuccess:^(BSFollowupCountRequest* request) {
        [MBProgressHUD hideHud];
        weakSelf.eventsByDayList = request.eventsByDayList;
        [weakSelf.followupView reloadData];
    } failure:^(BSFollowupCountRequest* request) {
        [MBProgressHUD hideHud];
        [UIView makeToast:request.msg];
    }];
}

- (void)setupView {
    self.title = @"随访";
    self.view.backgroundColor = UIColorFromRGB(0xffffff);
    
    self.followupView = ({
        BSFollowupView* view = [BSFollowupView new];
        view.dataSource = self;
        view.delegate = self;
        [self.view addSubview:view];
        view;
    });
    [self.followupView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
}

#pragma mark - BSFollowupViewDataSource

- (NSArray *)eventsByDayWithView:(BSFollowupView *)followupView {
    return self.eventsByDayList;
}

#pragma mark - BSFollowupViewDelegate

- (void)didTouchOverFollowup {
    BSFollowupListViewController *vc = [[BSFollowupListViewController alloc]init];
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)didTouchForDate:(NSDate*)date {
    
    BSFollowupListViewController *vc = [[BSFollowupListViewController alloc]init];
    vc.date = date;
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)didChangeMonth:(NSString*)month {
    self.currentMonth = month;
    [self loadDataWithMonth:month];
}

- (void)didTouchCreateDiabetesFollowup {
    
    [self pushSearchPersonalVCWithType:FollowupTypeDiabetes];
}

- (void)didTouchCreateHypertensionFollowup {
    [self pushSearchPersonalVCWithType:FollowupTypeHypertension];
}

- (void)didTouchCreateHighGlucoseFollowup {
    [self pushSearchPersonalVCWithType:FollowupTypeGaoTang];
}

- (void)pushSearchPersonalVCWithType:(FollowupType)type
{
    NSInteger sysType = [BSAppManager sharedInstance].currentUser.sysType.integerValue;
    
    if (sysType == InterfaceServerTypeScwjw) {
        BSSearchPatientViewController *vc = [[BSSearchPatientViewController alloc]init];
        vc.type = type;
        [self.navigationController pushViewController:vc animated:YES];
    }
    else if (sysType == InterfaceServerTypeSczl)
    {
        if (type == FollowupTypeGaoTang) {
            [UIView makeToast:@"该功能暂未开放"];
        }
        else
        {
            ZLSearchPersonalVC *vc = [[ZLSearchPersonalVC alloc]init];
            vc.type = type;
            [self.navigationController pushViewController:vc animated:YES];
        }
    }
}

- (void)didTouchCreateMentalDiseaseFollowup {
    [UIView makeToast:@"该功能暂未开放"];
}

@end
