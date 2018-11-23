//
//  BSDiseaseListRequest.h
//  BSKYDoctorPro
//
//  Created by kykj on 2018/8/21.
//  Copyright © 2018年 ky. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BSDiseaseListRequest : BSBaseRequest

@property (nonatomic, copy) NSString *regionID;//所在区划ID<必填>
@property (nonatomic, copy) NSString *buildType;//慢病类型(高血压,糖尿病,精神病，结核病,COPD)<必填>
@property (nonatomic, copy) NSString *keyValue;//自定义查询字段(姓名或拼音,身份证,自定义编码)
@property (nonatomic, copy) NSString *phoneTel;//联系电话
@property (nonatomic, copy) NSNumber *isClose; //是否结案（0-否,1-是）
@property (nonatomic, copy) NSNumber *isPoor;  //是否贫困（2-是,其他值-否,为空则查全部）
@property (nonatomic, copy) NSNumber *hasFollowup;//有无随访（1-全部,2-无,3有）
@property (nonatomic, copy) NSNumber *pageSize;   //每页记录条数
@property (nonatomic, copy) NSNumber *pageIndex;  //

@property (nonatomic, strong) NSMutableArray *listData;

@end
