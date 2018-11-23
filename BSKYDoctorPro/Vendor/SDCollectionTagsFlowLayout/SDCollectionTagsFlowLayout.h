//
//  SDCollectionTagsFlowLayout.h
//  SDTagsView
//
//  Created by slowdony on 2017/9/23.
//  Copyright © 2017年 slowdony. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger,TagsType){
    TagsTypeWithLeft,
    TagsTypeWithCenter,
    TagsTypeWithRight 
};
@interface SDCollectionTagsFlowLayout : UICollectionViewFlowLayout

//cell对齐方式
@property (nonatomic,assign)TagsType cellType;

-(instancetype)initWthType:(TagsType)cellType;

@end
