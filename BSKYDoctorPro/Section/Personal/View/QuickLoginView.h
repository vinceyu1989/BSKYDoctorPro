//
//  QuickLoginView.h
//  Login
//
//  Created by kykj on 2017/8/15.
//  Copyright © 2017年 kykj. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^GetCodeCallback)(NSString *phoneNum);

@interface QuickLoginView : UIView

- (void)getCodeCallback:(GetCodeCallback)callback;
- (void)cancelTimer;

@property (nonatomic, strong) UITextField *acountT;
@property (nonatomic, strong) UITextField *codeT;

@end
