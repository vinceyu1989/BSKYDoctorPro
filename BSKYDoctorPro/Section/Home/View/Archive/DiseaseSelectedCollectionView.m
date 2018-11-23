//
//  DiseaseSelectedCollectionView.m
//  BSKYDoctorPro
//
//  Created by 快医科技 on 2018/3/5.
//  Copyright © 2018年 ky. All rights reserved.
//

#import "DiseaseSelectedCollectionView.h"
#import "SDCollectionTagsFlowLayout.h"
#import "DiseaseSelectedCell.h"
#import "ZLDiseaseModel.h"

@interface DiseaseSelectedCollectionView()<UICollectionViewDelegate,UICollectionViewDataSource>

@end

@implementation DiseaseSelectedCollectionView
@synthesize selectedArray = _selectedArray;
- (instancetype)initWithFrame:(CGRect)frame
{
    SDCollectionTagsFlowLayout *flowLayout = [[SDCollectionTagsFlowLayout alloc]initWthType:TagsTypeWithLeft];
    flowLayout.minimumInteritemSpacing = 10;
    flowLayout.minimumLineSpacing = 10;
    flowLayout.sectionInset = UIEdgeInsetsMake(0, 15, 0, 15);
    self = [super initWithFrame:frame collectionViewLayout:flowLayout];
    if (self) {
        [self initilationUI];
    }
    return self;
}
- (void)initilationUI{
    
//    self.collectionViewLayout = flowLayout;
    self.delegate = self;
    self.dataSource = self;
    [self setBackgroundColor:[UIColor clearColor]];
    //        _collectionView
    //注册
    UINib *nib = [UINib nibWithNibName:@"DiseaseSelectedCell" bundle: [NSBundle mainBundle]];
//    [collectionView registerNib:nib forCellWithReuseIdentifier:HLChoosePhotoActionSheetCellIdentifier];
    [self registerNib:nib forCellWithReuseIdentifier:NSStringFromClass([DiseaseSelectedCell class])];
}
- (void)setSelectedArray:(NSMutableArray *)selectedArray{
//    [_selectedArray removeAllObjects];
//    [self.selectedArray addObjectsFromArray:selectedArray];
    _selectedArray = selectedArray;
    [self reloadData];
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
- (NSMutableArray *)selectedArray{
    if (!_selectedArray) {
//        _selectedArray = [[NSMutableArray alloc] init];
    }
    return _selectedArray;
}
- (void)deleteAction:(ZLDiseaseModel *)model{
    NSInteger count = [self.selectedArray indexOfObject:model];
    [self.selectedArray removeObject:model];
    [self deleteItemsAtIndexPaths:[NSArray arrayWithObject:[NSIndexPath indexPathForRow:count inSection:0]]];
}
#pragma mark UICollectionDelegate
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.selectedArray.count;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    ZLDiseaseModel *option = self.selectedArray[indexPath.row];
    NSString *str = [option valueForKey:@"name"];
    CGSize size = [str sizeWithFont:[UIFont systemFontOfSize:14] maxSize:CGSizeMake(SCREEN_WIDTH - 30, 30)];
    if (size.width + 50 > self.width - 30) {
        return CGSizeMake(self.width - 30, 30);
    }
    return CGSizeMake(size.width+50 + 5,30);
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    DiseaseSelectedCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([DiseaseSelectedCell class]) forIndexPath:indexPath];
    ZLDiseaseModel *option = self.selectedArray[indexPath.row];
    [cell setModel:option];
    Bsky_WeakSelf;
    cell.deleteBlock = ^(ZLDiseaseModel *model) {
        Bsky_StrongSelf;
        [self deleteAction:model];
    };
    return cell;
}
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    
}
@end
