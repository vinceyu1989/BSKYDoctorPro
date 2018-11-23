//
//  SignFamilyPersonView.h
//  BSKYDoctorPro
//
//  Created by kykj on 2018/1/4.
//  Copyright © 2018年 ky. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SignFamilyArchiveModel.h"

@protocol FamilyPersonViewDelegate;
@interface SignFamilyPersonView : UIView

@property (nonatomic, strong) SignFamilyArchiveModel *model;
@property (nonatomic, weak) id<FamilyPersonViewDelegate> delegate;

- (void)showView;
- (void)dismissView;

@end

@protocol FamilyPersonViewDelegate <NSObject>

@optional
- (void)chooseFamilyPersonNum:(NSArray *)modelArr;
- (void)dismissFamilyView;

@end
