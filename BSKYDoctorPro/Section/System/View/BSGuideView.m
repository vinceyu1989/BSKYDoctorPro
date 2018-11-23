//
//  BSGuideViewController.m
//  BSKYDoctorPro
//
//  Created by vince on 2018/9/5.
//  Copyright © 2018年 ky. All rights reserved.
//

#import "BSGuideView.h"
#import "BSShareViewController.h"

@interface BSGuideView ()<UIScrollViewDelegate>
@property (nonatomic ,strong) UIScrollView *scrollView;
@property (nonatomic ,strong) BSShareViewController *shareController;
@property (nonatomic ,strong) UIButton *cancleBtn;
@end

@implementation BSGuideView

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self setFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight)];
        self.backgroundColor = [UIColor whiteColor];
        [self initilationUI];
        
//        self.userInteractionEnabled = NO;
    }
    return self;
}
- (void)initilationUI{
    [self addSubview:self.scrollView];
    [self.scrollView setFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight)];
    for (int i = 0 ; i < 2     ; i ++) {
        UIImageView *view = [[UIImageView alloc] init];
        [view setImage:[UIImage imageNamed:[NSString stringWithFormat:@"guide_%d",i]]];
        [self.scrollView addSubview:view];
        [view setFrame:CGRectMake(kScreenWidth * i, 0, kScreenWidth, kScreenHeight)];
    }
//    [self.scrollView addSubview:self.shareController.view];
//    [self.shareController.view setFrame:CGRectMake(self.width * 2, 0, self.width, self.height)];
    [self.scrollView setContentSize:CGSizeMake(kScreenWidth * 2, kScreenHeight)];
    [self addSubview:self.cancleBtn];
}
- (UIScrollView *)scrollView{
    if (!_scrollView) {
        _scrollView = [[UIScrollView alloc] init];
        _scrollView.pagingEnabled = YES;
        _scrollView.delegate = self;
    }
    return _scrollView;
}
- (void)hiddeGuideView{
    if (self.block) {
        self.block();
    }
    [self removeFromSuperview];
}
- (BSShareViewController *)shareController{
    if (!_shareController) {
        _shareController = [[BSShareViewController alloc] init];
        [_shareController.view setFrame:CGRectMake(0, 0, self.width, self.height)];
        Bsky_WeakSelf;
        _shareController.block = ^{
            Bsky_StrongSelf;
            [self hiddeGuideView];
        };
    }
    return _shareController;
}
- (UIButton *)cancleBtn{
    if (!_cancleBtn) {
        UIView *view = [[UIView alloc] init];
        view.backgroundColor = [UIColor blackColor];
        view.alpha = 0.4;
        view.layer.cornerRadius = 6;
        [view setFrame:CGRectMake(kScreenWidth - 30 - 20, 30, 40,25)];
        [self addSubview:view];
        _cancleBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_cancleBtn setFrame:CGRectMake(kScreenWidth - 30 - 20, 30, 40,25)];
        
        [_cancleBtn setTitle:@"关闭" forState:UIControlStateNormal];
        _cancleBtn.titleLabel.font = [UIFont systemFontOfSize:14];
        [_cancleBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_cancleBtn addTarget:self action:@selector(hiddeGuideView) forControlEvents:UIControlEventTouchUpInside];
//        [_cancleBtn sizeToFit];
    }
    return _cancleBtn;
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
#pragma mark ScrollViewDelegate
- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView{
    
}
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
    if (scrollView.contentOffset.x >= scrollView.contentSize.width - kScreenWidth + 20) {
        [self hiddeGuideView];
    }
}
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    
}
@end
