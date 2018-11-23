 //
//  AllFormsAddCell.m
//  BSKYDoctorPro
//
//  Created by 快医科技 on 2018/1/4.
//  Copyright © 2018年 ky. All rights reserved.
//

#import "AllFormsAddCell.h"



@interface AllFormsAddCell ()
@property (nonatomic ,strong) UIView *verticalLine;
@property (nonatomic ,strong) UIView *crossLine;
@property (nonatomic ,strong) UILabel *titleLabel;
@property (nonatomic ,strong) UILabel *describeLabel;
@property (nonatomic ,strong) UIImageView *addImageView;
@property (nonatomic ,strong) UIButton *addbtn;
@property (nonatomic ,strong) UILabel *addLabel;
@end

@implementation AllFormsAddCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self creatUI];
    }
    return self;
}
- (void)creatUI{
    _verticalLine = [[UIView alloc] init];
    _verticalLine.backgroundColor = UIColorFromRGB(0x4e7dd3);
    [self.contentView addSubview:_verticalLine];
    
    _titleLabel = [[UILabel alloc] init];
    _titleLabel.font = [UIFont systemFontOfSize:18];
    [self.contentView addSubview:_titleLabel];
    
    _describeLabel = [[UILabel alloc] init];
    _describeLabel.textColor = UIColorFromRGB(0xb3b3b3);
    _describeLabel.font = [UIFont systemFontOfSize:12];
    [self.contentView addSubview:_describeLabel];
    
    _addImageView = [[UIImageView alloc] init];
    [_addImageView setImage:[UIImage imageNamed:@"add_icon_normal"]];
    [self.contentView addSubview:_addImageView];
    
    _addLabel = [[UILabel alloc] init];
    _addLabel.textColor = UIColorFromRGB(0x333333);
    _addLabel.text = @"新增";
    [self.addLabel sizeToFit];
    [self.contentView addSubview:_addLabel];
    
    _crossLine = [[UIView alloc] init];
    _crossLine.backgroundColor = UIColorFromRGB(0xededed);
    [self.contentView addSubview:_crossLine];
    
    _addbtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_addbtn setBackgroundColor:[UIColor clearColor]];
    [_addbtn addTarget:self action:@selector(addOptionAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:_addbtn];
    
    [self.verticalLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15);
        make.width.mas_equalTo(3);
        make.height.mas_equalTo(16);
        make.centerY.equalTo(self);
    }];
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.verticalLine.mas_right).offset(10);
        make.width.mas_equalTo(50);
        make.height.mas_equalTo(16);
        make.centerY.equalTo(self);
    }];
    [self.describeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.titleLabel.mas_right);
        make.height.mas_equalTo(16);
        make.width.mas_equalTo(100);
        make.centerY.equalTo(self);
    }];
    [self.addImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-15);
        make.width.mas_equalTo(14);
        make.height.mas_equalTo(14);
        make.centerY.equalTo(self);
    }];
    [self.addLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.addImageView.mas_left).offset(-5);
        make.width.mas_equalTo(self.addLabel.width);
        make.height.mas_equalTo(16);
        make.centerY.equalTo(self);
    }];
    [self.crossLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self);
        make.width.equalTo(self);
        make.height.mas_equalTo(0.5);
        make.bottom.equalTo(self);
    }];
    [self.addbtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.left.right.equalTo(self);
    }];
}
- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    
}
- (void)setModel:(BSArchiveModel *)model{
    _model = model;
    self.titleLabel.text = _model.title;
    self.describeLabel.text = _model.descripe;
    
    
    [self.titleLabel sizeToFit];
    if (_model.type == ArchiveModelTypeAddCell) {
        self.verticalLine.hidden = YES;
        self.describeLabel.hidden = NO;
        self.addLabel.hidden = NO;
        self.titleLabel.textColor = UIColorFromRGB(0x000000);
        [self.titleLabel mas_updateConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(15);
            make.width.mas_equalTo(self.titleLabel.width);
        }];
    }else if (_model.type == ArchiveModelTypeAddSection){
        self.verticalLine.hidden = NO;
        self.describeLabel.hidden = YES;
        self.titleLabel.textColor = UIColorFromRGB(0x4e7dd3);
        [self.titleLabel mas_updateConstraints:^(MASConstraintMaker *make) {
//            make.left.equalTo(self.verticalLine.mas_left).offset(15);
            make.width.mas_equalTo(self.titleLabel.width);
        }];
        self.addLabel.hidden = YES;
    }
    
}
- (void)addOptionAction:(UIButton *)btn{
    if (self.delegate && [self.delegate respondsToSelector:@selector(allFormsAddCellAddClick:)]) {
        [self.delegate allFormsAddCellAddClick:self];
    }
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
