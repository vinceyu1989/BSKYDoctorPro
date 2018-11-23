//
//  BSDatePickerView.m
//  BSPickerViewDemo
//
//  Created by 任波 on 2017/8/11.
//  Copyright © 2017年 renb. All rights reserved.
//
//  最新代码下载地址：https://github.com/borenfocus/BSPickerView

#import "BSDatePickerView.h"
#import <YYCategories/NSDate+YYAdd.h>

@interface BSDatePickerView ()
{
    UIDatePickerMode _datePickerMode;
    NSString *_title;
    NSString *_minDateStr;
    NSString *_maxDateStr;
    BSDateResultBlock _resultBlock;
    NSString *_selectValue;
    BOOL _isAutoSelect;  // 是否开启自动选择
    BOOL _isDelete;  // 是否有清除功能
    NSDateFormatter *_dateFormatter;
}
// 时间选择器(默认大小: 320px × 216px)
@property (nonatomic, strong) UIDatePicker *datePicker;

@end

@implementation BSDatePickerView

static CGFloat const kDatePickerViewDuration = 0.4;

#pragma mark - 显示时间选择器
+ (void)showDatePickerWithTitle:(NSString *)title dateType:(UIDatePickerMode)type defaultSelValue:(NSString *)defaultSelValue minDateStr:(NSString *)minDateStr maxDateStr:(NSString *)maxDateStr isAutoSelect:(BOOL)isAutoSelect isDelete:(BOOL)isDelete resultBlock:(BSDateResultBlock)resultBlock
{
    BSDatePickerView *datePickerView = [[BSDatePickerView alloc]initWithTitle:title dateType:type defaultSelValue:defaultSelValue minDateStr:(NSString *)minDateStr maxDateStr:(NSString *)maxDateStr isAutoSelect:isAutoSelect isDelete:isDelete resultBlock:resultBlock];
    [datePickerView showWithAnimation:YES];
}

#pragma mark - 初始化时间选择器
- (instancetype)initWithTitle:(NSString *)title dateType:(UIDatePickerMode)type defaultSelValue:(NSString *)defaultSelValue minDateStr:(NSString *)minDateStr maxDateStr:(NSString *)maxDateStr isAutoSelect:(BOOL)isAutoSelect isDelete:(BOOL)isDelete resultBlock:(BSDateResultBlock)resultBlock
{
    if (self = [super init]) {
        _datePickerMode = type;
        _title = title;
        _minDateStr = minDateStr;
        _maxDateStr = maxDateStr;
        _isAutoSelect = isAutoSelect;
        _isDelete = isDelete;
        _resultBlock = resultBlock;
        [self initDateFormatter];
        [self initUI];
        
        // 添加默认值
        NSDate *defaultDate = [_dateFormatter dateFromString:defaultSelValue];
        if (defaultDate) {
            _selectValue = defaultSelValue;
            [self.datePicker setDate:defaultDate animated:YES];
        }
        else
        {
            _selectValue = [self toStringWithDate:[NSDate date]];
            [self.datePicker setDate:[NSDate date] animated:YES];
        }
        if (_isDelete) {
            [self.leftBtn setTitle:@"清除" forState:UIControlStateNormal];
        }
    }
    return self;
}
- (void)dealloc
{
    NSLog(@"-=-=-时间选择控件释放");
}

#pragma mark - 初始化子视图
- (void)initUI {
    [super initUI];
    self.titleLabel.text = _title;
    // 添加时间选择器
    [self.alertView addSubview:self.datePicker];
}

#pragma mark - 时间选择器
- (UIDatePicker *)datePicker {
    if (!_datePicker) {
        _datePicker = [[UIDatePicker alloc]initWithFrame:CGRectMake(0, kTopViewHeight + 0.5,SCREEN_WIDTH, kDatePicHeight)];
        _datePicker.backgroundColor = [UIColor whiteColor];
        _datePicker.datePickerMode = _datePickerMode;
        // 设置该UIDatePicker的国际化Locale，以简体中文习惯显示日期，UIDatePicker控件默认使用iOS系统的国际化Locale
        _datePicker.locale = [[NSLocale alloc]initWithLocaleIdentifier:@"zh_CHS_CN"];
        
        // 设置时间范围
        NSDate *minDate = [_minDateStr isNotEmptyString] ? [_dateFormatter dateFromString:_minDateStr] : [[NSDate date] dateByAddingYears:-2];
        _datePicker.minimumDate = minDate;
        
        NSDate *maxDate = [_maxDateStr isNotEmptyString]  ? [_dateFormatter dateFromString:_maxDateStr] : [[NSDate date] dateByAddingYears:2];
        _datePicker.maximumDate = maxDate;
        
        // 滚动改变值的响应事件
        [_datePicker addTarget:self action:@selector(didSelectValueChanged:) forControlEvents:UIControlEventValueChanged];
    }
    return _datePicker;
}

#pragma mark - 背景视图的点击事件
- (void)didTapBackgroundView:(UITapGestureRecognizer *)sender {
    [self dismissWithAnimation:NO];
}

#pragma mark - 弹出视图方法
- (void)showWithAnimation:(BOOL)animation {
    //1. 获取当前应用的主窗口
    UIWindow *keyWindow = [[UIApplication sharedApplication] keyWindow];
    [keyWindow addSubview:self];
    if (animation) {
        // 动画前初始位置
        CGRect rect = self.alertView.frame;
        rect.origin.y = SCREEN_HEIGHT;
        self.alertView.frame = rect;
        
        // 浮现动画
        [UIView animateWithDuration:kDatePickerViewDuration animations:^{
            CGRect rect = self.alertView.frame;
            rect.origin.y -= kDatePicHeight + kTopViewHeight;
            self.alertView.frame = rect;
            self.backgroundView.backgroundColor = UIColorFromRGBA(0x000000, 0.5);
        }];
    }
}

#pragma mark - 关闭视图方法
- (void)dismissWithAnimation:(BOOL)animation {
    // 关闭动画
    [UIView animateWithDuration:kDatePickerViewDuration animations:^{
        CGRect rect = self.alertView.frame;
        rect.origin.y += kDatePicHeight + kTopViewHeight;
        self.alertView.frame = rect;
        self.backgroundView.backgroundColor = UIColorFromRGBA(0x000000, 0.0);
    } completion:^(BOOL finished) {
        if (_resultBlock) {
            _resultBlock = nil;
        }
        [self.leftBtn removeFromSuperview];
        [self.rightBtn removeFromSuperview];
        [self.titleLabel removeFromSuperview];
        [self.lineView removeFromSuperview];
        [self.topView removeFromSuperview];
        [self.datePicker removeFromSuperview];
        [self.alertView removeFromSuperview];
        [self.backgroundView removeFromSuperview];
        [self removeFromSuperview];
    }];
}

#pragma mark - 时间选择器的滚动响应事件
- (void)didSelectValueChanged:(UIDatePicker *)sender {
    // 读取日期：datePicker.date
    _selectValue = [self toStringWithDate:sender.date];
    // 设置是否开启自动回调
    if (_isAutoSelect) {
        if (_resultBlock) {
            _resultBlock(_selectValue);
        }
    }
}

#pragma mark - 取消按钮的点击事件
- (void)clickLeftBtn {
    if (_isDelete) {
        if (_resultBlock) {
            _resultBlock(nil);
        }
    }
    [self dismissWithAnimation:YES];
}

#pragma mark - 确定按钮的点击事件
- (void)clickRightBtn {
    if (_resultBlock) {
        _resultBlock(_selectValue);
    }
    [self dismissWithAnimation:YES];
}

- (void)initDateFormatter
{
    if (!_dateFormatter) {
        _dateFormatter = [[NSDateFormatter alloc] init];
    }
    switch (_datePickerMode) {
        case UIDatePickerModeTime:
            [_dateFormatter setDateFormat:@"HH:mm"];
            break;
        case UIDatePickerModeDate:
            [_dateFormatter setDateFormat:@"yyyy-MM-dd"];
            break;
        case UIDatePickerModeDateAndTime:
            [_dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm"];
            break;
        case UIDatePickerModeCountDownTimer:
            [_dateFormatter setDateFormat:@"HH:mm"];
            break;
        default:
            break;
    }
    
}

#pragma mark - 格式转换：NSDate --> NSString
- (NSString *)toStringWithDate:(NSDate *)date {
    
    NSString *destDateString = [_dateFormatter stringFromDate:date];
    
    return destDateString;
}

#pragma mark - 格式转换：NSDate <-- NSString
- (NSDate *)toDateWithDateString:(NSString *)dateString {
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    switch (_datePickerMode) {
        case UIDatePickerModeTime:
            [dateFormatter setDateFormat:@"HH:mm"];
            break;
        case UIDatePickerModeDate:
            [dateFormatter setDateFormat:@"yyyy-MM-dd"];
            break;
        case UIDatePickerModeDateAndTime:
            [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm"];
            break;
        case UIDatePickerModeCountDownTimer:
            [dateFormatter setDateFormat:@"HH:mm"];
            break;
        default:
            break;
    }
    NSDate *destDate = [dateFormatter dateFromString:dateString];
    
    return destDate;
}

@end
