//
//  BSMacro.h
//  BSKYDoctorPro
//
//  Created by Apple on 2017/7/21.
//  Copyright © 2017年 ky. All rights reserved.
//

#ifndef BSMacro_h
#define BSMacro_h

#define ClientVersion   @"ClientVersion"
#define ClientKey       @"ClientKey"

#pragma mark - Notification
#define LoginNotification                @"LoginNotification"
#define LoginSuccessNotification         @"LoginSuccessNotification"    // 登录成功
#define LogoutNotification               @"LogoutNotification"
#define RecvMessagesNotification         @"RecvMessagesNotification"    // 收到IM消息
#define AuditChangeNotification          @"AuditChangeNotification"     // 审核
#define LoginChangeNotification          @"LoginChangeNotification"     // 审核
#define kPhisInfoUpdate                  @"kPhisInfoUpdate"             // 公卫信息更新

#define kGtAppId           @"8lYCiB3kps7TB6BM7c4335"
#define kGtAppKey          @"ausqNu5MNm9lSyXDSJRFu3"
#define kGtAppSecret       @"z5ORtu86MP9DGCHF07TEm9"
#define kGtTestClientId        @"2017120417034171"
#define kGtReleaseClientId     @"2017051914062151"

// type
#define kZhiQuUrlType  @"zhiqu"                 // 治趣
#define kTuanDuiUrlType  @"tuandui"             // 团队
#define kZYFollowUpUrlType  @"zyFollowUp"       // 中医随访
#define kWorkRemindUrlType  @"workRemind"       // 工作提醒
#define kSignListUrlType  @"signList"           // 签约列表
#define kFamilySignUrlType  @"familyQianyue"    // 家庭签约
#define kH5CmdSignUrl    @"cmdSign"             // 居民主页健康卡激活
#define kH5ResManagerToSign  @"resManagerToSign"    // 居民主页立即签约
#define kH5ResManagerToSignList  @"resManagerToSignList"    // 居民主页签约列表
#define kH5ResManagerToSignCon  @"resManagerToSignCon"    // 居民主页签约合同
#define kH5ZyFollowUp  @"zyFollowUp"                // 居民主页中医随访
#define kH5ZyFollowUpSearch  @"zyFollowUpSearch"    // 居民主页中医随访查看

#define kMessageSystemType   @"01009001" //系统消息
#define kMessageServerType   @"01009002" //服务消息
#define kMessageOrderType    @"01009003" //订单消息
#define kMessageIncomeType   @"01009004" //收入消息

// 通知
#define kFollowupBmiNeedRefresh @"kFollowupBmiNeedRefresh"        // 旧版的bmi需要更新通知
#define kAllFormsBmiNeedRefresh @"kAllFormsBmiNeedRefresh"        // 新版的bmi需要更新通知
#define kHyFollowupSaveSuccess @"kHyFollowupSaveSuccess"        // 高血压随访保存成功
#define kDbFollowupSaveSuccess @"kDbFollowupSaveSuccess"        // 糖尿病随访保存成功
#define kZyFollowupSaveSuccess @"kZyFollowupSaveSuccess"        // 中药随访保存成功
#define kSignSaveSuccess @"kSignSaveSuccess"                    // 签约保存成功
#define kHealthCardActivatedSuccess @"kHealthCardActivatedSuccess"     // 健康卡激活成功
#define kHealthEducationSaveSuccess @"kHealthEducationSaveSuccess"     // 新增健康教育

// 特使字符
#define kModelEmptyString @"- -"        // model空字符串替换
#define kFollowupSeparator @" | "        // 随访表单的分割符

#pragma mark 友盟事件统计
#define kUMCreateArchiveEvent   @"um_createArchive"     //快速建档事件
#define kUMFamilySignEvent      @"um_familySign"        //家庭签约事件
#define kUMFollowupEvent        @"um_followup"          //随访事件
#define kUMNCDAchiveEvent       @"um_NCDAchive"         //慢病建档事件
#define kUMResidentManageEvent  @"um_residentManage"    //居民管理事件
#define kUMServiceLogEvent      @"um_serviceLog"        //工作日志事件
#define kUMTeamManageEvent      @"um_teamManage"        //团队管理事件
#define kUMWorkRemindEvent      @"um_workRemind"        //工作提醒事件
#define kUMZYFollowupEvent      @"um_zyFollowup"        //中医随访事件
#define kUMDiagnosisRecordEvent @"um_diagnosisRecord"   //诊疗记录事件
#define kUMMedicalRecordEvent   @"um_medicalRecord"     //就疹记录事件

#pragma mark 数据宏
//微信appkey appsecret
#define kWXAppKey @"wxc16806b2b7a04498"
#define kWXAppSecret @"15badff1dac7f1ff8ab0d50d2eeb8f2b"
//首次启动App
#define kFirstLaunch @"firstLaunch"

#endif /* BSMacro_h */
