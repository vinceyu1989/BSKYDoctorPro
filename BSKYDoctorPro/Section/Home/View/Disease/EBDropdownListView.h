//
//  EBDropdownList.h
//  DropdownListDemo
//
//  Created by HoYo on 2018/4/17.
//  Copyright © 2018年 HoYo. All rights reserved.
//

#import <UIKit/UIKit.h>

@class EBDropdownListView;

typedef void (^EBDropdownListViewSelectedBlock)(EBDropdownListView *dropdownListView,NSString *selectStr);

@interface EBDropdownListView : UIView
// 字体颜色，默认 blackColor
@property (nonatomic, strong) UIColor *textColor;
// 字体默认14
@property (nonatomic, strong) UIFont *font;
// 数据源
@property (nonatomic, strong) NSArray *dataSource;
// 默认选中第一个
@property (nonatomic, assign) NSUInteger selectedIndex;

- (instancetype)initWithDataSource:(NSArray*)dataSource;

- (void)setViewBorder:(CGFloat)width borderColor:(UIColor*)borderColor cornerRadius:(CGFloat)cornerRadius;

- (void)setDropdownListViewSelectedBlock:(EBDropdownListViewSelectedBlock)block;
@end
