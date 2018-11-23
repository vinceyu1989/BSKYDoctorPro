//
//  LoginInputView.h
//  Login
//
//  Created by kykj on 2017/8/16.
//  Copyright © 2017年 kykj. All rights reserved.
//

#import <UIKit/UIKit.h>
@class QuickLoginView;
@class PassWordLoginView;

typedef NS_ENUM(NSInteger, LoginType) {
    LoginTypeQuick = 0,
    LoginTypePassWord
    
};

typedef void(^QuickLoginCallback)(NSString *phoneNum, NSString *codeStr);
typedef void(^PassWordLoginCallback)(NSString *phoneNum, NSString *passwordStr);

@interface LoginInputView : UIView

@property (nonatomic, strong) UIScrollView *inputScrollView;
@property (nonatomic, strong) QuickLoginView *quickLoginView;
@property (nonatomic, strong) PassWordLoginView *passwordLoginView;
@property (nonatomic, assign) LoginType loginType;
- (void)qucikLogin:(QuickLoginCallback)callback;
- (void)passwordLogin:(PassWordLoginCallback)callback;
- (void)loginBtnClick;

@end
