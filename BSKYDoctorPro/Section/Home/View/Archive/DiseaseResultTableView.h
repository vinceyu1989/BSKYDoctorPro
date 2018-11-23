//
//  DiseaseResultTableView.h
//  BSKYDoctorPro
//
//  Created by 快医科技 on 2018/3/5.
//  Copyright © 2018年 ky. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^selectBlock)(NSIndexPath *indexPath);

@interface DiseaseResultTableView : UITableView
@property (nonatomic ,strong)NSArray *dataArray;
@property (nonatomic ,copy) selectBlock selectBlock;
@end
