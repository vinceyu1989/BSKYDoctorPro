//
//  BSEducationInfoListRequest.h
//  BSKYDoctorPro
//
//  Created by jangry on 2018/7/13.
//  Copyright © 2018年 ky. All rights reserved.
//

#import "BSBaseRequest.h"

@interface BSEducationInfoListRequest : BSBaseRequest

@property (nonatomic, copy) NSNumber *pageSize;
@property (nonatomic, copy) NSNumber *pageIndex;
//*<非必须请求参数 >*/
@property (nonatomic, copy) NSString *regionCode;//区划代码
@property (nonatomic, copy) NSString *searchParam;//查询参数:姓名/拼音/身份证/档案号
@property (nonatomic, copy) NSString *businessType;//教育类型 0:体检表 1:高血压 2:糖尿病 3:精神病 4:老年人 5:门诊 6:住院 15:脑卒中 16:结核病 17:COPD 25:高糖合并 99:其他
@property (nonatomic, copy) NSString *startDate;//开始日期(yyyy-mm-dd)
@property (nonatomic, copy) NSString *endDate;

@property (nonatomic, strong) NSMutableArray *infoListData;

@end
