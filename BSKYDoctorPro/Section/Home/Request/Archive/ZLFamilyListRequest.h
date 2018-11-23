//
//  ZLFamilyListRequest.h
//  BSKYDoctorPro
//
//  Created by 快医科技 on 2018/2/28.
//  Copyright © 2018年 ky. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ZLFamilyListRequest : BSBaseRequest
@property (nonatomic ,strong)NSString *familyCodeOrName;//目前支持家庭档案号/户主身份证/户主姓名/家庭档案号
@property (nonatomic ,strong)NSString *pageSize;
@property (nonatomic ,strong)NSString *pageIndex;
@property (nonatomic ,strong)NSArray *familyListData;
@end
