//
//  BskyEnum.h
//  BSKYDoctorPro
//
//  Created by 何雷 on 2017/9/6.
//  Copyright © 2017年 ky. All rights reserved.
//

#ifndef BskyEnum_h
#define BskyEnum_h

//  app
typedef NS_ENUM(NSUInteger, AppType) {
    
    AppType_Dev = 0,    // 开发
    
    AppType_Test,       // 测试
    
    AppType_Release     // 发布
};
// 医疗系统
typedef NS_ENUM(NSUInteger,InterfaceServerType) {
    
    InterfaceServerTypeScwjw = 1,    // 四川卫计委
    
    InterfaceServerTypeSczl = 2,     //  四川中联
    
    InterfaceServerTypeSchc = 3,     //  四川航创
};


//  随访类型
typedef NS_ENUM(NSUInteger, FollowupType) {
    
    FollowupTypeHypertension = 6002001,    // 高血压
    
    FollowupTypeDiabetes = 6002002,        //  糖尿病
    
    FollowupTypeGaoTang = 6002003        //  高糖
};

//  基卫系统用户注册验证状态
typedef NS_ENUM(NSUInteger, PhisVerifyStatus) {
    
    PhisVerifyStatusProcessing = 1,    // 验证中
    
    PhisVerifyStatusFailure = 2,        //  验证失败
    
    PhisVerifyStatusSuccess = 3,   // 验证成功
    
    PhisVerifyStatusPwError = 4,   // 密码错误
    
    PhisVerifyStatusUnregistered = 5,    // 未注册  MR001
    
    PhisVerifyStatusNonactivated = 6,    // 地区未开通  MR002
    
    PhisVerifyStatusRegionCodeMismatch = 7,    // 区域编码不匹配
};

//  表单样式类型
typedef NS_ENUM(NSUInteger, BSFormCellType) {
    
    BSFormCellTypeTextField = 0,            // 文字输入
    BSFormCellTypeSingleRadio = 1,          // 不换行的单选
    BSFormCellTypeTap = 2,                  // 点击跳转的cell
    BSFormCellTypeDatePicker = 3,           // 时间选择
    BSFormCellTypeChoicesAndOther = 4,      // 多选和其他文字输入
    BSFormCellTypeCustomPicker = 5,         // 自定义选择器
    BSFormCellTypeWrapRadio = 6,            // 换行的单选
    BSFormCellTypeTFEnabled = 7,            // textFiled不能输入
    BSFormCellTypeSingleRadioAndOther = 8,  // 不换行的单选加其他输入
    BSFormCellTypeSection = 9,              // 组cell
    BSFormCellTypeBoldTitle = 10,           // 粗字Cell
    BSFormCellTypeDrug = 11,                // 药品
    BSFormCellTypeSeparator = 12,           // 分割线
};

//  居民cell刷新状态
typedef NS_ENUM(NSUInteger, ResidentRefreshStatus) {
    
    ResidentRefreshStatusRuning = 1,    // 刷新中
    
    ResidentRefreshStatusFailure = 2,   // 刷新失败
    
    ResidentRefreshStatusSuccess = 3,   // 刷新成功
};

typedef NS_ENUM(NSInteger, BSSignType) {
    BSPaperSignType = 0,        //纸质签约
    BSEletronicSignType,        //电子签约
};

#endif /* BskyEnum_h */

