//
//  IMDetailLabelView.m
//  BSKYDoctorPro
//
//  Created by 快医科技 on 2018/5/17.
//  Copyright © 2018年 ky. All rights reserved.
//

#import "IMDetailLabelView.h"
#import "IMDataManager.h"
#import "SDCollectionTagsFlowLayout.h"
#import "IMDetailLabelCollectionViewCell.h"
#import "IMEXModel.h"

@interface IMDetailLabelView ()<UICollectionViewDelegate,UICollectionViewDataSource>
@property (weak, nonatomic)IBOutlet UICollectionView *collectionView;
@property (weak, nonatomic) IBOutlet UIView *contentView;
@property (nonatomic ,strong)NSMutableArray *selectArray;
@property (nonatomic ,strong)NSString *valueStr;
@property (nonatomic ,strong)NSArray *optionArray;
@property (nonatomic ,strong)NSString *nomailStr;
@end

@implementation IMDetailLabelView

- (instancetype)initWithFrame:(CGRect)frame selectArray:(NSMutableArray *)array value:(NSString *)value
{
    self = [[NSBundle mainBundle] loadNibNamed:@"IMDetailLabelView" owner:self options:nil].firstObject;
    if (self) {
        self.frame = frame;
        _selectArray = array;
        _valueStr = value;
        if (!array.count && [_valueStr containsString:@"{"]) {
            _valueStr = [[_valueStr mj_JSONObject] objectForKey:@"userLabel"];
        }
        [self initilationSelectArray];
        [self creatUI];
    }
    return self;
}
#pragma mark Data
- (void)initilationSelectArray{
    if (self.valueStr.length && !self.selectArray.count) {
        for (ArchiveSelectOptionModel *model in self.optionArray) {
            if (self.valueStr.integerValue & model.value.integerValue) {
                [self.selectArray addObject:model];
            }
        }
    }
}
- (NSArray *)optionArray{
    if (!_optionArray) {
        _optionArray = [[IMDataManager dataManager].IMSelectOptions objectForKey:@"im_crowd_tags"];
    }
    return _optionArray;
}
- (NSMutableArray *)selectArray{
    if (!_selectArray) {
        _selectArray = [[NSMutableArray alloc] init];
    }
    return _selectArray;
}
#pragma mark UI
-(void)creatUI{
    SDCollectionTagsFlowLayout *flowLayout = [[SDCollectionTagsFlowLayout alloc]initWthType:TagsTypeWithLeft];
    flowLayout.minimumInteritemSpacing = 10;
    flowLayout.minimumLineSpacing = 15;
    flowLayout.sectionInset = UIEdgeInsetsMake(20, 0, 20, 0);
    _collectionView.collectionViewLayout = flowLayout;
    _collectionView.delegate = self;
    _collectionView.dataSource = self;
    [_collectionView setBackgroundColor:[UIColor clearColor]];
    //        _collectionView
    //注册
    UINib *nib = [UINib nibWithNibName:@"IMDetailLabelCollectionViewCell" bundle: [NSBundle mainBundle]];
    //    [collectionView registerNib:nib forCellWithReuseIdentifier:HLChoosePhotoActionSheetCellIdentifier];
    [_collectionView registerNib:nib forCellWithReuseIdentifier:NSStringFromClass([IMDetailLabelCollectionViewCell class])];
    
    self.contentView.layer.cornerRadius = 14;
}
#pragma mark Action
- (IBAction)cancelAction:(id)sender {
    [self removeFromSuperview];
}
- (IBAction)determineAction:(id)sender {
//    [MBProgressHUD showHud];
//    [[NIMSDK sharedSDK].userManager updateUser:self.user completion:^(NSError *error) {
//        [MBProgressHUD ];
//        if (!error) {
//            [wself.navigationController.view makeToast:@"设置标签成功"
//                                              duration:2
//                                              position:CSToastPositionCenter];
//            [wself.navigationController popViewControllerAnimated:YES];
//        }else{
//            [wself.view makeToast:@"标签设置失败，请重试"
//                         duration:2
//                         position:CSToastPositionCenter];
//        }
//    }];
    if (self.block) {
        NSString *str = self.valueStr.integerValue > 0 ? self.valueStr : nil;
        self.block(str);
    }
    [self removeFromSuperview];
}
- (void)show{
//    [self.collectionView reloadData];
    [self.collectionView layoutIfNeeded];
//    [self.contentView layoutIfNeeded];
//    [self layoutIfNeeded];
//    if (self.optionArray.count) {
        CGFloat height = self.collectionView.contentSize.height + 90;
//    [self.contentView removeConstraints:self.contentView.constraints];
//        [self.contentView mas_remakeConstraints:^(MASConstraintMaker *make) {
//            make.right.left.mas_equalTo(40);
//            make.height.mas_equalTo(250);
//            make.centerX.centerY.equalTo(self);
//        }];
        [self.contentView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(height);
        }];
//    }
    [[UIApplication sharedApplication].keyWindow addSubview:self];
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
    return self.optionArray.count;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    ArchiveSelectOptionModel *option = self.optionArray[indexPath.row];
    NSString *str = option.lebel;
    CGSize size = [str sizeWithFont:[UIFont systemFontOfSize:12] maxSize:CGSizeMake(80, 30)];
    return CGSizeMake(size.width+25,30);
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    IMDetailLabelCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([IMDetailLabelCollectionViewCell class]) forIndexPath:indexPath];
    ArchiveSelectOptionModel *option = self.optionArray[indexPath.row];
    if ([self.selectArray containsObject:option]) {
        cell.selected = YES;
    }
    cell.option = option;
    return cell;
}
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    ArchiveSelectOptionModel *option = self.optionArray[indexPath.row];
    NSInteger value = self.valueStr.integerValue ? self.valueStr.integerValue:0;
    if ([self.selectArray containsObject:option]) {
        //                if ([self.selectedArray count] > 1) {
        [self.selectArray removeObject:option];
        value = value - [option.value integerValue];
        //                }
    }else{
        if ([option.title containsString:@"正常人群"]) {
            [self.selectArray removeAllObjects];
            [self.selectArray addObject:option];
            value = [option.value integerValue];
        }else{
            if (self.selectArray.count == 1) {
                ArchiveSelectOptionModel *model = [self.selectArray firstObject];
                if ([model.title isEqualToString:@"正常人群"]) {
                    [self.selectArray removeObject:model];
                    value = value - model.value.integerValue;
                }
            }
            [self.selectArray addObject:option];
            value = value + [option.value integerValue];
            
        }
    }
    
    self.valueStr = [NSString stringWithFormat:@"%ld",value];
    
    [collectionView reloadData];
}
@end
