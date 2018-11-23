//
//  ScanViewController.m
//  BSKYDoctorPro
//
//  Created by kykj on 2017/11/29.
//  Copyright © 2017年 ky. All rights reserved.
//

#import "ScanViewController.h"
#import "ZYScanView.h"

@interface ScanViewController () <UINavigationControllerDelegate, UIImagePickerControllerDelegate>

@property (nonatomic, strong) AVCaptureSessionManager *session;
@property (nonatomic, strong) ZYScanView *maskView;

@property (nonatomic, assign) BOOL isHideNavBar;

@end

@implementation ScanViewController

- (void)viewDidLoad{
    [super viewDidLoad];
    [self addInitView];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.isHideNavBar = self.navigationController.navigationBar.hidden;
    [self.navigationController setNavigationBarHidden:NO animated:animated];
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self.navigationController setNavigationBarHidden:self.isHideNavBar animated:animated];
}
- (void)dealloc {
    [self.session stop];
    [self.maskView removeAnimation];
}
#pragma mark - PrivateMethod
- (void)addInitView {
    self.title = @"扫一扫";
    self.view.backgroundColor = [UIColor blackColor];
    self.maskView = [[ZYScanView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    [self.view addSubview:self.maskView];
    [self createRightBtn];
    
    Bsky_WeakSelf
    [AVCaptureSessionManager checkAuthorizationStatusForCameraWithGrantBlock:^{
        Bsky_StrongSelf
        [self getSessionManager];
    } DeniedBlock:^{
        NSString *displayName = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleDisplayName"];
        NSString *message = [NSString stringWithFormat:@"请去-> [设置 - 隐私 - 相机 - %@] 打开访问开关",displayName];
        UIAlertController *alertC = [UIAlertController alertControllerWithTitle:@"温馨提示" message:message preferredStyle:(UIAlertControllerStyleAlert)];
        UIAlertAction *alertA = [UIAlertAction actionWithTitle:@"确定" style:(UIAlertActionStyleDefault) handler:^(UIAlertAction * _Nonnull action) {
            [self.navigationController popViewControllerAnimated:YES];
        }];
        
        [alertC addAction:alertA];
        [self presentViewController:alertC animated:YES completion:nil];
    }];
}

- (void)createRightBtn {
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithTitle:@"相册" style:UIBarButtonItemStylePlain target:self action:@selector(showPhotoLibary)];
    item.tintColor = [UIColor blackColor];
    self.navigationItem.rightBarButtonItem = item;
}
//*<扫码配置 >/
- (void)getSessionManager {
    Bsky_WeakSelf
    self.session = [[AVCaptureSessionManager alloc]initWithAVCaptureQuality:AVCaptureQualityHigh
                                                              AVCaptureType:AVCaptureTypeBoth
                                                                   scanRect:CGRectNull
                                                               successBlock:^(NSString *reuslt) {
                                                                   Bsky_StrongSelf
                                                                   if (self.block) {
                                                                       self.block(self, reuslt);
                                                                   }
                                                               }];
    self.session.isPlaySound = NO;
    [self.session showPreviewLayerInView:self.maskView];
    self.view.backgroundColor = [UIColor clearColor];
    [self.session start];
}

- (void)showPhotoLibary {
    Bsky_WeakSelf
    [AVCaptureSessionManager checkAuthorizationStatusForPhotoLibraryWithGrantBlock:^{
        Bsky_StrongSelf
        UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
        imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary; //（选择类型）表示仅仅从相册中选取照片
        imagePicker.delegate = self;
        [self presentViewController:imagePicker animated:YES completion:nil];
    } DeniedBlock:^{
        NSString *displayName = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleDisplayName"];
        NSString *message = [NSString stringWithFormat:@"请去-> [设置 - 隐私 - 照片 - %@] 打开访问开关",displayName];
        UIAlertController *alertC = [UIAlertController alertControllerWithTitle:@"温馨提示" message:message preferredStyle:(UIAlertControllerStyleAlert)];
        UIAlertAction *alertA = [UIAlertAction actionWithTitle:@"确定" style:(UIAlertActionStyleDefault) handler:^(UIAlertAction * _Nonnull action) {
            
        }];
        
        [alertC addAction:alertA];
        [self presentViewController:alertC animated:YES completion:nil];
    }];
}

#pragma mark -  imagePickerDelegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info {
    Bsky_WeakSelf
    [self dismissViewControllerAnimated:YES completion:^{
        [self.session start];
        Bsky_StrongSelf
        [self.session scanPhotoWith:[info objectForKey:@"UIImagePickerControllerOriginalImage"] successBlock:^(NSString *reuslt) {
            Bsky_StrongSelf
            if (reuslt.length != 0) {
                if (self.block) {
                    self.block(self, reuslt);
                }
            } else {
                [self showResult:@"没有识别到二维码"];
            }
        }];
    }];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [self.session start];
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)showResult:(NSString *)result {
    UIAlertView *view = [[UIAlertView alloc]initWithTitle:@"扫描结果" message:result delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
    [view show];
}

//- (void)changeTorchState:(id)sender {
//    self.TorchState = !self.TorchState;
//    NSString *str = self.TorchState ? @"关闭闪光灯" : @"打开闪光灯";
//    [((UIButton *)sender) setTitle:str forState:UIControlStateNormal];
//    [self.session turnTorch:self.TorchState];
//}

@end
