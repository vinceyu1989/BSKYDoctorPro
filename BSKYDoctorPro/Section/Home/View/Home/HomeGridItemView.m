//
//  HomeGridItemView.m
//  BSKYDoctorPro
//
//  Created by 何雷 on 2017/8/16.
//  Copyright © 2017年 ky. All rights reserved.
//

#import "HomeGridItemView.h"
#import "HomeGridItemButton.h"
#import "GridItemModel.h"
#import <SDWebImage/UIButton+WebCache.h>

@implementation HomeGridItemView {
    HomeGridItemButton *_button;
    UIButton *_iconView;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        
        [self initView];
    }
    return self;
}

- (void)initView
{
    self.backgroundColor = [UIColor clearColor];
    
    HomeGridItemButton *button = [[HomeGridItemButton alloc] init];
    [button addTarget:self action:@selector(buttonClicked) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:button];
    button.redPiont.hidden = YES;
    _button = button;
    
    UIButton *icon = [[UIButton alloc] init];
    [icon setImage:[UIImage imageNamed:@"Home_delete_icon"] forState:UIControlStateNormal];
    [icon addTarget:self action:@selector(iconViewClicked) forControlEvents:UIControlEventTouchUpInside];
    icon.hidden = YES;
    [self addSubview:icon];
    _iconView = icon;
    
    UILongPressGestureRecognizer *longPressed = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(itemLongPressed:)];
    [self addGestureRecognizer:longPressed];
}

#pragma mark - actions

- (void)itemLongPressed:(UILongPressGestureRecognizer *)longPressed
{
    if (self.itemLongPressedOperationBlock) {
        self.itemLongPressedOperationBlock(longPressed);
    }
}

- (void)buttonClicked
{
    if (self.buttonClickedOperationBlock) {
        self.buttonClickedOperationBlock(self);
    }
}

- (void)iconViewClicked
{
    if (self.iconViewClickedOperationBlock) {
        self.iconViewClickedOperationBlock(self);
    }
}

#pragma mark - properties

- (void)setItemModel:(GridItemModel *)itemModel
{
    _itemModel = itemModel;
    
    if (itemModel.title) {
        [_button setTitle:itemModel.title forState:UIControlStateNormal];
    }
    
    if (itemModel.imageStr) {
        if ([itemModel.imageStr hasPrefix:@"http:"]) {
            [_button sd_setImageWithURL:[NSURL URLWithString:itemModel.imageStr] forState:UIControlStateNormal placeholderImage:nil];
        } else {
            [_button setImage:[UIImage imageNamed:itemModel.imageStr] forState:UIControlStateNormal];
        }
    }
    
}

- (void)setHidenIcon:(BOOL)hidenIcon
{
    _hidenIcon = hidenIcon;
    _iconView.hidden = hidenIcon;
}

- (void)setIconImage:(UIImage *)iconImage
{
    _iconImage = iconImage;
    
    [_iconView setImage:iconImage forState:UIControlStateNormal];
}
- (void)setIsRed:(BOOL)isRed
{
    _isRed = isRed;
    
    _button.redPiont.hidden = !_isRed;
}

#pragma mark - life circles

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    CGFloat margin = 10;
    _button.frame = self.bounds;
    _iconView.frame = CGRectMake(self.width - _iconView.width - margin, margin, 20, 20);
}



@end
