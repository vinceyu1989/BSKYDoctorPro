//
//  LoginInputView.h
//  Login
//
//  Created by kykj on 2017/8/15.
//  Copyright © 2017年 kykj. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, ButtonLoginType) {
    ButtonLoginSMSType = 0, //验证码(包括签约)
    ButtonLoginPWType     , //密码
};

typedef void(^LoginTypeSelectedCallback)(NSInteger idx);

@interface LoginTypeView : UIView

- (void)setButtonLoginType:(ButtonLoginType)type;
- (void)loginTypeSelectedCallback:(LoginTypeSelectedCallback)callback;

@end
