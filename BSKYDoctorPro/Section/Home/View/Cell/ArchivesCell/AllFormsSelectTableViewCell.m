//
//  AllFormsSelectTableViewCell.m
//  BSKYDoctorPro
//
//  Created by 快医科技 on 2018/1/3.
//  Copyright © 2018年 ky. All rights reserved.
//

#import "AllFormsSelectTableViewCell.h"
#import "CATPlaceHolderTextView.h"
#import "SDCollectionTagsFlowLayout.h"
#import "FollowupSymptomItemCell.h"

@interface AllFormsSelectTableViewCell ()<UICollectionViewDelegate,
UICollectionViewDataSource,
UICollectionViewDelegateFlowLayout,
UITextViewDelegate
>

@property (nonatomic ,strong) UICollectionView *collectionView;

@property (nonatomic ,strong) CATPlaceHolderTextView *textView;

@property (nonatomic ,strong) NSArray *tags;

@property (nonatomic, strong) NSMutableArray *selectedArray;   // tag

@property (nonatomic ,assign) NSInteger contentIndex;

@property (nonatomic ,strong) UILabel *titleLable;

@property (nonatomic ,strong) UIView *lineView;

@end

@implementation AllFormsSelectTableViewCell

static CGFloat const kFollowupSymptomCellTextViewHeight = 100;
static CGFloat const kFollowupSymptomCellMargin = 15;
static CGFloat const kFollowupSymptomCellTitleHeight = 20;

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
    [self addSubview:self.titleLable];
    [self addSubview:self.collectionView];
    [self addSubview:self.textView];
    [self addSubview:self.lineView];
    
    self.cellWidth = SCREEN_WIDTH;
    [self.titleLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.equalTo(self).offset(kFollowupSymptomCellMargin);
        make.right.equalTo(self.mas_right).offset(-kFollowupSymptomCellMargin);
        make.height.equalTo(@(kFollowupSymptomCellTitleHeight));
    }];
    
    [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(kFollowupSymptomCellMargin);
        make.top.equalTo(self.titleLable.mas_bottom).offset(kFollowupSymptomCellMargin);
//        make.right.equalTo(self.mas_right).offset(-kFollowupSymptomCellMargin);
        make.width.equalTo(@(self.cellWidth - 2 * kFollowupSymptomCellMargin));
        make.bottom.equalTo(self.mas_bottom).offset(-(kFollowupSymptomCellMargin ));
    }];
    [self.textView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.collectionView);
        make.top.equalTo(self.collectionView.mas_bottom).offset(kFollowupSymptomCellMargin);
        make.height.equalTo(@(kFollowupSymptomCellTextViewHeight));
    }];
    [self.lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self).offset(-kFollowupSymptomCellMargin);
        make.left.equalTo(self).offset(kFollowupSymptomCellMargin);
        make.bottom.equalTo(self);
        make.height.mas_equalTo(0.5);
    }];
}

#pragma mark ---- Getter
- (UIView *)lineView{
    if (!_lineView) {
        _lineView = [[UIView alloc] init];
        _lineView.backgroundColor = UIColorFromRGB(0xededed);
    }
    return _lineView;
}
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
            textView.placeholder = self.model.placeholder;
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
- (UILabel *)titleLable{
    if (!_titleLable) {
        _titleLable = [[UILabel alloc] init];
        _titleLable.font = [UIFont systemFontOfSize:14];
        _titleLable.textColor = UIColorFromRGB(0x666666);
    }
    return _titleLable;
}
#pragma mark --- Setter
- (void)layoutConstraints{
    if (![[[self.tags lastObject] valueForKey:@"title"] containsString:@"其他"]) {
        return;
    }
    if (![self.selectedArray containsObject:[self.tags lastObject]]) {
        [self.textView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(@0);
        }];
    }else{
        [self.textView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(kFollowupSymptomCellTextViewHeight);
        }];
    }
    if (self.reloadLayout) {
        self.reloadLayout(nil);
    }
}
- (void)setModel:(BSArchiveModel *)model
{
    _model = model;
    self.tags = _model.selectModel.options;
    if (_model.type == ArchiveModelTypeSlectAndTextView) {
        if (_model.contentStr.length ) {
            self.textView.text = _model.contentStr;
        }else{
            self.textView.placeholder = _model.placeholder;
        }
    }
    self.contentIndex = self.model.contentStr.integerValue;
    
    if (_model.value.length) {
        if (self.model.selectModel.multiple) {
            for (ArchiveSelectOptionModel *option in self.model.selectModel.options) {
                NSInteger intValue = self.model.value.integerValue;
                NSInteger optionValue = option.value.integerValue;
                if (intValue & optionValue) {
                    [self.selectedArray addObject:option];
                }
            }
        }else{
            for (ArchiveSelectOptionModel *dic in self.model.selectModel.options) {
                if ([self.model.value isEqualToString:dic.value]) {
                    [self.selectedArray addObject:dic];
                }else if ([self.model.value containsString:[NSString stringWithFormat:@"%@_",dic.value]]) {
                    [self.selectedArray addObject:dic];
                }
            }
        }
    }else{
        //设置默认选择值为第一个选项
//        [self.selectedArray addObject:self.tags[0]];
//        self.model.value = [self.model.selectModel.options[0] valueForKey:@"value"];
    }
    
    self.titleLable.text = _model.title;
    
    if (self.model.title.length) {
        [self.titleLable mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.left.equalTo(self).offset(kFollowupSymptomCellMargin);
            make.right.equalTo(self.mas_right).offset(-kFollowupSymptomCellMargin);
            make.height.equalTo(@(kFollowupSymptomCellTitleHeight));
        }];
        
    }else{
        [self.titleLable mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.left.equalTo(self).offset(kFollowupSymptomCellMargin);
            make.right.equalTo(self.mas_right).offset(-kFollowupSymptomCellMargin);
            make.height.equalTo(@(0));
        }];
        
    }
//    [self.textView mas_updateConstraints:^(MASConstraintMaker *make) {
//        make.height.mas_equalTo(0);
//    }];
    if (self.model.type == ArchiveModelTypeSlectAndTextView) {
        if (self.isCollapsible) {
            if ([self.selectedArray containsObject:[self.tags lastObject]]) {
                [self.textView mas_updateConstraints:^(MASConstraintMaker *make) {
                    make.height.equalTo(@(kFollowupSymptomCellTextViewHeight));
                    [self.collectionView mas_remakeConstraints:^(MASConstraintMaker *make) {
                        make.left.equalTo(self).offset(kFollowupSymptomCellMargin);
                        make.top.equalTo(self.titleLable.mas_bottom).offset(kFollowupSymptomCellMargin);
                        //            make.right.equalTo(self.mas_right).offset(-kFollowupSymptomCellMargin);
                        make.width.equalTo(@(self.cellWidth - 2 * kFollowupSymptomCellMargin));
                        make.bottom.equalTo(self.mas_bottom).offset(-(2*kFollowupSymptomCellMargin + kFollowupSymptomCellTextViewHeight));
                    }];
                }];
            }else{
                [self.textView mas_updateConstraints:^(MASConstraintMaker *make) {
                    make.height.mas_equalTo(@0);
                }];
                [self.collectionView mas_remakeConstraints:^(MASConstraintMaker *make) {
                    make.left.equalTo(self).offset(kFollowupSymptomCellMargin);
                    make.top.equalTo(self.titleLable.mas_bottom).offset(kFollowupSymptomCellMargin);
                    //            make.right.equalTo(self.mas_right).offset(-kFollowupSymptomCellMargin);
                    make.width.equalTo(@(self.cellWidth - 2 * kFollowupSymptomCellMargin));
                    make.bottom.equalTo(self.mas_bottom).offset(-(2*kFollowupSymptomCellMargin));
                }];
            }
        }else{
            [self.textView mas_updateConstraints:^(MASConstraintMaker *make) {
                make.height.equalTo(@(kFollowupSymptomCellTextViewHeight));
            }];
            [self.collectionView mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(self).offset(kFollowupSymptomCellMargin);
                make.top.equalTo(self.titleLable.mas_bottom).offset(kFollowupSymptomCellMargin);
                //            make.right.equalTo(self.mas_right).offset(-kFollowupSymptomCellMargin);
                make.width.equalTo(@(self.cellWidth - 2 * kFollowupSymptomCellMargin));
                make.bottom.equalTo(self.mas_bottom).offset(-(2*kFollowupSymptomCellMargin + kFollowupSymptomCellTextViewHeight));
            }];
        }
       

    }else{
        [self.collectionView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self).offset(kFollowupSymptomCellMargin);
            make.top.equalTo(self.titleLable.mas_bottom).offset(kFollowupSymptomCellMargin);
//            make.right.equalTo(self.mas_right).offset(-kFollowupSymptomCellMargin);
            make.width.equalTo(@(self.cellWidth - 2 * kFollowupSymptomCellMargin));
            make.bottom.mas_equalTo(- kFollowupSymptomCellMargin);
        }];
        [self.textView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.right.equalTo(self.collectionView);
            make.top.equalTo(self.collectionView.mas_bottom).offset(kFollowupSymptomCellMargin);
            make.height.equalTo(@0);
        }];
    }
    if ([_model.code isEqualToString:@"Remark"]) {
        
    }
    [self.collectionView reloadData];
    [self.collectionView layoutIfNeeded];
    if ([self.model.selectModel.options count]) {
        [self.collectionView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(@(self.collectionView.contentSize.height)).priorityHigh();
        }];
        [self.textView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.collectionView.mas_bottom).offset(kFollowupSymptomCellMargin);
        }];
    }else{
        [self.collectionView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(@0);
        }];
        [self.textView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.titleLable.mas_bottom).offset(kFollowupSymptomCellMargin);
        }];
    }
    
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
    ArchiveSelectOptionModel *option = self.tags[indexPath.row];
    NSString *str = [option valueForKey:@"title"];
    CGSize size = [str sizeWithFont:[UIFont systemFontOfSize:14] maxSize:CGSizeMake(SCREEN_WIDTH-50-20, 30)];
    return CGSizeMake(size.width+20,30);
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    FollowupSymptomItemCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([FollowupSymptomItemCell class]) forIndexPath:indexPath];
    ArchiveSelectOptionModel *option = self.tags[indexPath.row];
    cell.titleLabel.text = option.title;
    cell.selected = [self.selectedArray containsObject:option];
    return cell;
}
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    ArchiveSelectOptionModel *option = self.tags[indexPath.row];
    if (self.model.selectModel.multiple) {
        NSInteger value = self.model.value.integerValue ? self.model.value.integerValue:0;
        if ([option.title containsString:@"无"] || [option.title isEqualToString:@"全自费"]) {
            [self.selectedArray removeAllObjects];
            [self.selectedArray addObject:option];
            self.textView.text = @"";
            self.model.contentStr = nil;
            value = [option.value integerValue];
        }else{
            if ([self.selectedArray containsObject:self.tags[0]]) {
                [self.selectedArray removeObject:self.tags[0]];
                ArchiveSelectOptionModel *optionW = self.tags[0];
                value = value - optionW.value.integerValue;
                [collectionView reloadData];
            }
            if ([self.selectedArray containsObject:option]) {
//                if ([self.selectedArray count] > 1) {
                    [self.selectedArray removeObject:option];
                    value = value - [option.value integerValue];
//                }
            }else{
                [self.selectedArray addObject:option];
                
                value = value + [option.value integerValue];
                
            }
        }
        self.model.value = [NSString stringWithFormat:@"%ld",value];
    }else{
        [self.selectedArray removeAllObjects];
        [self.selectedArray addObject:option];
        self.model.value = option.value;
        self.model.contentStr = option.title;
    }
    [collectionView reloadData];
    if ([option.title isEqualToString:@"其他"]) {
        if ([self.selectedArray containsObject:option]) {
//            if (self.otherBlock) {
//                self.otherBlock();
//            }
        }else{
            self.model.selectModel.others = nil;
            self.model.contentStr = nil;
            self.textView.text = nil;
        }
        if (self.isCollapsible) {
            [self layoutConstraints];
        }
    }
//    if (self.isCollapsible) {
//        [self layoutConstraints];
//    }
    
    
}
#pragma mark --- UITextViewDelegate
- (void)textViewDidChange:(UITextView *)textView {

    self.model.contentStr = textView.text;
}
- (void)textViewDidEndEditing:(UITextView *)textView
{
    
}
- (BOOL )textViewShouldBeginEditing:(UITextView *)textView{
    if ([self.model.selectModel.options count]) {
        ArchiveSelectOptionModel *option = [self.model.selectModel.options lastObject];
        if (self.model.value.integerValue & [option.value integerValue]) {
            return YES;
        }
    }else{
        return YES;
    }
    return NO;
}
@end
