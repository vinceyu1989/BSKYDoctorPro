//
//  UITableView+Extension.m
//  Bizaia
//
//  Created by mac on 2017/3/3.
//  Copyright © 2017年 何雷. All rights reserved.
//

#import "UITableViewCell+Extension.h"

static const char * kSeparatorKey = "bs_separator";

@implementation UITableViewCell(Extension)

+ (UINib *)nib {
    return [UINib nibWithNibName:NSStringFromClass([self class]) bundle:nil];
}
+(NSString *)cellIdentifier
{
    return NSStringFromClass([self class]);
}
+(CGFloat)cellHeight
{
    return 0;
}
- (void)setSeparatorLeftMargin:(CGFloat)leftMargin
{
    [self.separator mas_updateConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left).offset(leftMargin);
    }];
}
- (UIView *)separator
{
    // 获取对应属性的值
    if (!objc_getAssociatedObject(self, kSeparatorKey)) {
        UIView *line = [[UIView alloc]initWithFrame:CGRectZero];
        line.backgroundColor = UIColorFromRGB(0xededed);
        [self addSubview:line];
        [line mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.bottom.equalTo(self);
            make.height.equalTo(@0.5);
        }];
        objc_setAssociatedObject(self, kSeparatorKey, line, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
        return line;
    }
    return objc_getAssociatedObject(self, kSeparatorKey);
}

@end
