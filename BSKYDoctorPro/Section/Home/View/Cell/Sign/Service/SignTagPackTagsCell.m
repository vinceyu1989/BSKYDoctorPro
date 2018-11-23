//
//  SignTagPackTagsCell.m
//  BSKYDoctorPro
//
//  Created by 何雷 on 2018/1/2.
//  Copyright © 2018年 ky. All rights reserved.
//

#import "SignTagPackTagsCell.h"
#import "SDCollectionTagsFlowLayout.h"
#import "FollowupSymptomItemCell.h"
#import "BSSignLabelModel.h"

@interface SignTagPackTagsCell()<UICollectionViewDelegate,
UICollectionViewDataSource,
UICollectionViewDelegateFlowLayout
>
@property (nonatomic ,strong) UICollectionView *collectionView;
@property (nonatomic, strong) NSMutableArray *selectedArray;
@property (nonatomic ,assign) NSInteger contentIndex;

@end

@implementation SignTagPackTagsCell

static CGFloat const kSignTagPackTagsCellMargin = 15;

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectedArray = [NSMutableArray array];
        self.tags = [NSMutableArray array];
        [self initView];
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}
- (void)initView {
    [self addSubview:self.collectionView];
    [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.equalTo(self).offset(kSignTagPackTagsCellMargin);
        make.width.equalTo(@(SCREEN_WIDTH - 2*kSignTagPackTagsCellMargin));
        make.bottom.equalTo(self.mas_bottom);
    }];
}

#pragma mark ---- Getter
- (UICollectionView *)collectionView {
    if (!_collectionView) {
        SDCollectionTagsFlowLayout *flowLayout = [[SDCollectionTagsFlowLayout alloc]initWthType:TagsTypeWithLeft];
        flowLayout.minimumInteritemSpacing = 10;
        flowLayout.minimumLineSpacing = 15;
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:flowLayout];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        [_collectionView setBackgroundColor:[UIColor clearColor]];
        //        _collectionView
        //注册
        [_collectionView registerClass:[FollowupSymptomItemCell class] forCellWithReuseIdentifier:NSStringFromClass([FollowupSymptomItemCell class])];
        
    }
    return _collectionView;
}

- (void)setTags:(NSMutableArray *)tags {
    _tags = tags;
    [self.collectionView reloadData];
    [self.collectionView layoutIfNeeded];
    [self.collectionView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(@(self.collectionView.contentSize.height+15)).priorityHigh();
    }];
}
#pragma mark --- UICollectionViewDataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.tags.count;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    if (self.tags.count == 0) {
        return CGSizeZero;
    }
    BSSignLabelModel *model = (BSSignLabelModel *)self.tags[indexPath.row];
    NSString *str = model.dictName;
    CGSize size = [str sizeWithFont:[UIFont systemFontOfSize:14] maxSize:CGSizeMake(SCREEN_WIDTH-50-20, 30)];
    return CGSizeMake(size.width+20,30);
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    FollowupSymptomItemCell *collectCell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([FollowupSymptomItemCell class]) forIndexPath:indexPath];
    if (self.tags.count != 0) {
        BSSignLabelModel *model = (BSSignLabelModel *)self.tags[indexPath.item];
        collectCell.titleLabel.text = model.dictName;
        collectCell.selected = [self.selectedArray containsObject:model];
    }
    return collectCell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    BSSignLabelModel *model = (BSSignLabelModel *)self.tags[indexPath.item];
    if (self.tagBlock) {
        self.tagBlock(indexPath.item);
    }
    if (![self.selectedArray containsObject:model]) {
        [self.selectedArray addObject:model];
    }
    else {
        [self.selectedArray removeObject:model];
    }
    [collectionView reloadData];
}

@end
