//
//  NTESSessionLinkContentView.m
//  BSKYDoctorPro
//
//  Created by vince on 2018/11/12.
//  Copyright © 2018年 ky. All rights reserved.
//

#import "NTESSessionLinkContentView.h"
#import "UIView+NTES.h"
#import "NTESLinkAttachment.h"
#import "NTESSessionUtil.h"
#import "UIImageView+WebCache.h"

CGFloat titleHeight = 20.f; // title高度
CGFloat imageHeight = 40.f;// 图片高度
CGFloat imageWitdh = 34.f;// 图片高度

@interface NTESSessionLinkContentView()

// 患者资料消息附件
@property (nonatomic,strong) NTESLinkAttachment *attachment;

@property (nonatomic,strong) UILabel *titleLabel;

@property (nonatomic,strong) UIImageView *imageView;

@property (nonatomic,strong) UILabel *describeLabel;

@end

@implementation NTESSessionLinkContentView

- (instancetype)initSessionMessageContentView{
    self = [super initSessionMessageContentView];
    if (self) {
        self.opaque = YES;
        self.bubbleImageView.image = nil;
        self.backgroundColor = [UIColor whiteColor];
        _titleLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _imageView  = [[UIImageView alloc] initWithFrame:CGRectZero];
        _describeLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    }
    return self;
}

- (void)refresh:(NIMMessageModel *)data
{
    [super refresh:data];
    
    [self.bubbleImageView setImage:nil];
    [self.bubbleImageView setHighlightedImage:nil];
    NIMCustomObject *customObject = (NIMCustomObject*)data.message.messageObject;
    id attach = customObject.attachment;
    
    if ([attach isKindOfClass:[NTESLinkAttachment class]]) {
        self.attachment = (NTESLinkAttachment *)attach;
        
        self.titleLabel.text = self.attachment.title;
        [self addSubview:_titleLabel];
        
        self.imageView.image = [UIImage imageNamed:@"icon_archive"];
        [self addSubview:_imageView];
        if (self.attachment.describe != nil) {
            self.describeLabel.text = self.attachment.describe;
            [self addSubview:_describeLabel];
        }else{
            self.describeLabel.text = @"--";
            [self addSubview:_describeLabel];
        }
    }
}

- (void)layoutSubviews{
    [super layoutSubviews];
    BOOL outgoing = self.model.message.isOutgoingMsg;
    
    UIEdgeInsets contentInsets = self.model.contentViewInsets;
    CGSize contentSize = [self.model contentSize:self.superview.width];
    CGFloat padding = 12;
    
    self.titleLabel.font = [UIFont systemFontOfSize:16.0];
    self.titleLabel.frame = CGRectMake(padding, 12, contentSize.width - 15 * 2 - padding- imageWitdh, titleHeight);
    
    self.imageView.frame = CGRectMake(
                                      self.width - imageWitdh - 15,padding,imageWitdh, 45);
    self.imageView.contentMode = UIViewContentModeScaleAspectFit;
    UIFont *font = [UIFont systemFontOfSize:12.0];
    self.describeLabel.font = font;
    self.describeLabel.frame = CGRectMake(padding, self.titleLabel.y + titleHeight + 12, self.titleLabel.width, 15);
    self.titleLabel.textColor = [UIColor blackColor];
    self.describeLabel.textColor = UIColorHex(0x999999);
}

// 根据宽动态获取高度
+ (CGFloat)getHeightByWidth:(CGFloat)width title:(NSString *)title font:(UIFont *)font
{
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, width, 0)];
    label.text = title;
    label.font = font;
    label.numberOfLines = 0;
    [label sizeToFit];
    CGFloat height = label.frame.size.height;
    return height;
}

// 设置元素边框
-(void)setBorderWithImageView:(UIImageView *) imageView top:(BOOL)top left:(BOOL)left bottom:(BOOL)bottom right:(BOOL)right borderColor:(UIColor *)color borderWidth:(CGFloat)width
{
    // 垂直内边距
    CGFloat verticalPadding = 5.0f;
    if (top)
    {
        CALayer *layer = [CALayer layer];
        layer.frame = CGRectMake(0, -verticalPadding, imageView.frame.size.width, width);
        layer.backgroundColor = color.CGColor;
        [imageView.layer addSublayer:layer];
    }
    if (left)
    {
        CALayer *layer = [CALayer layer];
        layer.frame = CGRectMake(0, 0, width, imageView.frame.size.height);
        layer.backgroundColor = color.CGColor;
        [imageView.layer addSublayer:layer];
    }
    if (bottom)
    {
        CALayer *layer = [CALayer layer];
        layer.frame = CGRectMake(0, imageView.frame.size.height - width + verticalPadding, imageView.frame.size.width, width);
        layer.backgroundColor = color.CGColor;
        [imageView.layer addSublayer:layer];
    }
    if (right)
    {
        CALayer *layer = [CALayer layer];
        layer.frame = CGRectMake(imageView.frame.size.width - width, 0, width, imageView.frame.size.height);
        layer.backgroundColor = color.CGColor;
        [imageView.layer addSublayer:layer];
    }
}

- (void)onTouchUpInside:(id)sender
{
    if ([self.delegate respondsToSelector:@selector(onCatchEvent:)]) {
        NIMKitEvent *event = [[NIMKitEvent alloc] init];
        event.eventName = NIMDemoEventNameLinkingPacket;
        event.messageModel = self.model;
        event.data = self;
        [self.delegate onCatchEvent:event];
    }
}

@end
