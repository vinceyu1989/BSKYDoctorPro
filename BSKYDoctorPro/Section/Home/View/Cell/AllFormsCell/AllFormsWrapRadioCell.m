//
//  AllFormsWrapRadioCell.m
//  BSKYDoctorPro
//
//  Created by 何雷 on 2017/11/24.
//  Copyright © 2017年 ky. All rights reserved.
//

#import "AllFormsWrapRadioCell.h"
#import "CATPlaceHolderTextView.h"
#import "SDCollectionTagsFlowLayout.h"
#import "FollowupSymptomItemCell.h"

@interface AllFormsWrapRadioCell()
<UICollectionViewDelegate,
UICollectionViewDataSource,
UICollectionViewDelegateFlowLayout>

@property (nonatomic ,strong) UICollectionView *collectionView;

@property (nonatomic ,strong) UIView *line;

@property (nonatomic ,strong) NSArray *tags;

@property (nonatomic ,assign) NSInteger selectedIndex;

@end

@implementation AllFormsWrapRadioCell

static CGFloat const kAllFormsWrapRadioCellMargin = 15;

- (void)awakeFromNib {
    [super awakeFromNib];
}
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectedIndex = -1;
        [self initView];
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}
- (void)initView
{
    [self addSubview:self.collectionView];
    [self addSubview:self.line];
    [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.equalTo(self).offset(kAllFormsWrapRadioCellMargin);
        make.width.equalTo(@(SCREEN_WIDTH - 2*kAllFormsWrapRadioCellMargin));
        make.bottom.equalTo(self.mas_bottom).offset(-kAllFormsWrapRadioCellMargin);
    }];
    [self.line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left).offset(15);
        make.right.bottom.equalTo(self);
        make.height.equalTo(@0.5);
    }];
}

#pragma mark ---- Getter
- (UICollectionView *)collectionView {
    if (!_collectionView) {
        SDCollectionTagsFlowLayout *flowLayout = [[SDCollectionTagsFlowLayout alloc]initWthType:TagsTypeWithLeft];
        flowLayout.minimumInteritemSpacing = 10;
        flowLayout.minimumLineSpacing = 15;
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero    collectionViewLayout:flowLayout];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        [_collectionView setBackgroundColor:[UIColor clearColor]];
        //        _collectionView
        //注册
        [_collectionView registerClass:[FollowupSymptomItemCell class] forCellWithReuseIdentifier:NSStringFromClass([FollowupSymptomItemCell class])];
    }
    return _collectionView;
}
- (UIView *)line
{
    if (!_line) {
        _line = [[UIView alloc]init];
        _line.backgroundColor = UIColorFromRGB(0xededed);
    }
    return _line;
}
#pragma mark --- Setter

- (void)setModel:(InterviewInputModel *)model
{
    _model = model;
    self.tags = _model.options;
    self.selectedIndex = (NSInteger)log2(_model.contentStr.integerValue);
    [self.collectionView reloadData];
    [self.collectionView layoutIfNeeded];
    CGFloat height = self.collectionView.collectionViewLayout.collectionViewContentSize.height;
    [self.collectionView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(@(height)).priorityHigh();
    }];
}

#pragma mark --- UICollectionViewDataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.tags.count;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *str = self.tags[indexPath.row];
    CGSize size = [str sizeWithFont:[UIFont systemFontOfSize:14] maxSize:CGSizeMake(SCREEN_WIDTH-50-20, 30)];
    return CGSizeMake(size.width+20,30);
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    FollowupSymptomItemCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([FollowupSymptomItemCell class]) forIndexPath:indexPath];
    cell.titleLabel.text = self.tags[indexPath.row];
    cell.selected = NO;
    if (indexPath.row == self.selectedIndex) {
        cell.selected = YES;
    }
    return cell;
}
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == self.selectedIndex) {
        self.selectedIndex = -1;
    }
    else
    {
        self.selectedIndex = indexPath.row;
    }
    [collectionView reloadData];
    [self configUpModelWithIndex:self.selectedIndex];
}
- (void)configUpModelWithIndex:(NSInteger)index
{
    NSString *str = nil;
    NSNumber *num = nil;
    if (index >= 0) {
        index = pow(2, index);
        str = [NSString stringWithFormat:@"%ld",(long)index];
        num = @(index);
    }
    self.model.contentStr = str;
    if ([self.model.title isEqualToString:@"随访分类"])
    {
        self.upModel.cmModel.fuClassification = num;
    }
}

@end
