//
//  FamilyInfoView.h
//  BSKYDoctorPro
//
//  Created by 快医科技 on 2018/1/18.
//  Copyright © 2018年 ky. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FamilyListModel.h"

@interface FamilyInfoView : UIView
@property (weak, nonatomic) IBOutlet UILabel *code;
@property (weak, nonatomic) IBOutlet UILabel *address;
@property (weak, nonatomic) IBOutlet UILabel *tel;
@property (weak, nonatomic) IBOutlet UILabel *name;
@property (weak, nonatomic) IBOutlet UILabel *nameTItle;
@property (weak, nonatomic) IBOutlet UILabel *codeTitle;
@property (weak, nonatomic) IBOutlet UILabel *addressTitle;
@property (nonatomic ,strong) id model;
@end
