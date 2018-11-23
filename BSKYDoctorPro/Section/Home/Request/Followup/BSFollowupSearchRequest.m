//
//  BSFollowupSearchRequest.m
//  BSKYDoctorPro
//
//  Created by LinfengYU on 2017/8/29.
//  Copyright © 2017年 ky. All rights reserved.
//

#import "BSFollowupSearchRequest.h"

@implementation BSFollowupSearchRequest

//- (instancetype)init
//{
//    self = [super init];
//    if (self) {
//        BskyProgressHUD *hud = [[BskyProgressHUD alloc]init];
//        Bsky_WeakSelf
//        hud.tapBlock = ^{
//            Bsky_StrongSelf
//            [self stop];
//        };
//        [self addAccessory:hud];
//    }
//    return self;
//}

- (NSString*)bs_requestUrl {
    
   return @"/doctor/followup/userplus";
}

- (YTKRequestMethod)requestMethod {
    return YTKRequestMethodGET;
}

- (id)requestArgument {
    return @{@"search":[self.key encryptCBCStr],
             @"pageIndex": self.pageIndex,
             @"pageSize": self.pageSize};
}

- (void)requestCompleteFilter {
    [super requestCompleteFilter];
    self.dataList = [FollowupUserSearchModel mj_objectArrayWithKeyValuesArray:self.ret];
    [self.dataList decryptArray];
}

- (void)requestFailedFilter {
    [super requestFailedFilter];
    
}

@end

@interface BskyProgressHUD()

@property (nonatomic, assign) BOOL animated;

@property (nonatomic, strong) UITapGestureRecognizer *tap;

@property (nonatomic, copy) YTKRequestCompletionBlock failureCompletionBlock;

@end

@implementation BskyProgressHUD

- (void)dealloc
{
    NSLog(@"hud释放啦-=-=-=-=-=-=-=");
}

- (void)showHud {
    
    UIView* view = [UIApplication sharedApplication].keyWindow;
    if (!self.tap) {
        self.tap = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                           action:@selector(tapGestureHandler:)];
    }
    [view addGestureRecognizer:self.tap];
    [MBProgressHUD showHudInView:view];
}

- (void)showHudInView:(UIView*)view {
    for (UIView *hudView in view.subviews) {
        if ([hudView isKindOfClass:[MBProgressHUD class]]) {
            for (UIView *subView in hudView.subviews) {
                [subView removeFromSuperview];
            }
            [hudView removeFromSuperview];
        }
    }
    MBProgressHUD *hud = [[MBProgressHUD alloc] initWithView:view];
    hud.mode = MBProgressHUDModeCustomView;
    hud.bezelView.backgroundColor = [UIColor redColor];
    hud.square = YES;
    hud.bezelView.layer.cornerRadius = 15;
    hud.bezelView.color = RGBA(0, 0, 0, 0.3);
    hud.bezelView.style = MBProgressHUDBackgroundStyleSolidColor;
    hud.margin = 15;
    
    UIImageView* imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"loading_bg"]];
    UIImageView* rotateImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"loading_rotate"]];
    rotateImageView.frame = imageView.bounds;
    rotateImageView.contentMode = UIViewContentModeCenter;
    [imageView addSubview:rotateImageView];
    
    hud.customView = imageView;
    
    self.animated = YES;
    [self rotate:rotateImageView];
    
    [view addSubview:hud];
    [hud showAnimated:YES];
}

- (void)hideHud {
    UIView* view = [UIApplication sharedApplication].keyWindow;
    [view removeGestureRecognizer:self.tap];
    self.animated = NO;
    [MBProgressHUD hideHUDForView:view animated:YES];
}

- (void)rotate:(UIView*)view {
    Bsky_WeakSelf
    [UIView animateWithDuration:.3f
                          delay:0
                        options:UIViewAnimationOptionCurveLinear | UIViewAnimationOptionRepeat
                     animations:^{
                         view.transform = CGAffineTransformRotate(view.transform, M_PI_2);
                     }
                     completion:^(BOOL finished){
                         Bsky_StrongSelf
                         if (finished) {
                             if (self.animated) {
                                 [self rotate:view];
                             }
                         }
                     }];
}

- (void)tapGestureHandler:(UITapGestureRecognizer *)sender {
    if (sender.state == UIGestureRecognizerStateEnded) {
        if (self.tapBlock) {
            self.tapBlock();
        }
    }
}
- (void)requestWillStart:(id)request
{
    self.failureCompletionBlock = ((BSBaseRequest *)request).failureCompletionBlock;
    dispatch_async(dispatch_get_main_queue(), ^{
        [self showHud];
    });
}
- (void)requestWillStop:(id)request
{
    dispatch_async(dispatch_get_main_queue(), ^{
        [self hideHud];
    });
}
- (void)requestDidStop:(id)request
{
    BSBaseRequest *tempRequest = (BSBaseRequest *)request;
    if (tempRequest.isCancelled) {
        tempRequest.failureCompletionBlock = self.failureCompletionBlock;
        tempRequest.failureCompletionBlock(tempRequest);
    }
    if (tempRequest.code != 200) {
        [UIView makeToast:tempRequest.msg];
    }
}

@end


