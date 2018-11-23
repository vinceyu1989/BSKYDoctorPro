//
//  BRTextField.h
//  BRPickerViewDemo
//
//  Created by 任波 on 2017/8/11.
//  Copyright © 2017年 renb. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^BSTapAcitonBlock)(void);

typedef void(^BSEndEditBlock)(NSString *text);

@interface BSTextField : UITextField
/** textField 的点击回调 */
@property (nonatomic, copy) BSTapAcitonBlock tapAcitonBlock;
/** textField 结束编辑的回调 */
@property (nonatomic, copy) BSEndEditBlock endEditBlock;

@property (nonatomic ,strong) UIImageView *moreIcon;

@property (nonatomic ,assign) NSInteger pointNum;   // 小数点后几位有效 默认-1

@property (nonatomic ,assign) NSInteger maxNum;    // 最长输入字数长度

@property (nonatomic, copy) NSString * regularStr;  // 自定义正则表达式

@property (nonatomic, copy) NSString * toastStr;   // 不符合的提示语

@end
