//
//  PlaceholderTextView.h
//  SaleHelper
//
//  Created by gitBurning on 14/12/8.
//  Copyright (c) 2014年 Burning_git. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^TextViewTextLengthBlock)(NSInteger num);

@interface BRPlaceholderTextView : UITextView

@property(copy,nonatomic)   NSString *placeholder;

//最大长度设置
@property(assign,nonatomic) NSInteger maxTextLength;

//更新高度的时候
@property(assign,nonatomic) float updateHeight;

@property (nonatomic, copy) TextViewTextLengthBlock lengthBlcok;
/**
 *  增加text 长度限制
 *
 *  @param maxLength 长度
 *  @param limit     事件
 */
-(void)addMaxTextLengthWithMaxLength:(NSInteger)maxLength andEvent:(void(^)(BRPlaceholderTextView*text))limit;

@end
