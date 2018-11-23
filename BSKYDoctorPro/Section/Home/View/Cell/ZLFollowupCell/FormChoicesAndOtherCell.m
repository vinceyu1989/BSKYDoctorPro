//
//  FormChoicesAndOtherCell.m
//  BSKYDoctorPro
//
//  Created by 何雷 on 2018/2/28.
//  Copyright © 2018年 ky. All rights reserved.
//

#import "FormChoicesAndOtherCell.h"
#import "CATPlaceHolderTextView.h"
#import "SDCollectionTagsFlowLayout.h"
#import "FollowupSymptomItemCell.h"

@interface FormChoicesAndOtherCell()
<UICollectionViewDelegate,
UICollectionViewDataSource,
UICollectionViewDelegateFlowLayout,
UITextViewDelegate
>

@property (nonatomic ,strong) UILabel *titleLabel;

@property (nonatomic ,strong) UILabel *requiredIcon;

@property (nonatomic ,strong) UICollectionView *collectionView;

@property (nonatomic ,strong) CATPlaceHolderTextView *textView;

@property (nonatomic ,strong) NSArray *tags;

@property (nonatomic, strong) NSMutableArray *selectedArray;   // tag

@end


@implementation FormChoicesAndOtherCell

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
    self.titleLabel = [[UILabel alloc]init];
    self.titleLabel.font = [UIFont systemFontOfSize:14];
    self.titleLabel.textColor = UIColorFromRGB(0x666666);
    [self addSubview:self.titleLabel];
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self);
        make.left.equalTo(self.mas_left).offset(15);
    }];
    
    self.requiredIcon = [[UILabel alloc]init];
    self.requiredIcon.font = [UIFont systemFontOfSize:17];
    self.requiredIcon.textColor = UIColorFromRGB(0xff2a2a);
    self.requiredIcon.text = @"*";
    [self addSubview:self.requiredIcon];
    [self.requiredIcon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.titleLabel.mas_right);
        make.centerY.equalTo(self.titleLabel.mas_centerY);
    }];
    
    [self addSubview:self.collectionView];
    [self addSubview:self.textView];
    [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.titleLabel.mas_bottom);
        make.left.equalTo(self).offset(kFollowupSymptomCellMargin);
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

- (void)setUiModel:(InterviewInputModel *)uiModel
{
    [super setUiModel:uiModel];
    self.titleLabel.text = self.uiModel.title;
    self.requiredIcon.hidden = !([self.uiModel.title isNotEmptyString] && self.uiModel.isRequired);
    self.tags = self.uiModel.options;
    self.textView.placeholder = self.uiModel.otherModel.placeholder;
    self.textView.text = self.uiModel.otherModel.contentStr;
    [self configSelectedArray];
    NSInteger titleHeight = [self.uiModel.title isNotEmptyString] ? 45 : kFollowupSymptomCellMargin;
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(@(titleHeight)).priorityHigh();
    }];
    [self.collectionView reloadData];
    [self.collectionView layoutIfNeeded];
    [self.collectionView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(@(self.collectionView.contentSize.height)).priorityHigh();
    }];
}
- (void)configSelectedArray
{
    [self.selectedArray removeAllObjects];
    NSArray  *stringArray = [self.uiModel.contentStr componentsSeparatedByString:@","];
    self.selectedArray = [NSMutableArray arrayWithArray:stringArray];
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
        [self configData];
    }
}
- (void)configData
{
    NSString *contentStr = @"";
    for (int i = 0; i<self.selectedArray.count; i++) {
        NSString *str = self.selectedArray[i];
        contentStr = [contentStr stringByAppendingFormat:@"%@,",str];
    }
    if (contentStr.length >= 1) {
        contentStr = [contentStr substringToIndex:contentStr.length-1];
        self.uiModel.contentStr = contentStr;
    }
    else
    {
        self.uiModel.contentStr = nil;
    }
    self.uiModel.otherModel.contentStr = self.textView.text;
    if (self.delegate && [self.delegate respondsToSelector:@selector(formBaseCell:configData:)]) {
        [self.delegate formBaseCell:self configData:self.uiModel];
    }
}

@end
