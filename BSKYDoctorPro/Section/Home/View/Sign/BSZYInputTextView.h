//
//  BSZYInputTextView.h
//  BSKYDoctorPro
//
//  Created by kykj on 2017/12/27.
//  Copyright © 2017年 ky. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^TextViewReturnBlock)(NSString *text);
@interface BSZYInputTextView : UIView

@property (nonatomic, strong) NSString *titleStr;

@property (nonatomic, copy) TextViewReturnBlock block;

@end
