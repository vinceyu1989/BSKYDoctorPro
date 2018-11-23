//
//  BSShareViewController.m
//  BSKYDoctorPro
//
//  Created by vince on 2018/9/5.
//  Copyright © 2018年 ky. All rights reserved.
//

#import "BSShareViewController.h"
#import <UShareUI/UShareUI.h>

@interface BSShareViewController ()
@property (nonatomic ,strong) UIImageView *imageView;
@end

@implementation BSShareViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self initilationView];
}
- (void)initilationView{
    self.title = @"分享";
    [self.view addSubview:self.imageView];
    [self.imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.right.left.bottom.equalTo(@0);
    }];
}
- (UIImageView *)imageView{
    if (!_imageView) {
        _imageView = [[UIImageView alloc] init];
        int count = arc4random() % 3 + 1;
//        _imageView.backgroundColor = [UIColor redColor];
        _imageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"share_%d",count]];
        _imageView.userInteractionEnabled = YES;
        UITapGestureRecognizer *gesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(shareAction)];
        [_imageView addGestureRecognizer:gesture];
    }
    return _imageView;
}
- (void)shareAction{
    [UMSocialUIManager setPreDefinePlatforms:@[@(UMSocialPlatformType_WechatTimeLine)]];
    Bsky_WeakSelf;
    [UMSocialUIManager showShareMenuViewInWindowWithPlatformSelectionBlock:^(UMSocialPlatformType platformType, NSDictionary *userInfo) {
        // 根据获取的platformType确定所选平台进行下一步操作
        Bsky_StrongSelf;
        [self shareWebPageToPlatformType:platformType];
    }];
}
- (void)shareWebPageToPlatformType:(UMSocialPlatformType)platformType
{
    //创建分享消息对象
    UMSocialMessageObject *messageObject = [UMSocialMessageObject messageObject];
    //创建网页内容对象
//    NSString* thumbURL =  @"https://apissl.jkscw.com.cn/bskyH5/Share/Share.html";
    UMShareWebpageObject *shareObject = [UMShareWebpageObject shareObjectWithTitle:@"巴蜀快医——最好用的公卫移动APP，进来了解一下吧" descr:@"欢迎使用巴蜀快医医护端！" thumImage:nil];
    //设置网页地址
    shareObject.webpageUrl = @"https://apissl.jkscw.com.cn/bskyH5/Share/Share.html";
    shareObject.thumbImage = [UIImage imageNamed:@"logo"];
    //分享消息对象设置分享内容对象
    messageObject.shareObject = shareObject;
    
    //调用分享接口
    [[UMSocialManager defaultManager] shareToPlatform:platformType messageObject:messageObject currentViewController:self completion:^(id data, NSError *error) {
        if (error) {
            UMSocialLogInfo(@"************Share fail with error %@*********",error);
        }else{
            if ([data isKindOfClass:[UMSocialShareResponse class]]) {
                UMSocialShareResponse *resp = data;
                //分享结果消息
                UMSocialLogInfo(@"response message is %@",resp.message);
                //第三方原始返回的数据
                UMSocialLogInfo(@"response originalResponse data is %@",resp.originalResponse);
//                [UIView makeToast:@"分享成功!"];
                if (self.block) {
                    self.block();
                }
            }else{
                UMSocialLogInfo(@"response data is %@",data);
            }
        }
        //        [UIView makeToast:error];
    }];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
