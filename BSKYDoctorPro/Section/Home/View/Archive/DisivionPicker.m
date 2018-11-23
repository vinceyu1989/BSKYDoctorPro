//
//  DisivionPicker.m
//  BSKYDoctorPro
//
//  Created by 快医科技 on 2018/1/17.
//  Copyright © 2018年 ky. All rights reserved.
//

#import "DisivionPicker.h"
#import "ArchiveDivisionModel.h"

@interface DisivionPicker ()
@property (nonatomic ,strong) UIView *contentView;

@property (nonatomic ,copy) NSArray *items;

@property (nonatomic ,assign) NSInteger index;
@property (nonatomic ,assign) NSInteger firstIndex;
@property (nonatomic ,strong) ArchiveDivisionModel *model;
@end

@implementation DisivionPicker

static CGFloat const kTeamPickerViewCancelBtnWidth = 60;    // Btn 宽度

static CGFloat const kTeamPickerContentViewHeight = 258;    // contentView 高度

static CGFloat const kTeamPickerViewDuration = 0.4;    // 动画时间

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
        self.backgroundColor = RGBA(0, 0, 0, 0);
        
        self.contentView = [[UIView alloc]initWithFrame:CGRectMake(0, self.height, self.width, kTeamPickerContentViewHeight)];
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
    
    [UIView animateWithDuration:kTeamPickerViewDuration
                     animations:^{
                         self.backgroundColor = RGBA(0, 0, 0, 0.5);
                         self.contentView.top = self.height-self.contentView.height;
                     }
                     completion:nil];
}

- (void)hide
{
    
    [UIView animateWithDuration:kTeamPickerViewDuration animations:^{
        self.backgroundColor = RGBA(0, 0, 0, 0);
        self.contentView.top = self.height;
    } completion:^(BOOL finished) {
        if (self.selectedIndex) {
            self.selectedIndex = nil;
        }
        for (UIView *view in self.subviews) {
            [view removeFromSuperview];
        }
        
        [self removeFromSuperview];
    }];
}
- (void)setItems:(NSArray *)items title:(NSString *)title defaultStr:(NSString *)defaultStr
{
    _items = items;
    
    _firstIndex = 0;
    ArchiveDivisionModel *model = self.items[_firstIndex];
    ArchiveDivisionModel *subModel = [model.children objectAtIndex:0];
    self.model = subModel;
    
    UIView *header = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.width, 45)];
    
    header.backgroundColor = RGB(240, 240, 240);
    
    UILabel *titleLbl = [[UILabel alloc] initWithFrame:CGRectMake(kTeamPickerViewCancelBtnWidth, 0, self.width - 2*kTeamPickerViewCancelBtnWidth, header.height)];
    titleLbl.text = title;
    titleLbl.textAlignment = NSTextAlignmentCenter;
    titleLbl.textColor = [UIColor grayColor];
    titleLbl.font = [UIFont systemFontOfSize:16.0];
    [header addSubview:titleLbl];
    
    
    UIButton *submit = [UIButton buttonWithType:UIButtonTypeCustom];
    submit.frame = CGRectMake(self.width - kTeamPickerViewCancelBtnWidth, 0, kTeamPickerViewCancelBtnWidth ,header.height);
    [submit setTitle:@"确定" forState:UIControlStateNormal];
    [submit setTitleColor:UIColorFromRGB(0x4e7dd3) forState:UIControlStateNormal];
    submit.titleLabel.font = [UIFont systemFontOfSize:16.0];
    submit.titleLabel.textAlignment = NSTextAlignmentCenter;
    [submit addTarget:self action:@selector(submit:) forControlEvents:UIControlEventTouchUpInside];
    [header addSubview:submit];
    
    UIButton *cancel = [UIButton buttonWithType:UIButtonTypeCustom];
    cancel.frame = CGRectMake(0, 0, kTeamPickerViewCancelBtnWidth ,header.height);
    [cancel setTitle:@"取消" forState:UIControlStateNormal];
    [cancel setTitleColor:UIColorFromRGB(0x4e7dd3) forState:UIControlStateNormal];
    cancel.titleLabel.font = [UIFont systemFontOfSize:16.0];
    cancel.titleLabel.textAlignment = NSTextAlignmentCenter;
    [cancel addTarget:self action:@selector(cancel:) forControlEvents:UIControlEventTouchUpInside];
    [header addSubview:cancel];
    
    [self.contentView addSubview:header];
    
    
    UIPickerView *pick = [[UIPickerView alloc] initWithFrame:CGRectMake(0, header.height, self.width, self.contentView.height-header.height)];
    pick.center = CGPointMake(pick.center.x, (self.contentView.height-header.height)/2+header.height);
    pick.delegate = self;
    pick.dataSource = self;
    pick.backgroundColor = [UIColor whiteColor];
    [self.contentView addSubview:pick];
    
//    BOOL isHave = NO;
//    for (int i = 0; i<_items.count; i++) {
//        NSString *str = _items[i];
//        if ([str isEqualToString:defaultStr]) {
//            [pick selectRow:i inComponent:0 animated:NO];
//            isHave = YES;
//            break;
//        }
//    }
//    if (!isHave) {
//        [pick selectRow:0 inComponent:0 animated:NO];
//    }
    [pick reloadComponent:0];
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
    if (self.selectedIndex) {
        
//        WS(weakSelf);
        self.selectedIndex(self.firstIndex,self.index);
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
    return 2;
}
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    if (component == 0) {
        return self.items.count;
    }else{
        ArchiveDivisionModel *model = self.items[_firstIndex];
        return model.children.count;
    }
    
}
- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component{
   
    if (component == 0) {
         _firstIndex = row;
        [pickerView reloadComponent:1];
        [pickerView selectRow:0 inComponent:1 animated:NO];
    }else if (component == 1){
        ArchiveDivisionModel *model = self.items[_firstIndex];
        ArchiveDivisionModel *subModel = [model.children objectAtIndex:row];
        self.index = row;
        self.model = subModel;
    }
}
-(NSString*)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    
    if (!component) {
        ArchiveDivisionModel *model = self.items[row];
        return model.divisionName;
    }else{
        ArchiveDivisionModel *model = self.items[_firstIndex];
        ArchiveDivisionModel *subModel = [model.children objectAtIndex:row];
        return subModel.divisionName;
    }
    
}
- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view
{
//    UILabel *lalTitle=(UILabel *)view;
//    if (!lalTitle) {
//        lalTitle=[[UILabel alloc] init];
//        lalTitle.minimumScaleFactor=8;//设置最小字体，与minimumFontSize相同，minimumFontSize在IOS 6后不能使用。
//        lalTitle.adjustsFontSizeToFitWidth=YES;//设置字体大小是否适应lalbel宽度
//        lalTitle.textAlignment=NSTextAlignmentCenter;//文字居中显示
//        [lalTitle setTextColor:[UIColor blackColor]];
//        [lalTitle setFont:[UIFont systemFontOfSize:14.0f]];
//    }
//    lalTitle.text=[self pickerView:pickerView titleForRow:row forComponent:component];
//    return lalTitle;
    UILabel* pickerLabel = (UILabel*)view;
    if (!pickerLabel){
        pickerLabel = [[UILabel alloc] init];
        pickerLabel.adjustsFontSizeToFitWidth = YES;
        pickerLabel.textAlignment = NSTextAlignmentCenter;
        [pickerLabel setBackgroundColor:[UIColor clearColor]];
        [pickerLabel setFont:[UIFont systemFontOfSize:18]];
    }
    pickerLabel.text = [self pickerView:pickerView titleForRow:row forComponent:component];
    return pickerLabel;
}

@end
