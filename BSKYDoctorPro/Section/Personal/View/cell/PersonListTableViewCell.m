//
//  PersonListTableViewCell.m
//  BSKYDoctorPro
//
//  Created by kykj on 2017/11/15.
//  Copyright © 2017年 ky. All rights reserved.
//

#import "PersonListTableViewCell.h"
#define theWidth   [UIScreen mainScreen].bounds.size.width
#define theHeight  [UIScreen mainScreen].bounds.size.height

@interface PersonListTableViewCell()

@end

@implementation PersonListTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self initView];
    }
    return self;
}

- (void)initView {
    
    self.headImage = ({
        UIImageView *image = [[UIImageView alloc] init];
        image;
    });
    [self addSubview:self.headImage];
    
    self.titleLabel = ({
        UILabel *label = [[UILabel alloc] init];
        label.font = [UIFont systemFontOfSize:16];
        label;
    });
    [self addSubview:self.titleLabel];
    
    self.nextImage = ({
        UIImageView *image = [[UIImageView alloc] init];
        image.image = [UIImage imageNamed:@"more_icon"];
        image;
    });
    [self addSubview:self.nextImage];
    
    [self.headImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(15);
        make.top.offset(12);
        make.width.offset(theWidth/375 *25.0);
        make.height.offset(theWidth/375 *25.0);
    }];
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.headImage.mas_right).offset(10);
        make.centerY.mas_equalTo(self.headImage.mas_centerY);
        make.width.mas_equalTo(100);
    }];
    [self.nextImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self.mas_right).offset(-15);
        make.centerY.mas_equalTo(self.headImage.mas_centerY);
        make.width.offset(theWidth/375 *7.0);
        make.height.offset(theWidth/375 *14.0);
    }];
    
}

@end
