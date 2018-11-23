//
//  BSHealthTeachVC.m
//  BSKYDoctorPro
//
//  Created by jangry on 2018/7/10.
//  Copyright © 2018年 ky. All rights reserved.
//

#import "BSHealthTeachVC.h"
#import "BSTextField.h"
#import "BRPlaceholderTextView.h"
#import "BSDatePickerView.h"
#import "TeamPickerView.h"
#import "BSSaveEducationModel.h"
#import "ZLDoctorListVC.h"
#import "BSEduTeachModelVC.h"
#import "BSEduHealthSaveRequest.h"

@interface BSHealthTeachVC () <UIGestureRecognizerDelegate,UIAlertViewDelegate>

@property (weak, nonatomic) IBOutlet BSTextField *nameTextF;
@property (weak, nonatomic) IBOutlet BSTextField *doctorTextF;
@property (weak, nonatomic) IBOutlet BSTextField *timeTextF;
@property (weak, nonatomic) IBOutlet BSTextField *teachTypeTextF;
@property (weak, nonatomic) IBOutlet BSTextField *teachModelTextF;
@property (weak, nonatomic) IBOutlet BRPlaceholderTextView *teachContenTextV;

@property (nonatomic, strong) BSEduHealthSaveRequest *saveRequest;
@property (nonatomic, strong) BSSaveEducationModel   *saveModel;

@end

@implementation BSHealthTeachVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initData];
    [self initView];
    // Do any additional setup after loading the view from its nib.
}

- (void)initData {
    self.saveModel = [[BSSaveEducationModel alloc] init];
    self.nameTextF.text = self.model.personName;
    self.doctorTextF.text = [BSAppManager sharedInstance].currentUser.phisInfo.UserName;
    
    self.saveModel.PersonID = self.model.personId;
    self.saveModel.DoctorID = [BSAppManager sharedInstance].currentUser.phisInfo.EmployeeID;
    self.saveModel.SourceRecID = self.model.SourceRecID;
}

- (void)initView {
    self.title = @"健康教育";
    self.nameTextF.enabled = NO;
    self.nameTextF.textColor = UIColorFromRGB(0xcccccc);
    self.nameTextF.moreIcon.hidden = YES;
    Bsky_WeakSelf
    //*<医生 >*/
    self.doctorTextF.tapAcitonBlock = ^{
        Bsky_StrongSelf
        ZLDoctorListVC *vc = [[ZLDoctorListVC alloc] init];
        vc.didSelectBlock = ^(ZLDoctorModel *doctorModel) {
            Bsky_StrongSelf
            self.saveModel.DoctorID = doctorModel.doctorId;
            self.doctorTextF.text = doctorModel.name;
        };
        [self.navigationController pushViewController:vc animated:YES];
    };
    //*<时间 >*/
    self.timeTextF.tapAcitonBlock = ^{
        Bsky_StrongSelf
        [BSDatePickerView showDatePickerWithTitle:@"" dateType:UIDatePickerModeDate defaultSelValue:self.timeTextF.text minDateStr:nil maxDateStr:nil isAutoSelect:NO isDelete:NO resultBlock:^(NSString *selectValue) {
            Bsky_StrongSelf
            self.timeTextF.text = selectValue;
            self.saveModel.ActivityTime = selectValue;
        }];
    };
    //*<类型 >*/
    self.teachTypeTextF.tapAcitonBlock = ^{
        Bsky_StrongSelf
        TeamPickerView *pickerView = [[TeamPickerView alloc] init];
        __block NSMutableArray *arr = [NSMutableArray arrayWithArray:@[@"体检表",@"高血压",@"糖尿病",@"老年人",@"门诊",@"住院",@"脑卒中",@"结核病",@"COPD",@"高糖合并",@"其他"]];
        [pickerView setItems:arr title:@"教育类型" defaultStr:@""];
        pickerView.selectedIndex = ^(NSInteger index)  {
            Bsky_StrongSelf
            self.teachTypeTextF.text = arr[index];
            self.saveModel.BusinessType = [self returnBusinessType:index];
        };
        [pickerView show];
    };
    //*<模板 >*/
    self.teachModelTextF.maxNum = 12;
    self.teachModelTextF.tapAcitonBlock = ^{
        Bsky_StrongSelf
        BSEduTeachModelVC *vc = [[BSEduTeachModelVC alloc] init];
        NSString *title = self.model.businessTypeA.length == 0 ? self.teachTypeTextF.text : self.model.businessTypeA;
        vc.eduTitle = title;
        vc.block = ^(BSEduHealthContentModel *model) {
            Bsky_StrongSelf
            self.teachModelTextF.text = model.Title;
            self.teachContenTextV.text = model.Content;
            self.saveModel.EduContent = model.Content;
        };
        [self.navigationController pushViewController:vc animated:YES];
    };
    
    self.teachContenTextV.placeholder = @"请输入健康教育内容";
//    self.teachContenTextV.text = @"我是健康教育的测试内容，该模板可以有由模块快速选择，也可以手动编辑，也可以在选择模板基础上手动编辑。模板选择后，用户重新选择模块，则新的模块内容将替换旧内容。";
    self.teachContenTextV.returnKeyType = UIReturnKeyDone;
    self.teachContenTextV.keyboardType = UIKeyboardTypeDefault;
    [self.teachContenTextV addMaxTextLengthWithMaxLength:1000 andEvent:^(BRPlaceholderTextView *text) {
        Bsky_StrongSelf
        self.saveModel.EduContent = text.text;
    }];
    [self createRightBtn];
}

- (void)createRightBtn {
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithTitle:@"保存" style:UIBarButtonItemStylePlain target:self action:@selector(saveToRespondse)];
    item.tintColor = [UIColor blackColor];
    self.navigationItem.rightBarButtonItem = item;
}

- (void)saveToRespondse {
    if (![self.saveModel.ActivityTime isNotEmpty]) {
        [UIView makeToast:@"健康教育时间不能为空~"];
    } else if (![self.saveModel.BusinessType isNotEmpty]) {
        [UIView makeToast:@"健康类型不能为空~"];
    } else if (![self.saveModel.EduContent isNotEmpty]) {
        [UIView makeToast:@"健康教育内容不能为空~"];
    } else {
        if (!self.saveRequest) {
            self.saveRequest = [[BSEduHealthSaveRequest alloc] init];
        }
        self.saveRequest.from = [self.saveModel mj_keyValues];
        [MBProgressHUD showHud];
        Bsky_WeakSelf
        [self.saveRequest startWithCompletionBlockWithSuccess:^(__kindof BSEduHealthSaveRequest * _Nonnull request) {
            [MBProgressHUD hideHud];
            [UIView makeToast:request.msg];
            Bsky_StrongSelf
            [self postNotification:kHealthEducationSaveSuccess];
            [self.navigationController popViewControllerAnimated:YES];
        } failure:^(__kindof BSEduHealthSaveRequest * _Nonnull request) {
            [MBProgressHUD hideHud];
            [UIView makeToast:request.msg];
        }];
    }
}

-(NSString *)returnBusinessType:(NSInteger)index {
    if(index < 7) {
        return [NSString stringWithFormat:@"%ld",index];
    }
    switch (index) {
        case 7:
            return @"15";
        case 8:
            return @"16";
        case 9:
            return @"17";
        case 10:
            return @"25";
        default:
            return @"99";
    }
}

#pragma mark - setter
- (void)setModel:(BSEducationModel *)model {
    _model = model;
}

#pragma mark - BackButtonHandlerProtocol
- (void)alterViewAppear{
    UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"确定退出?" message:@"内容尚未保存" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    alertView.tag = 1306;
    [alertView show];
}

-(BOOL)navigationShouldPopOnBackButton {
    [self alterViewAppear];
    return NO;
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (alertView.tag == 1306) {
        switch (buttonIndex) {
            case 0:
                break;
            default: {
                [self.navigationController popViewControllerAnimated:YES];
            }
                break;
        }
    }
}

#pragma mark ------ UIGestureRecognizerDelegate
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
    if ([gestureRecognizer isKindOfClass:[UIScreenEdgePanGestureRecognizer class]] &&
        [otherGestureRecognizer isKindOfClass:NSClassFromString(@"UIScrollViewDelayedTouchesBeganGestureRecognizer")])
    {
        if (self.navigationController != nil) {
            [self alterViewAppear];
            return NO;
        }
    }
    return YES;
}

@end
