//
//  AllFormsSymptomCell.m
//  BSKYDoctorPro
//
//  Created by 何雷 on 2017/11/27.
//  Copyright © 2017年 ky. All rights reserved.
//

#import "AllFormsSymptomCell.h"
#import "CATPlaceHolderTextView.h"
#import "SDCollectionTagsFlowLayout.h"
#import "FollowupSymptomItemCell.h"

@interface AllFormsSymptomCell()
<UICollectionViewDelegate,
UICollectionViewDataSource,
UICollectionViewDelegateFlowLayout,
UITextViewDelegate
>

@property (nonatomic ,strong) UICollectionView *collectionView;

@property (nonatomic ,strong) CATPlaceHolderTextView *textView;

@property (nonatomic ,strong) NSArray *tags;

@property (nonatomic, strong) NSMutableArray *selectedArray;   // tag

@property (nonatomic ,assign) NSInteger contentIndex;
@end


@implementation AllFormsSymptomCell

static CGFloat const kFollowupSymptomCellTextViewHeight = 100;
static CGFloat const kFollowupSymptomCellMargin = 15;

- (void)awakeFromNib {
    [super awakeFromNib];
}
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectedArray = [NSMutableArray array];
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
    [self addSubview:self.textView];
    [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.equalTo(self).offset(kFollowupSymptomCellMargin);
        make.width.equalTo(@(SCREEN_WIDTH - 2*kFollowupSymptomCellMargin));
        make.bottom.equalTo(self.mas_bottom).offset(-(2*kFollowupSymptomCellMargin + kFollowupSymptomCellTextViewHeight));
    }];
    [self.textView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.collectionView);
        make.top.equalTo(self.collectionView.mas_bottom).offset(kFollowupSymptomCellMargin);
        make.height.equalTo(@(kFollowupSymptomCellTextViewHeight));
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
- (CATPlaceHolderTextView *)textView
{
    if (!_textView) {
        _textView = ({
            CATPlaceHolderTextView* textView = [[CATPlaceHolderTextView alloc]init];
            textView.placeholder = @"请输入其他症状";
            textView.layer.borderColor = UIColorFromRGB(0xededed).CGColor;
            textView.layer.borderWidth = 1.0f;
            textView.layer.cornerRadius = 7;
            textView.font = [UIFont systemFontOfSize:14 weight:UIFontWeightLight];
            if (LESS_IOS8_2) {
                textView.font = [UIFont systemFontOfSize:14];
            }
            textView.delegate = self;
            
            textView;
        });
    }
    return _textView;
}
#pragma mark --- Setter

- (void)setModel:(InterviewInputModel *)model
{
    _model = model;
    self.tags = _model.options;
    self.textView.text = _model.placeholder;
    self.contentIndex = self.model.contentStr.integerValue;
    [self.collectionView reloadData];
    [self.collectionView layoutIfNeeded];
    [self configData];
    [self.collectionView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(@(self.collectionView.contentSize.height)).priorityHigh();
    }];
}
- (void)setContentIndex:(NSInteger)contentIndex
{
    _contentIndex = contentIndex;
    NSString *str = [NSString toBinary:contentIndex];
    [self.selectedArray removeAllObjects];
    if (str.integerValue == 1) {
        [self.selectedArray addObject:self.tags[0]];
        return;
    }
    switch (((NSString *)self.model.object).integerValue) {
        case FollowupTypeHypertension:
            if (str.length < 1) {
                return;
            }
            str = [str substringToIndex:str.length-1];
            for (int i = 0; i < 8; i++) {
                NSInteger strIndex = str.length-i-1;
                if (strIndex < 0) {
                    break;
                }
                NSString *isStr = [str substringWithRange:NSMakeRange(strIndex, 1)];
                if ([isStr isEqualToString:@"1"]) {
                    [self.selectedArray addObject:self.tags[i+1]];
                }
            }
            break;
        case FollowupTypeDiabetes:
            if (str.length < 9) {
                return;
            }
            str = [str substringToIndex:str.length-9];
            for (int i = 0; i < 8; i++) {
                NSInteger strIndex = str.length-i-1;
                if (strIndex < 0) {
                    break;
                }
                NSString *isStr = [str substringWithRange:NSMakeRange(strIndex, 1)];
                if ([isStr isEqualToString:@"1"]) {
                    [self.selectedArray addObject:self.tags[i+1]];
                }
            }
            break;
        case FollowupTypeGaoTang:
            if (str.length < 1) {
                return;
            }
            str = [str substringToIndex:str.length-1];
            for (int i = 0; i < 16; i++) {
                NSInteger strIndex = str.length-i-1;
                if (strIndex < 0) {
                    break;
                }
                NSString *isStr = [str substringWithRange:NSMakeRange(strIndex, 1)];
                if ([isStr isEqualToString:@"1"]) {
                    [self.selectedArray addObject:self.tags[i+1]];
                }
            }
            break;
        default:
            break;
    }
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
    cell.selected = [self.selectedArray containsObject:cell.titleLabel.text];
    return cell;
}
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0) {
        [self.selectedArray removeAllObjects];
        [self.selectedArray addObject:self.tags[indexPath.row]];
        self.textView.text = nil;
    }
    else
    {
        if (self.selectedArray.count == 1) {
            NSString *str = self.selectedArray[0];
            if ([str isEqualToString:self.tags[0]]) {
                [self.selectedArray removeAllObjects];
            }
        }
        NSString *str = self.tags[indexPath.row];
        if (![self.selectedArray containsObject:str]) {
//            if (self.selectedArray.count >= 5 ) {
//                [UIView makeToast:@"最多只能选择5个症状"];
//                [collectionView deselectItemAtIndexPath:indexPath animated:NO];
//                return ;
//            }
            [self.selectedArray addObject:str];
        }
        else
        {
            [self.selectedArray removeObject:str];
        }
    }
    [collectionView reloadData];
    [self configData];
}
#pragma mark --- UITextViewDelegate
- (void)textViewDidChange:(UITextView *)textView {
    if (self.selectedArray.count == 1) {
        NSString *str = self.selectedArray[0];
        if ([str isEqualToString:self.tags[0]]) {
            [self.selectedArray removeAllObjects];
            [self.collectionView reloadData];
        }
    }
    [self configData];
}
- (void)textViewDidEndEditing:(UITextView *)textView
{
    if (textView.text.length < 1 && self.selectedArray.count < 1) {
        [self.selectedArray addObject:self.tags[0]];
        [self.collectionView reloadData];
    }
    [self configData];
}
- (void)configData
{
    NSInteger index = 0;
    
    if (self.selectedArray.count < 1)
    {
        index = 0;
    }
    else
    {
        NSString *str = self.selectedArray[0];
        if ([str isEqualToString:self.tags[0]]){    // 无症状
            index = pow(2, 0);
        }
        else
        {
            for (NSString *str in self.selectedArray) {
                
                for (int i = 1; i<self.tags.count; i++) {
                    
                    if ([str isEqualToString:self.tags[i]]) {
                        switch (((NSString *)self.model.object).integerValue) {
                            case FollowupTypeHypertension: case FollowupTypeGaoTang:
                                index = index + pow(2,i);
                                break;
                            case FollowupTypeDiabetes:
                                index = index + pow(2,i+8);
                                break;
                            default:
                                break;
                        }
                    }
                }
            }
        }
    }
    if (self.textView.text.length > 0) {
        index = index + pow(2, 17);
    }
    self.upModel.cmModel.symptom = index < 1 ? nil :@(index);
    [self addOtherModelWithStr:self.textView.text];
    self.model.placeholder = self.textView.text;
    self.model.contentStr = [NSString stringWithFormat:@"%ld",(long)index];
}
#pragma mark ----- 添加OtherModel
- (void)addOtherModelWithStr:(NSString *)str
{
    BOOL isHave = NO;
    NSInteger index = -1;
    for (Other *otherModel in self.upModel.other) {
        if ([otherModel.attrName isEqualToString:@"Symptom"]) {
            if (!str || str.length < 1) {
                index = [self.upModel.other indexOfObject:otherModel];
            }
            else
            {
               otherModel.otherText = str;
            }
            isHave = YES;
            break;
        }
    }
    if (index >= 0) {
         [self.upModel.other removeObjectAtIndex:index];
    }
    if (!isHave && str.length > 0) {
        Other *otherModel = [[Other alloc]init];
        otherModel.attrName = @"Symptom";
        otherModel.otherText = str;
        [self.upModel.other addObject:otherModel];
    }
}

@end
