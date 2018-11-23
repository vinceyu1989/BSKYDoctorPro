//
//  OrganTableView.h
//  BSKYDoctorPro
//
//  Created by kykj on 2017/11/27.
//  Copyright © 2017年 ky. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DivisionCodeModel.h"

@protocol OrganTableViewDelegate;

@interface OrganTableView : UITableView

@property (nonatomic, strong) NSMutableArray *tableData;
@property (nonatomic, weak) id<OrganTableViewDelegate> myDelegate;
@property (nonatomic, assign) BOOL isBackground;
- (void)selectedToFirst;

@end

@protocol OrganTableViewDelegate <NSObject>

@optional
- (void)didSelectedTabelView:(OrganTableView *)tabelView WithModel:(DivisionCodeModel *)model Index:(NSInteger)index;

@end
