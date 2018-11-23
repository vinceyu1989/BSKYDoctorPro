//
//  IMSearchResultVC.h
//  BSKYDoctorPro
//
//  Created by 何雷 on 2018/5/14.
//  Copyright © 2018年 ky. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface IMSearchResultVC : UIViewController

-(void)refreshData:(NSMutableArray *)array searchStr:(NSString *)searchStr;

@end
