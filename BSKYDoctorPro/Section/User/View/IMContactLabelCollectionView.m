//
//  IMContactLabelCollectionView.m
//  BSKYDoctorPro
//
//  Created by 快医科技 on 2018/5/23.
//  Copyright © 2018年 ky. All rights reserved.
//

#import "IMContactLabelCollectionView.h"
#import "IMDataManager.h"
#import "SDCollectionTagsFlowLayout.h"
#import "BSArchiveModel.h"
#import "IMLabelImageViewCell.h"

@interface IMContactLabelCollectionView ()<UICollectionViewDelegate,UICollectionViewDataSource>
@property (nonatomic ,strong) NSMutableArray *labelArray;

@end

@implementation IMContactLabelCollectionView
- (instancetype)initWithFrame:(CGRect )frame
{
    SDCollectionTagsFlowLayout *flowLayout = [[SDCollectionTagsFlowLayout alloc]initWthType:TagsTypeWithRight];
    flowLayout.minimumInteritemSpacing = 5;
    flowLayout.minimumLineSpacing = 5;
    flowLayout.sectionInset = UIEdgeInsetsMake(0, 0, 0, 0);
    self = [super initWithFrame:frame collectionViewLayout:flowLayout];
    if (self) {
        
        [self initilationUI];
        
    }
    return self;
}
- (void)setValue:(NSString *)value{
    _value = value;
    [self initilationData];
    [self reloadData];
}
- (void)initilationUI{
    
//    self.collectionViewLayout = flowLayout;
    self.delegate = self;
    self.dataSource = self;
    self.backgroundView = nil;
    self.backgroundColor = [UIColor clearColor];
    [self registerClass:[IMLabelImageViewCell class] forCellWithReuseIdentifier:[IMLabelImageViewCell getIdentifier]];
}
- (void)initilationData{
    if (!self.value.length) {
        return;
    }
    [self.labelArray removeAllObjects];
    NSArray *array = [[IMDataManager dataManager].IMSelectOptions objectForKey:@"im_crowd_tags"];
    for (ArchiveSelectOptionModel *option in array) {
        if (![option.lebel containsString:@"正常"] && (option.value.integerValue & self.value.integerValue)) {
            [self.labelArray addObject:option];
        }
    }
}
- (NSMutableArray *)labelArray{
    if (!_labelArray) {
        _labelArray = [[NSMutableArray alloc] init];
    }
    return _labelArray;
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
#pragma mark Collection Delegate
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.labelArray.count;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake(15,15);
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    IMLabelImageViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:[IMLabelImageViewCell getIdentifier] forIndexPath:indexPath];
    ArchiveSelectOptionModel *option = self.labelArray[indexPath.row];

    cell.model = option;
    return cell;
}
@end
