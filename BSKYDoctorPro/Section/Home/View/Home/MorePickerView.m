//
//  MorePickerView.m
//  BSKYDoctorPro
//
//  Created by 何雷 on 2017/9/21.
//  Copyright © 2017年 ky. All rights reserved.
//

#import "MorePickerView.h"

@interface MorePickerView ()<UIPickerViewDelegate,UIPickerViewDataSource>

@property (nonatomic ,strong) UIView *contentView;

@property (nonatomic ,copy) NSArray *items;

@property (nonatomic ,strong) NSMutableArray *indexs;

@end

@implementation MorePickerView

static CGFloat const kMorePickerViewCancelBtnWidth = 60;    // Btn 宽度

static CGFloat const kMorePickerContentViewHeight = 258;    // contentView 高度

static CGFloat const kMorePickerViewDuration = 0.4;    // 动画时间

static NSInteger const kMorePickerViewTag = 2000;    // tag 值

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
        self.backgroundColor = RGBA(0, 0, 0, 0);
        self.contentView = [[UIView alloc]initWithFrame:CGRectMake(0, self.height, self.width, kMorePickerContentViewHeight)];
        self.contentView.backgroundColor = [UIColor whiteColor];
        [self addSubview:self.contentView];
        self.indexs = [NSMutableArray array];
    }
    return self;
}
- (void)dealloc
{
    NSLog(@"%@---- 释放了",NSStringFromClass([self class]));
}

- (void)show
{
    [[UIApplication sharedApplication].keyWindow addSubview:self];
    
    [UIView animateWithDuration:kMorePickerViewDuration
                     animations:^{
                         self.backgroundColor = RGBA(0, 0, 0, 0.5);
                         self.contentView.top = self.height-self.contentView.height;
                     }
                     completion:nil];
}

- (void)hide
{
    
    [UIView animateWithDuration:kMorePickerViewDuration animations:^{
        self.backgroundColor = RGBA(0, 0, 0, 0);
        self.contentView.top = self.height;
    } completion:^(BOOL finished) {
        if (self.selectedIndexs) {
            self.selectedIndexs = nil;
        }
        for (UIView *view in self.subviews) {
            [view removeFromSuperview];
        }
        [self removeFromSuperview];
    }];
}
- (void)setItems:(NSArray *)items itemTitles:(NSArray *)itemTitles title:(NSString *)title defaultStrs:(NSArray *)defaultStrs
{
    _items = items;
    
    UIView *header = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.width, 45)];
    
    header.backgroundColor = RGB(240, 240, 240);
    
    UILabel *titleLbl = [[UILabel alloc] initWithFrame:CGRectMake(kMorePickerViewCancelBtnWidth, 0, self.width - 2*kMorePickerViewCancelBtnWidth, header.height)];
    titleLbl.text = title;
    titleLbl.textAlignment = NSTextAlignmentCenter;
    titleLbl.textColor = [UIColor grayColor];
    titleLbl.font = [UIFont systemFontOfSize:16.0];
    [header addSubview:titleLbl];
    
    
    UIButton *submit = [UIButton buttonWithType:UIButtonTypeCustom];
    submit.frame = CGRectMake(self.width - kMorePickerViewCancelBtnWidth, 0, kMorePickerViewCancelBtnWidth ,header.height);
    [submit setTitle:@"确定" forState:UIControlStateNormal];
    [submit setTitleColor:UIColorFromRGB(0x4e7dd3) forState:UIControlStateNormal];
    submit.titleLabel.font = [UIFont systemFontOfSize:16.0];
    submit.titleLabel.textAlignment = NSTextAlignmentCenter;
    [submit addTarget:self action:@selector(submit:) forControlEvents:UIControlEventTouchUpInside];
    [header addSubview:submit];
    
    UIButton *cancel = [UIButton buttonWithType:UIButtonTypeCustom];
    cancel.frame = CGRectMake(0, 0, kMorePickerViewCancelBtnWidth ,header.height);
    [cancel setTitle:@"取消" forState:UIControlStateNormal];
    [cancel setTitleColor:UIColorFromRGB(0x4e7dd3) forState:UIControlStateNormal];
    cancel.titleLabel.font = [UIFont systemFontOfSize:16.0];
    cancel.titleLabel.textAlignment = NSTextAlignmentCenter;
    [cancel addTarget:self action:@selector(cancel:) forControlEvents:UIControlEventTouchUpInside];
    [header addSubview:cancel];
    
    [self.contentView addSubview:header];
    
    CGFloat width = self.width/items.count/3;
    
    for (int i = 0; i<items.count; i++) {
        
        UILabel *itemLabel = [[UILabel alloc]initWithFrame:CGRectMake(width*i*3, 0, width, 100)];
        itemLabel.center = CGPointMake(itemLabel.center.x, (self.contentView.height-header.height)/2+header.height);
        itemLabel.textColor = [UIColor blackColor];
        itemLabel.text = itemTitles[i];
        itemLabel.textAlignment=NSTextAlignmentRight;//文字显示
        itemLabel.font = [UIFont systemFontOfSize:14.0f];
        itemLabel.numberOfLines = 0;
        [self.contentView addSubview:itemLabel];
        
        UIPickerView *pick = [[UIPickerView alloc] initWithFrame:CGRectMake(itemLabel.right, header.height, width, self.contentView.height-header.height)];
        pick.center = CGPointMake(pick.center.x, itemLabel.center.y);
        pick.delegate = self;
        pick.dataSource = self;
        pick.backgroundColor = [UIColor whiteColor];
        pick.tag = kMorePickerViewTag + i;
        [self.contentView addSubview:pick];

        NSString *defaultStr = defaultStrs[i];
        
        if (![defaultStr isNotEmptyString]) {
            [pick selectRow:0 inComponent:0 animated:NO];
            [pick reloadComponent:0];
            [self.indexs addObject:@0];
        }
        else
        {
            for (int i = 0; i<_items.count; i++) {
                NSString *str = _items[i];
                if ([str isEqualToString:defaultStr]) {
                    [pick selectRow:i inComponent:0 animated:NO];
                    [pick reloadComponent:0];
                    [self.indexs addObject:@(i)];
                    break;
                }
            }
        }
    }
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = [touches anyObject];
    CGPoint point = [touch  locationInView:self.contentView];
    BOOL isLocation = CGRectContainsPoint(self.contentView.bounds, point);
    
    if (isLocation) {
        
        [self.nextResponder touchesBegan:touches withEvent:event];
    }
    else
    {
        [self hide];
    }
}

- (void)submit:(UIButton *)btn
{
    NSString *str = @"";
    
    for (int i = 0; i<self.indexs.count; i++) {
        
        NSNumber *num = self.indexs[i];
        NSArray *array = self.items[i];
        
        if (i == 0) {
            str = [NSString stringWithFormat:@"%@",array[num.integerValue]];
        }
        else
        {
            str = [str stringByAppendingString:[NSString stringWithFormat:@"%@%@",kFollowupSeparator,array[num.integerValue]]];
        }
    }
    
    if (self.selectedIndexs) {
        WS(weakSelf);
        self.selectedIndexs(str,weakSelf.indexs);
    }
    [self hide];
}
- (void)cancel:(UIButton *)btn
{
    [self hide];
}

#pragma mark ----  UIPickerViewDataSource

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    NSArray *array = self.items[pickerView.tag - kMorePickerViewTag];
    
    return array.count;
}

-(NSString*)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    NSArray *array = self.items[pickerView.tag - kMorePickerViewTag];
    
    return [array objectAtIndex:row];
    
}
- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view
{
    UILabel *lalTitle=(UILabel *)view;
    if (!lalTitle) {
        lalTitle=[[UILabel alloc] init];
        lalTitle.minimumScaleFactor=8;//设置最小字体，与minimumFontSize相同，minimumFontSize在IOS 6后不能使用。
        lalTitle.adjustsFontSizeToFitWidth=YES;//设置字体大小是否适应lalbel宽度
        lalTitle.textAlignment=NSTextAlignmentCenter;//文字居中显示
        [lalTitle setTextColor:[UIColor blackColor]];
        [lalTitle setFont:[UIFont systemFontOfSize:14.0f]];
    }
    lalTitle.text=[self pickerView:pickerView titleForRow:row forComponent:component];
    return lalTitle;
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
   [self.indexs replaceObjectAtIndex:pickerView.tag - kMorePickerViewTag  withObject:@(row)];
}


@end
