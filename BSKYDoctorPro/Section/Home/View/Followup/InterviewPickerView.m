//
//  InterviewPickerView.m
//  BSKYDoctorPro
//
//  Created by 何雷 on 2017/9/6.
//  Copyright © 2017年 ky. All rights reserved.
//

#import "InterviewPickerView.h"

@interface InterviewPickerView()<UIPickerViewDelegate,UIPickerViewDataSource>

@property (nonatomic ,strong) UIView *contentView;

@property (nonatomic ,assign) NSInteger index;

@property (nonatomic ,strong) NSMutableArray *pickerItems;

@property (nonatomic ,strong) NSMutableArray *selectItems;

@end

@implementation InterviewPickerView

static CGFloat const kInterviewPickerViewCancelBtnWidth = 60;    // 列

static CGFloat const kInterviewPickerViewDuration = 0.4;    // 

static CGFloat const kInterviewPickerContentViewHeight = 258;    // contentView 高度

static NSInteger const kInterviewPickerTag = 900;    // 列

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
        self.backgroundColor = RGBA(0, 0, 0, 0);
        self.pickerItems = [NSMutableArray array];
        self.selectItems = [NSMutableArray array];
        self.contentView = [[UIView alloc]initWithFrame:CGRectMake(0, self.height, self.width, kInterviewPickerContentViewHeight)];
        self.contentView.backgroundColor = [UIColor whiteColor];
        [self addSubview:self.contentView];
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
    
    [UIView animateWithDuration:kInterviewPickerViewDuration
                     animations:^{
                         self.backgroundColor = RGBA(0, 0, 0, 0.5);
                         self.contentView.top = self.height-self.contentView.height;
                     }
                     completion:nil];
}

- (void)hide
{
    [UIView animateWithDuration:kInterviewPickerViewDuration animations:^{
        self.backgroundColor = RGBA(0, 0, 0, 0);
        self.contentView.top = self.height;
    } completion:^(BOOL finished) {
        if (self.selectedComplete) {
            self.selectedComplete = nil;
        }
        for (UIView *view in self.subviews) {
            [view removeFromSuperview];
        }
        
        [self removeFromSuperview];
    }];
}
- (void)setItems:(NSArray *)items
{
    _items = items;
    
    UIView *header = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.width, 45)];
    
    header.backgroundColor = RGB(240, 240, 240);
    
    UIButton *submit = [UIButton buttonWithType:UIButtonTypeCustom];
    submit.frame = CGRectMake(self.width - kInterviewPickerViewCancelBtnWidth, 0, kInterviewPickerViewCancelBtnWidth ,header.height);
    [submit setTitle:@"确定" forState:UIControlStateNormal];
    [submit setTitleColor:UIColorFromRGB(0x4e7dd3) forState:UIControlStateNormal];
    submit.titleLabel.font = [UIFont systemFontOfSize:16.0];
    submit.titleLabel.textAlignment = NSTextAlignmentCenter;
    [submit addTarget:self action:@selector(submit:) forControlEvents:UIControlEventTouchUpInside];
    [header addSubview:submit];
    
    UIButton *cancel = [UIButton buttonWithType:UIButtonTypeCustom];
    cancel.frame = CGRectMake(0, 0, kInterviewPickerViewCancelBtnWidth ,header.height);
    [cancel setTitle:@"取消" forState:UIControlStateNormal];
    [cancel setTitleColor:UIColorFromRGB(0x4e7dd3) forState:UIControlStateNormal];
    cancel.titleLabel.font = [UIFont systemFontOfSize:16.0];
    cancel.titleLabel.textAlignment = NSTextAlignmentCenter;
    [cancel addTarget:self action:@selector(remove:) forControlEvents:UIControlEventTouchUpInside];
    [header addSubview:cancel];
    
    [self.contentView addSubview:header];
    
    CGFloat width = self.width/_items.count/3;
    
    for (int i = 0; i<_items.count; i++) {
        
        InterviewPickerModel *model = _items[i];
        
        UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(width*i*3, 0, width, 100)];
        titleLabel.center = CGPointMake(titleLabel.center.x, (self.contentView.height-header.height)/2+header.height);
        titleLabel.textColor = [UIColor blackColor];
        titleLabel.text = model.title;
        titleLabel.textAlignment=NSTextAlignmentRight;//文字居中显示
        titleLabel.font = [UIFont systemFontOfSize:14.0f];
        titleLabel.numberOfLines = 0;
        [self.contentView addSubview:titleLabel];
        
        UIPickerView *pick = [[UIPickerView alloc] initWithFrame:CGRectMake(titleLabel.right, header.height, width, self.contentView.height-header.height)];
        pick.center = CGPointMake(pick.center.x, titleLabel.center.y);
        pick.delegate = self;
        pick.dataSource = self;
        pick.backgroundColor = [UIColor whiteColor];
        pick.tag = kInterviewPickerTag + i;
        [self.contentView addSubview:pick];
        
        UILabel *unitLabel = [[UILabel alloc]initWithFrame:CGRectMake(pick.right, 0, width, 100)];
        unitLabel.center = CGPointMake(unitLabel.center.x,titleLabel.center.y);
        unitLabel.textColor = [UIColor blackColor];
        unitLabel.text = model.unit;
        unitLabel.textAlignment=NSTextAlignmentLeft;//文字居中显示
        unitLabel.font = [UIFont systemFontOfSize:14.0f];
        unitLabel.numberOfLines = 0;
        [self.contentView addSubview:unitLabel];
        
        NSMutableArray *array = [NSMutableArray array];
        
        for (NSInteger n = model.min; n<= model.max; n+=model.multiple) {
            
            CGFloat num = n/(CGFloat)model.point;
            
            NSString *str = nil;
            
            if (model.point >= 1 && model.point < 10) {
                
                str = [NSString stringWithFormat:@"%d",(int)num];
            }
            else if (model.point >= 10 && model.point < 100)
            {
                str = [NSString stringWithFormat:@"%.1f",num];
            }
            else if (model.point >= 100 && model.point < 1000)
            {
                str = [NSString stringWithFormat:@"%.2f",num];
            }
            else if (model.point >= 1000 && model.point < 10000)
            {
                str = [NSString stringWithFormat:@"%.3f",num];
            }
            else if (model.point >= 10000 && model.point < 100000)
            {
                str = [NSString stringWithFormat:@"%.4f",num];
            }
            else
            {
                str = [NSString stringWithFormat:@"%f",num];
            }
            [array addObject:str];
        }
        [self.pickerItems addObject:array];

        BOOL isHave = NO;
        for (int i = 0; i<array.count; i++) {
            NSString *str = array[i];
            if ([str isEqualToString:model.content]) {
                [pick selectRow:i inComponent:0 animated:NO];
                [self.selectItems addObject:array[i]];
                isHave = YES;
                break;
            }
        }
        if (!isHave) {
            [self.selectItems addObject:array[array.count/2]];
            [pick selectRow:array.count/2 inComponent:0 animated:NO];
        }
        [pick reloadComponent:0];
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
    
    for (int i = 0; i<self.items.count; i++) {
        InterviewPickerModel *model = self.items[i];
        model.content = self.selectItems[i];
        if (i == 0) {
//            str =  [NSString stringWithFormat:@"%@%@",model.content,model.unit];
            str =  model.content;
        }
        else
        {
//            str = [str stringByAppendingString:[NSString stringWithFormat:@" | %@%@",model.content,model.unit]];
            str = [str stringByAppendingString:[NSString stringWithFormat:@"%@%@",kFollowupSeparator,model.content]];
        }
    }
    WS(weakSelf);
    if (self.selectedComplete) {
        self.selectedComplete(str,weakSelf.selectItems);
    }
    [self hide];
}
- (void)remove:(UIButton *)btn
{
//    for (int i = 0; i<self.items.count; i++) {
//
//        [self.selectItems replaceObjectAtIndex:i withObject:@""];
//
//        InterviewPickerModel *model = self.items[i];
//        model.content = self.selectItems[i];
//    }
//    NSString *str = @"";
//    if (self.selectedComplete) {
//        self.selectedComplete(str,self.selectItems);
//    }
    [self hide];
}

#pragma mark ----  UIPickerViewDataSource

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    NSInteger index = pickerView.tag - kInterviewPickerTag;
    
    NSMutableArray *array = self.pickerItems[index];
    
    return array.count;
}

-(NSString*)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    NSInteger index = pickerView.tag - kInterviewPickerTag;
    
    NSMutableArray *array = self.pickerItems[index];
    
    return array[row];

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
    NSInteger index = pickerView.tag - kInterviewPickerTag;
    
    NSMutableArray *array = self.pickerItems[index];
    
    [self.selectItems replaceObjectAtIndex:index withObject:array[row]];
}

@end
