//
//  ArchiveEditSelectCell.m
//  BSKYDoctorPro
//
//  Created by 快医科技 on 2018/3/8.
//  Copyright © 2018年 ky. All rights reserved.
//

#import "ArchiveEditSelectCell.h"
#import "SDCollectionTagsFlowLayout.h"
#import "ZLGenopathyCell.h"

@interface ArchiveEditSelectCell ()<UICollectionViewDelegate,UICollectionViewDataSource>
@property (nonatomic ,strong)UILabel *tilteLabel;
@property (nonatomic ,strong)UIImageView *arrowImageView;
@property (nonatomic ,strong)UICollectionView *contentCollectionView;
@end

@implementation ArchiveEditSelectCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
//        self.selectedArray = [NSMutableArray array];
        [self initView];
    }
    return self;
}
- (void)initView{
    
    
    
    [self.contentView addSubview:self.tilteLabel];
    [self.contentView addSubview:self.arrowImageView];
    [self.contentView addSubview:self.contentCollectionView];
    CGSize size = [UIImage imageNamed:@"more_icon"].size;
    [self.tilteLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.equalTo(@15);
        make.height.equalTo(@15);
        make.right.equalTo(@-15);
    }];
    [self.arrowImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.tilteLabel.mas_centerY);
        make.right.mas_equalTo(-15);
        make.width.mas_equalTo(size.width);
        make.height.mas_equalTo(size.height);
    }];
    [self.contentCollectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.tilteLabel.mas_bottom).mas_equalTo(15);
        make.left.mas_equalTo(15);
        make.height.equalTo(@(30)).priorityHigh();
        make.right.mas_equalTo(-15);
        make.bottom.equalTo(@-15);
    }];
}
- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (void)setModel:(BSArchiveModel *)model{
    _model = model;
    self.tilteLabel.text = _model.title;
    [self.contentCollectionView reloadData];
    [self.contentCollectionView layoutIfNeeded];
    if ([model.selectModel.options count]) {
        CGFloat height = self.contentCollectionView.contentSize.height;
        [self.contentCollectionView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(@(height)).priorityHigh();
            make.top.equalTo(self.tilteLabel.mas_bottom).mas_equalTo(15);
            make.left.mas_equalTo(15);
            make.right.mas_equalTo(-15);
            make.bottom.equalTo(@-15);
        }];
        [self.tilteLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.left.equalTo(@15);
            make.height.equalTo(@15);
            make.right.equalTo(@-15);
            make.bottom.equalTo(self.contentCollectionView.mas_top).offset(-15);
        }];
    }else{
        [self.contentCollectionView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(0);
        }];
        [self.tilteLabel mas_updateConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(self.contentView.mas_bottom).offset(-15);
        }];
    }
    
    
}
#pragma mark 懒加载
- (UILabel *)tilteLabel{
    if (!_tilteLabel) {
        _tilteLabel = [[UILabel alloc] init];
        _tilteLabel.font = [UIFont systemFontOfSize:14];
        _tilteLabel.textColor = UIColorFromRGB(0x666666);
    }
    return _tilteLabel;
}
- (UIImageView *)arrowImageView{
    if (!_arrowImageView) {
        _arrowImageView = [[UIImageView alloc] init];
        _arrowImageView.image = [UIImage imageNamed:@"more_icon"];
    }
    return _arrowImageView;
}
- (UICollectionView *)contentCollectionView{
    if (!_contentCollectionView) {
        SDCollectionTagsFlowLayout *flowLayout = [[SDCollectionTagsFlowLayout alloc]initWthType:TagsTypeWithLeft];
        flowLayout.minimumInteritemSpacing = 10;
        flowLayout.minimumLineSpacing = 10;
        flowLayout.sectionInset = UIEdgeInsetsMake(0, 0, 0, 0);
        _contentCollectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:flowLayout];
        _contentCollectionView.delegate = self;
        _contentCollectionView.dataSource = self;
        [_contentCollectionView setBackgroundColor:[UIColor clearColor]];
        //        _collectionView
        //注册
        UINib *nib = [UINib nibWithNibName:@"ZLGenopathyCell" bundle: [NSBundle mainBundle]];
        //    [collectionView registerNib:nib forCellWithReuseIdentifier:HLChoosePhotoActionSheetCellIdentifier];
        [_contentCollectionView registerNib:nib forCellWithReuseIdentifier:NSStringFromClass([ZLGenopathyCell class])];
    }
    return _contentCollectionView;
}
#pragma mark Collection Delegate
#pragma mark UICollectionDelegate
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.model.selectModel.options.count;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    ZLDiseaseModel *option = self.self.model.selectModel.options[indexPath.row];
    NSString *str = [option valueForKey:@"name"];
    CGSize size = [str sizeWithFont:[UIFont systemFontOfSize:14] maxSize:CGSizeMake(SCREEN_WIDTH - 30, 30)];
    return CGSizeMake(size.width+32,30);
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    ZLGenopathyCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([ZLGenopathyCell class]) forIndexPath:indexPath];
    ZLDiseaseModel *option = self.self.model.selectModel.options[indexPath.row];
    [cell setModel:option];
    return cell;
}
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    
}
@end
