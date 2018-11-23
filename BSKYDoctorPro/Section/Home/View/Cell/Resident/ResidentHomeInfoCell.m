//
//  ResidentHomeInfoCell.m
//  BSKYDoctorPro
//
//  Created by 何雷 on 2018/1/19.
//  Copyright © 2018年 ky. All rights reserved.
//

#import "ResidentHomeInfoCell.h"
#import "SDCollectionTagsFlowLayout.h"
#import "ResidentHomeTagCell.h"
#import "UIButton+BSKY.h"

@interface ResidentHomeInfoCell()<UICollectionViewDelegate,UICollectionViewDataSource>

@property (weak, nonatomic) IBOutlet UILabel *fileNoLabel;
@property (weak, nonatomic) IBOutlet UILabel *fileCustomNoLabel;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *sexLabel;
@property (weak, nonatomic) IBOutlet UILabel *ageLabel;
@property (weak, nonatomic) IBOutlet UIImageView *avatarImageView;
@property (weak, nonatomic) IBOutlet UIButton *phoneBtn;
@property (weak, nonatomic) IBOutlet UILabel *idCardLabel;
@property (weak, nonatomic) IBOutlet UILabel *addressLabel;
@property (weak, nonatomic) IBOutlet UICollectionView *tagsView;
@property (weak, nonatomic) IBOutlet SDCollectionTagsFlowLayout *flowLayout;
@property (weak, nonatomic) IBOutlet UILabel *fileStatusLabel;
@property (weak, nonatomic) IBOutlet UIImageView *shenIcon;
@property (weak, nonatomic) IBOutlet UIImageView *jiIcon;
@property (weak, nonatomic) IBOutlet UIButton *jiBtn;
@property (weak, nonatomic) IBOutlet UIButton *familyArchivesBtn;
@property (weak, nonatomic) IBOutlet UIButton *healthArchivesBtn;
@property (nonatomic, strong) NSMutableArray * tagArray;

@end

@implementation ResidentHomeInfoCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.tagArray = [NSMutableArray array];
    self.flowLayout.cellType = TagsTypeWithLeft;
    self.flowLayout.scrollDirection = UICollectionViewScrollDirectionVertical;
    self.flowLayout.minimumInteritemSpacing = 10;
    self.flowLayout.minimumLineSpacing = 10;
    self.tagsView.delegate = self;
    self.tagsView.dataSource = self;
    [self.tagsView registerClass:[ResidentHomeTagCell class] forCellWithReuseIdentifier:NSStringFromClass([ResidentHomeTagCell class])];
    [self.tagsView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(@(SCREEN_WIDTH - 2*13 - 90)).priorityHigh();
    }];
    [self.tagsView reloadData];
    [self.tagsView layoutIfNeeded];
    self.avatarImageView.layer.borderColor = [UIColor whiteColor].CGColor;
    self.avatarImageView.layer.borderWidth = 5.f;
    [self.jiBtn addUnderLine];
    [self.familyArchivesBtn addUnderLine];
    [self.healthArchivesBtn addUnderLine];
}
- (void)setModel:(PersonColligationModel *)model
{
    _model = model;
    [self.tagArray removeAllObjects];
    self.fileNoLabel.text = _model.personCode;
    self.fileCustomNoLabel.text = _model.customNumber;
    self.nameLabel.text = _model.name;
    self.sexLabel.text = _model.gender;
    self.ageLabel.text = _model.age;
    [self.phoneBtn setTitle:[_model.telphone secretStrFromPhoneStr] forState:UIControlStateNormal];
    self.idCardLabel.text = [_model.cardId secretStrFromIdentityCard];
    self.addressLabel.text = _model.address;
    self.fileStatusLabel.text = _model.hrStatus;
    if ([_model.tG isNotEmptyString]) {
        [self.tagArray addObject:@"高血压"];
    }
    if ([_model.tH isNotEmptyString]) {
        [self.tagArray addObject:@"结核病"];
    }
    if ([_model.tJ isNotEmptyString]) {
        [self.tagArray addObject:@"重性精神病"];
    }
    if ([_model.tT isNotEmptyString]) {
        [self.tagArray addObject:@"糖尿病"];
    }
    [self.tagsView reloadData];
    [self.tagsView layoutIfNeeded];
    CGFloat height = self.tagsView.collectionViewLayout.collectionViewContentSize.height;
    [self.tagsView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(@(height)).priorityHigh();
    }];
    if (_model.healthCardState.integerValue == HealthCardStateInactivated) {
        self.shenIcon.image = [UIImage imageNamed:@"icon_shen"];
        self.jiIcon.image = [UIImage imageNamed:@"icon_ji_un"];
        self.jiBtn.hidden = NO;
        [self.jiBtn setTitle:@"去激活>" forState:UIControlStateNormal];
    }
    else if (_model.healthCardState.integerValue == HealthCardStateActivated)
    {
        self.shenIcon.image = [UIImage imageNamed:@"icon_shen"];
        self.jiIcon.image = [UIImage imageNamed:@"icon_ji"];
        self.jiBtn.hidden = YES;
    }
    else
    {
        self.shenIcon.image = [UIImage imageNamed:@"icon_shen_un"];
        self.jiIcon.image = [UIImage imageNamed:@"icon_ji_un"];
        self.jiBtn.hidden = NO;
        [self.jiBtn setTitle:@"去申领>" forState:UIControlStateNormal];
    }
    
    
}
- (void)setImageDataStr:(NSString *)imageDataStr
{
    _imageDataStr = imageDataStr;
    UIImage *image = [UIImage imageWithBase64Str:_imageDataStr];
    if (image) {
        self.avatarImageView.image = image;
    }
    else
    {
        self.avatarImageView.image = [UIImage imageNamed:@"avatar_resident"];
    }
}
#pragma mark --- UICollectionViewDataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.tagArray.count;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *str = self.tagArray[indexPath.row];
    CGSize size = [str sizeWithFont:[UIFont systemFontOfSize:12] maxSize:CGSizeMake(SCREEN_WIDTH-50-20, 20)];
    return CGSizeMake(size.width+20,20);
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    ResidentHomeTagCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([ResidentHomeTagCell class]) forIndexPath:indexPath];
    cell.contentLabel.text = self.tagArray[indexPath.row];
    return cell;
}
- (IBAction)phoneBtnPressed:(UIButton *)sender {
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(residentHomeInfoCellPhoneBtnPressed:)]) {
        [self.delegate residentHomeInfoCellPhoneBtnPressed:self];
    }
}
- (IBAction)jiBtnPressed:(UIButton *)sender {
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(residentHomeInfoCellJiBtnPressed:)]) {
        [self.delegate residentHomeInfoCellJiBtnPressed:self];
    }
}

- (IBAction)familyArchivesBtnPressed:(UIButton *)sender {
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(residentHomeInfoCellFamilyArchivesBtnPressed:)]) {
        [self.delegate residentHomeInfoCellFamilyArchivesBtnPressed:self];
    }
}
- (IBAction)healthArchivesBtnPressed:(UIButton *)sender {
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(residentHomeInfoCellHealthArchivesBtnPressed:)]) {
        [self.delegate residentHomeInfoCellHealthArchivesBtnPressed:self];
    }
}

@end
