//
//  IMDetailLabelCell.m
//  BSKYDoctorPro
//
//  Created by 快医科技 on 2018/5/16.
//  Copyright © 2018年 ky. All rights reserved.
//

#import "IMDetailLabelCell.h"
#import "SDCollectionTagsFlowLayout.h"
#import "IMDetailLabelCollectionViewCell.h"
#import "IMEXModel.h"
#import "IMDataManager.h"
#import "BSArchiveModel.h"

@interface IMDetailLabelCell ()<UICollectionViewDelegate,UICollectionViewDataSource>
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UIImageView *moreImageView;
@property (nonatomic ,strong) UICollectionView *collectionView;
@property (nonatomic ,strong) NSMutableArray *selectArray;
@property (nonatomic ,strong) NSString *value;
@end

@implementation IMDetailLabelCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.titleLabel.textColor = UIColorFromRGB(0x333333);
    self.titleLabel.text = @"标签";
    self.titleLabel.font = [UIFont systemFontOfSize:14];
    self.collectionView.userInteractionEnabled = NO;
    [self.contentView addSubview:self.collectionView];
    [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(15);
        make.bottom.mas_equalTo(-15);
//        make.left.equalTo(self.titleLabel.mas_right).offset(20);
        make.right.equalTo(self.moreImageView.mas_left).offset(-15);
        make.width.mas_equalTo(SCREEN_WIDTH - 30 - 80);
        make.height.mas_equalTo(20);
    }];
}
#pragma mark Data
- (NSMutableArray *)selectArray{
    if (!_selectArray) {
        _selectArray = [[NSMutableArray alloc] init];
    }
    return _selectArray;
}
#pragma mark UI
- (UICollectionView *)collectionView{
    if (!_collectionView) {
        SDCollectionTagsFlowLayout *flowLayout = [[SDCollectionTagsFlowLayout alloc]initWthType:TagsTypeWithRight];
        flowLayout.minimumInteritemSpacing = 5;
        flowLayout.minimumLineSpacing = 10;
        flowLayout.sectionInset = UIEdgeInsetsMake(0, 0, 0, 0);
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:flowLayout];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        [_collectionView setBackgroundColor:[UIColor clearColor]];
        //        _collectionView
        //注册
        UINib *nib = [UINib nibWithNibName:@"IMDetailLabelCollectionViewCell" bundle: [NSBundle mainBundle]];
        //    [collectionView registerNib:nib forCellWithReuseIdentifier:HLChoosePhotoActionSheetCellIdentifier];
        [_collectionView registerNib:nib forCellWithReuseIdentifier:NSStringFromClass([IMDetailLabelCollectionViewCell class])];
    }
    return _collectionView;
}
#pragma mark Action

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}
#pragma mark UICollectionView Delegate
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.selectArray.count;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    ArchiveSelectOptionModel *option = self.selectArray[indexPath.row];
    NSString *str = option.lebel;
    CGSize size = [str sizeWithFont:[UIFont systemFontOfSize:12] maxSize:CGSizeMake(80, 20)];
    return CGSizeMake(size.width+32,20);
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    IMDetailLabelCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([IMDetailLabelCollectionViewCell class]) forIndexPath:indexPath];
    ArchiveSelectOptionModel *option = self.selectArray[indexPath.row];
    cell.option = option;
    return cell;
}
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    
}
- (void)setUser:(NIMUser *)user{
    _user = user;
    [self.selectArray removeAllObjects];
    if (_user.ext.length) {
        IMFriendEXModel *model = [IMFriendEXModel mj_objectWithKeyValues:[_user.ext mj_JSONObject]];
        self.value = model.userLabel;
        NSArray *options = [[IMDataManager dataManager].IMSelectOptions objectForKey:@"im_crowd_tags"];
        for (ArchiveSelectOptionModel *option in options) {
            if (model.userLabel.intValue & option.value.intValue) {
                [self.selectArray addObject:option];
            }
        }
    }
    [self.collectionView reloadData];
    [self.collectionView layoutIfNeeded];
    if (self.selectArray.count) {
        CGFloat height = self.collectionView.contentSize.height;
        [self.collectionView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(height);
        }];
    }
    
}
@end
