//
//  ResidentFilterView.m
//  BSKYDoctorPro
//
//  Created by 何雷 on 2018/1/16.
//  Copyright © 2018年 ky. All rights reserved.
//

#import "ResidentFilterView.h"
#import "ResidentFilterCell.h"
#import "ResidentFilterHeaderView.h"

@interface ResidentFilterView()
<UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout>

@property (nonatomic, strong) UIView * contentView;

@property (nonatomic, strong) UICollectionView * collectionView;

@property (nonatomic ,strong) NSMutableArray *uiArray;    // 布局UI的数组

@property (nonatomic, strong) NSMutableArray *usedArray;  // 已使用的数组

@end

static CGFloat const kResidentFilterViewBtnHeight = 40;    // 列

static CGFloat const kResidentFilterViewDuration = 0.3;    //

static CGFloat const kResidentFilterContentViewScale = 0.85;


@implementation ResidentFilterView

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self initView];
    }
    return self;
}

- (void)initView
{
    self.usedArray = [NSMutableArray array];
    self.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
    self.backgroundColor = RGBA(0, 0, 0, 0);
    self.contentView = [[UIView alloc]initWithFrame:CGRectMake(self.width, 0, self.width*kResidentFilterContentViewScale, self.height)];
    self.contentView.backgroundColor = [UIColor whiteColor];
    [self addSubview:self.contentView];
    
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectZero];
    label.text = @"筛选";
    label.textColor = [UIColor blackColor];
    label.font = [UIFont systemFontOfSize:18];
    [label sizeToFit];
    label.frame = CGRectMake(19, TOP_BAR_HEIGHT-15-label.height, label.width, label.height);
    [self.contentView addSubview:label];
    
    UIView *line = [[UIView alloc]initWithFrame:CGRectMake(0, TOP_BAR_HEIGHT, self.contentView.width, 0.5)];
    line.backgroundColor = UIColorFromRGB(0xdedede);
    [self.contentView addSubview:line];
    self.collectionView.frame = CGRectMake(0, line.bottom, self.contentView.width, self.contentView.height - line.bottom - kResidentFilterViewBtnHeight-SafeAreaBottomHeight);
    [self.contentView addSubview:self.collectionView];
    
    UIButton *resetBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    resetBtn.frame = CGRectMake(0, self.collectionView.bottom ,self.contentView.width/2, kResidentFilterViewBtnHeight);
    resetBtn.backgroundColor = [UIColor whiteColor];
    [resetBtn setTitle:@"重置" forState:UIControlStateNormal];
    [resetBtn setTitleColor:UIColorFromRGB(0xff9000) forState:UIControlStateNormal];
    resetBtn.titleLabel.font = [UIFont systemFontOfSize:18];
    [resetBtn addTarget:self action:@selector(resetBtnPressed:) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:resetBtn];
    
    UIView *bottomLine = [[UIView alloc]initWithFrame:CGRectMake(0, 0, resetBtn.width, 0.5)];
    bottomLine.backgroundColor = UIColorFromRGB(0xdedede);
    [resetBtn addSubview:bottomLine];
    
    
    UIButton *doneBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    doneBtn.frame = CGRectMake(resetBtn.right, resetBtn.y ,resetBtn.width, resetBtn.height);
    doneBtn.backgroundColor = UIColorFromRGB(0xff9000);
    [doneBtn setTitle:@"完成" forState:UIControlStateNormal];
    [doneBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    doneBtn.titleLabel.font = [UIFont systemFontOfSize:18];
    [doneBtn addTarget:self action:@selector(doneBtnPressed:) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:doneBtn];
}
- (void)dealloc
{
    NSLog(@"%@---- 释放了",NSStringFromClass([self class]));
}

- (void)show
{
    if (![[UIApplication sharedApplication].keyWindow.subviews containsObject:self]) {
        [[UIApplication sharedApplication].keyWindow addSubview:self];
    }
    self.hidden = NO;
    [UIView animateWithDuration:kResidentFilterViewDuration
                     animations:^{
                         self.backgroundColor = RGBA(0, 0, 0, 0.5);
                         self.contentView.right = self.width;
                     }
                     completion:nil];
}

- (void)hide
{
    [UIView animateWithDuration:kResidentFilterViewDuration animations:^{
        self.backgroundColor = RGBA(0, 0, 0, 0);
        self.contentView.left = self.width;
    } completion:^(BOOL finished) {
        self.hidden = YES;
    }];
}
#pragma mark ---- Click

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = [touches anyObject];
    CGPoint point = [touch  locationInView:self.contentView];
    BOOL isLocation = CGRectContainsPoint(self.contentView.bounds, point);
    
    if (isLocation) {
        
        [self.nextResponder touchesBegan:touches withEvent:event];
    }
    else
    {
        [self uselessClear];
        [self hide];
    }
}
- (void)resetBtnPressed:(UIButton *)sender
{
    [self.usedArray removeAllObjects];
    [self uselessClear];
}
- (void)doneBtnPressed:(UIButton *)sender
{
    if (self.selectedComplete) {
        self.selectedComplete();
    }
    for (InterviewInputModel *uiModel in self.uiArray) {
        if (uiModel.contentStr.integerValue != -1) {
            [self.usedArray addObject:uiModel];
        }
    }
    [self hide];
}
- (void)handleSwipe:(UISwipeGestureRecognizer *)recognizer {
    [self uselessClear];
    [self hide];
};
#pragma mark --UICollectionView dataSource

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{

    return self.uiArray.count;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    InterviewInputModel *uiModel = self.uiArray[section];
    return uiModel.options.count;
}
//每个单元格的数据
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    InterviewInputModel *uiModel = self.uiArray[indexPath.section];
    ResidentFilterCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([ResidentFilterCell class]) forIndexPath:indexPath];
    cell.contentLabel.text = uiModel.options[indexPath.row];
    if (uiModel.contentStr.integerValue == indexPath.row) {
        cell.isSelected = YES;
    }
    else
    {
        cell.isSelected = NO;
    }
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    return CGSizeMake((collectionView.width - 50)/3, 30);
}
-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section{
    return UIEdgeInsetsMake(10, 10, 10, 10);
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section{
    
        return CGSizeMake(collectionView.width,40);
}
-(UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath{

    if (kind == UICollectionElementKindSectionHeader) {
        InterviewInputModel *uiModel = self.uiArray[indexPath.section];
        ResidentFilterHeaderView *reusableView =  [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:NSStringFromClass([ResidentFilterHeaderView class]) forIndexPath:indexPath];
        reusableView.titleLabel.text = uiModel.title;
        return reusableView;
    }
    return nil;
}
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    InterviewInputModel *uiModel = self.uiArray[indexPath.section];
    if (uiModel.contentStr.integerValue == indexPath.row) {
        uiModel.contentStr = @"-1";
    }
    else
    {
        uiModel.contentStr = [NSString stringWithFormat:@"%ld",(long)indexPath.row];
    }
    NSIndexSet *reloadSet = [NSIndexSet indexSetWithIndex:indexPath.section];
    [collectionView reloadSections:reloadSet];
    switch (indexPath.section) {
        case 0:
        {

            self.putModel.cmKind = uiModel.contentStr.integerValue == -1 ? nil : [NSString stringWithFormat:@"%ld",indexPath.row+1];
        }
            
            break;
        case 1:
        {
            self.putModel.gender = uiModel.contentStr.integerValue == -1 ? nil : [NSString stringWithFormat:@"%ld",indexPath.row+1];
        }
            
            break;
        case 2:
        {
            NSInteger index = 0;
            switch (indexPath.row) {
                case 0:
                    uiModel.contentStr = @"-1";
                    break;
                case 1: case 2: case 3:
                    index = indexPath.row - 1;
                    break;
                case 4:
                    index = 99;
                    break;
                case 5:
                    index = 3;
                    break;
                default:
                break;
            }
            self.putModel.isStatus = uiModel.contentStr.integerValue == -1 ? nil : [NSString stringWithFormat:@"%ld",index];
        }
            break;
        case 3:
        {
            switch (indexPath.row) {
                case 0:
                    self.putModel.itemPerfect = uiModel.contentStr.integerValue == -1 ? nil : @"1";
                    break;
                case 1:
                    self.putModel.itemPerfect = uiModel.contentStr.integerValue == -1 ? nil : @"4";
                    break;
                default:
                    break;
            }
        }
            break;
        case 4:
        {
            switch (indexPath.row) {
                case 0:
                    self.putModel.isPoor = uiModel.contentStr.integerValue == -1 ? nil : @"2";
                    break;
                case 1:
                    self.putModel.isPoor = uiModel.contentStr.integerValue == -1 ? nil : @"1";
                    break;
                default:
                    break;
            }
        }
            break;
        case 5:
        {
            switch (indexPath.row) {
                case 0:
                    self.putModel.isFlowing = uiModel.contentStr.integerValue == -1 ? nil : @"1";
                    break;
                case 1:
                    self.putModel.isFlowing = uiModel.contentStr.integerValue == -1 ? nil : @"0";
                    break;
                default:
                    break;
            }
        }
            break;
        case 6:
        {
            switch (indexPath.row) {
                case 0:
                    self.putModel.isSign = uiModel.contentStr.integerValue == -1 ? nil : @"1";
                    break;
                case 1:
                    self.putModel.isSign = uiModel.contentStr.integerValue == -1 ? nil : @"0";
                    break;
                default:
                    break;
            }
        }
            break;
        default:
            break;
    }
}
#pragma mark ---- 没有使用的清空

- (void)uselessClear
{
    for (InterviewInputModel *uiModel in self.uiArray) {
        if (![self.usedArray containsObject:uiModel]) {
            if ([uiModel.propertyName isEqualToString:@"isStatus"]) {
                uiModel.contentStr = @"1";
                [self.putModel setValue:@"0" forKey:uiModel.propertyName];
            }else{
                uiModel.contentStr = @"-1";
                [self.putModel setValue:nil forKey:uiModel.propertyName];
            }
            
            
        }
    }
    [self.collectionView reloadData];
}

#pragma mark --- Setter Getter

- (UICollectionView *)collectionView
{
    if (!_collectionView) {
        
        UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc]init];
        flowLayout.minimumInteritemSpacing = 10.f;
        flowLayout.minimumLineSpacing = 10.f;
        [flowLayout setScrollDirection:UICollectionViewScrollDirectionVertical];
        
        _collectionView = [[UICollectionView alloc]initWithFrame:CGRectZero collectionViewLayout:flowLayout];
        _collectionView.backgroundColor = [UIColor whiteColor];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        _collectionView.contentInset = UIEdgeInsetsMake(0, 5, 0, 5);
        
        NSString *cellClassName = NSStringFromClass([ResidentFilterCell class]);
        
        [_collectionView registerNib:[UINib nibWithNibName:cellClassName bundle:nil] forCellWithReuseIdentifier:cellClassName];
        
        [_collectionView registerNib:[UINib nibWithNibName:NSStringFromClass([ResidentFilterHeaderView class]) bundle:nil] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:NSStringFromClass([ResidentFilterHeaderView class])];
        
        UISwipeGestureRecognizer *recognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self                                                                                    action:@selector(handleSwipe:)];
        recognizer.direction = UISwipeGestureRecognizerDirectionRight;
        [_collectionView addGestureRecognizer:recognizer];
        
    }
    return _collectionView;
}

- (NSMutableArray *)uiArray
{
    if (!_uiArray) {
        _uiArray = [NSMutableArray array];
        NSData *jsonData = [NSData dataWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"ResidentFilterModel" ofType:@"json"]];
        NSArray *jsonArray = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableContainers error:nil];
        _uiArray = [InterviewInputModel mj_objectArrayWithKeyValuesArray:jsonArray];
    }
    return _uiArray;
}

@end
