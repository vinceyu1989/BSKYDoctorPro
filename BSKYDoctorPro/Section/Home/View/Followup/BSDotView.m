//
//  BSDotView.m
//  BSKYDoctorPro
//
//  Created by 何雷 on 2017/12/19.
//  Copyright © 2017年 ky. All rights reserved.
//

#import "BSDotView.h"

@interface BSDotView ()

@property (nonatomic, retain) UILabel *label;
@property (nonatomic, retain) UIImageView *warningImageView;

@end

@implementation BSDotView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.label = ({
            UILabel* label = [UILabel new];
            [label setTextColor:UIColorFromRGB(0xffffff)];
            label.font = [UIFont systemFontOfSize:14];
            label.textAlignment = NSTextAlignmentCenter;
            [self addSubview:label];
            
            label;
        });
        self.warningImageView = ({
            UIImageView* warningImageView = [UIImageView new];
            warningImageView.image = [UIImage imageNamed:@"warning"];
            warningImageView.contentMode = UIViewContentModeCenter;
            [self addSubview:warningImageView];
            
            warningImageView;
        });
        
        [self.label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self);
        }];
        [self.warningImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self);
        }];
    }
    return self;
}

- (void)setBadgeValue:(NSInteger)badgeValue {
    _badgeValue = badgeValue;
    
    if (badgeValue > 0) {
        self.backgroundColor = UIColorFromRGB(0xff2a2a);
        self.label.text = [NSString stringWithFormat:@"%ld", (long)badgeValue];
        CGFloat width = self.label.width;
        [self.label sizeToFit];
        self.label.width = self.label.width + 3;
        if (self.label.width < width) {
            self.label.width = width;
        }
        self.width = self.label.width;
        self.x = self.x - (self.width - width);
        if (self.x < 0) {
            self.x = 0;
        }
        self.hidden = NO;
        self.warningImageView.hidden = YES;
    }else {
        self.hidden = YES;
    }
}

- (void)setWarning:(BOOL)warning {
    _warning = warning;
    
    if (warning) {
        self.backgroundColor = [UIColor clearColor];
        self.hidden = NO;
        self.warningImageView.hidden = NO;
    }else {
        self.hidden = YES;
        self.warningImageView.hidden = YES;
    }
}

@end

