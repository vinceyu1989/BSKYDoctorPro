//
//  HomeMenuView.m
//  BSKYDoctorPro
//
//  Created by 何雷 on 2017/8/18.
//  Copyright © 2017年 ky. All rights reserved.
//

#import "HomeMenuView.h"
#import "GridItemModel.h"
#import "HomeGridItemButton.h"

@interface HomeMenuView ()

@property (nonatomic, strong) NSMutableArray *itemBtnArray;

@end

@implementation HomeMenuView

static NSInteger const kHomeMenuViewBtnTag = 300;    // 列

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.itemBtnArray = [NSMutableArray array];
    }
    return self;
}
- (void)awakeFromNib
{
    [super awakeFromNib];
    self.itemBtnArray = [NSMutableArray array];
}

- (void)setModelArray:(NSMutableArray *)modelArray
{
    _modelArray = modelArray;
    
    [self.itemBtnArray removeAllObjects];
    
    for (UIView *view in self.subviews) {
        [view removeFromSuperview];
    }
    [self setNeedsLayout];
    CGFloat itemW = self.width/3;
    CGFloat itemH = self.height/4;
    for (int i = 0; i<_modelArray.count; i++) {
        
        GridItemModel *model = _modelArray[i];
        HomeGridItemButton *itemBtn = [[HomeGridItemButton alloc]initWithFrame:CGRectMake(i%3*itemW, i/3*itemH, itemW, itemH)];
        [itemBtn setExclusiveTouch:YES];
        itemBtn.redPiont.hidden = YES;
        [itemBtn setTitle:model.title forState:UIControlStateNormal];
        [itemBtn setImage:[UIImage imageNamed:model.imageStr] forState:UIControlStateNormal];
        itemBtn.tag =  300+i;
        [itemBtn addTarget:self action:@selector(btnPressed:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:itemBtn];
        [self.itemBtnArray addObject:itemBtn];
    }
    
    for (int i = 0; i<2; i++) {
        UIView *line = [[UIView alloc]initWithFrame:CGRectMake(itemW*(i+1), 0, 0.5, self.height)];
        line.backgroundColor = UIColorFromRGB(0xededed);
        [self addSubview:line];
    }
    for (int i = 0; i<3; i++) {
        
        UIView *line = [[UIView alloc]initWithFrame:CGRectMake(0,itemH*(i+1), self.width , 0.5)];
        line.backgroundColor = UIColorFromRGB(0xededed);
        [self addSubview:line];
    }
    
}
- (void)setRedArray:(NSMutableArray *)redArray
{
    _redArray = redArray;
    
    for (NSNumber *index in redArray) {
        HomeGridItemButton *item = _itemBtnArray[index.integerValue];
        item.redPiont.hidden = NO;
    }
}
- (void)setRedPointIndex:(NSUInteger )index on:(BOOL)on{
    if (index < _itemBtnArray.count) {
        HomeGridItemButton *item = _itemBtnArray[index];
        item.redPiont.hidden = !on;
    }
}
- (void)btnPressed:(HomeGridItemButton *)sender
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(homeMenuView:selectItemAtIndex:)]) {
        [self.delegate homeMenuView:self selectItemAtIndex:sender.tag - kHomeMenuViewBtnTag];
    }
}


@end
