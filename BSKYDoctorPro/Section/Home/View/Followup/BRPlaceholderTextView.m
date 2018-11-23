//
//  PlaceholderTextView.m
//  SaleHelper
//
//  Created by gitBurning on 14/12/8.
//  Copyright (c) 2014年 Burning_git. All rights reserved.
//

#import "BRPlaceholderTextView.h"

@interface BRPlaceholderTextView()

@property(strong,nonatomic)  UILabel *placeholderLabel;

@property(assign,nonatomic) float placeholdeWidth;

@property(copy,nonatomic) id eventBlock;

@end

@implementation BRPlaceholderTextView

#pragma mark - life cycle

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self initView];
    }
    return self;
}
- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self initView];
    }
    return self;
}

- (void)initView {
    
    [self addSubview:self.placeholderLabel];
    [self.placeholderLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.equalTo(self);
        make.height.equalTo(@15);
    }];
    
    self.textContainerInset = UIEdgeInsetsMake(0, -2, 0, 0);
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didChange:) name:UITextViewTextDidChangeNotification object:self];
}

-(void)dealloc{
    for (UIView *view in self.subviews) {
        [view removeFromSuperview];
    }
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - Event response

-(void)addMaxTextLengthWithMaxLength:(NSInteger)maxLength andEvent:(void (^)(BRPlaceholderTextView *text))limit {
    if (maxLength>0) {
        self.maxTextLength=maxLength;
    }
    if (limit) {
        _eventBlock=limit;
    }
}

#pragma mark  ---  外部设置

-(void)setUpdateHeight:(float)updateHeight{
    CGRect frame=self.frame;
    frame.size.height=updateHeight;
    self.frame=frame;
    _updateHeight=updateHeight;
}

-(void)setPlaceholder:(NSString *)placeholder{
    
    if (placeholder.length == 0 || [placeholder isEqualToString:@""]) {
        self.placeholderLabel.hidden = YES;
    } else {
        self.placeholderLabel.text=placeholder;
        _placeholder=placeholder;
    }
}

#pragma mark - Noti Event

-(void)didChange:(NSNotification*)noti{
    
    if (self.placeholder.length == 0 || [self.placeholder isEqualToString:@""]) {
        self.placeholderLabel.hidden=YES;
    }
    
    if (self.text.length > 0) {
        self.placeholderLabel.hidden=YES;
    }
    else{
        self.placeholderLabel.hidden=NO;
    }
    
    NSString *lang = [[self.nextResponder textInputMode] primaryLanguage]; // 键盘输入模式
    
    if ([lang isEqualToString:@"zh-Hans"]) { // 简体中文输入，包括简体拼音，健体五笔，简体手写
        UITextRange *selectedRange = [self markedTextRange];
        //获取高亮部分
        UITextPosition *position = [self positionFromPosition:selectedRange.start offset:0];
        // 没有高亮选择的字，则对已输入的文字进行字数统计和限制
        if (!position) {
            if (self.text.length > self.maxTextLength) {
                self.text = [self.text substringToIndex:self.maxTextLength];
            }
        }
        // 有高亮选择的字符串，则暂不对文字进行统计和限制
        else{
            
        }
    }
    // 中文输入法以外的直接对其统计限制即可，不考虑其他语种情况
    else{
        if (self.text.length > self.maxTextLength) {
             self.text = [self.text substringToIndex:self.maxTextLength];
        }
    }
    if (self.lengthBlcok) {
        self.lengthBlcok(self.text.length);
    }
    
    if (_eventBlock && self.text.length <= self.maxTextLength) {
        void (^limint)(BRPlaceholderTextView*text) =_eventBlock;
        limint(self);
    }
}

#pragma mark - private method

+(float)boundingRectWithSize:(CGSize)size withLabel:(NSString *)label withFont:(UIFont *)font{
    NSDictionary *attribute = @{NSFontAttributeName:font};
    
    // CGSize retSize;
    CGSize retSize = [label boundingRectWithSize:size
                                         options:NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading
                                      attributes:attribute
                                         context:nil].size;
    return retSize.height;
    
}
#pragma mark ---- Grtter Setter

- (UILabel *)placeholderLabel {
    if (!_placeholderLabel) {
        _placeholderLabel = [[UILabel alloc] init];
        _placeholderLabel.numberOfLines=0;
        _placeholderLabel.lineBreakMode=NSLineBreakByCharWrapping|NSLineBreakByWordWrapping;
        _placeholderLabel.textColor = UIColorFromRGB(0xcccccc);
        _placeholderLabel.font = [UIFont systemFontOfSize:14];
        _placeholderLabel.textAlignment = NSTextAlignmentLeft;
    }
    return _placeholderLabel;
}

-(void)setText:(NSString *)tex{
    if (tex.length>0) {
        self.placeholderLabel.hidden=YES;
    }
    [super setText:tex];
}
@end
