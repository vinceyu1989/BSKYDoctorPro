//
//  BSContactView.h
//  BSKYDoctorPro
//
//  Created by LinfengYU on 2017/8/22.
//  Copyright © 2017年 ky. All rights reserved.
//

#import <UIKit/UIKit.h>

@class BSContactView;

@protocol BSContactViewDataSource <NSObject>

@required

/**
 分类的数量
 */
- (NSInteger)numberOfSectionsInView:(BSContactView*)contactView;

/**
 每个没类下联系人的数量
 */
- (NSInteger)contactView:(BSContactView*)contactView numberOfContactInSection:(NSInteger)section;

/**
 分类的名称
 */
- (NSString*)contactView:(BSContactView*)contactView titleForSection:(NSInteger)section;

/**
 联系人对象
 */
- (id)contactView:(BSContactView*)contactView contactForSection:(NSInteger)section index:(NSInteger)index; // TODO

/**
 所有的分类
 */
- (NSArray<NSString *> *)sectionIndexTitlesForContactView:(BSContactView *)contactView;

@end

@protocol BSContactViewDelegate <NSObject>

@optional
- (void)didSelectRowAtIndexPath:(NSIndexPath *)indexPath;

@end


@interface BSContactView : UIView

@property (nonatomic, weak) id<BSContactViewDataSource> dataSource;
@property (nonatomic, weak) id<BSContactViewDelegate> delegate;

- (void)reloadData;

@end
