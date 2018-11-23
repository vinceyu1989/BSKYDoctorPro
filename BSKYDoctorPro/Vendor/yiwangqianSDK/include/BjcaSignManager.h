//
//  BjcaSignManager.h
//  BjcaSignSDK
//
//  Created by 吴兴 on 2018/3/14.
//  Copyright © 2018年 吴兴. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "KPublicConst.h"
@interface BjcaSignManager : NSObject


//证书相关操作回调block
@property(nonatomic,copy)SignetResponseBlock blockResponse;
//证书信息回调block
@property(nonatomic,copy)CertInfoBlock blockCertInfo;
/**
 初始化函数
 
 在当前控制器进行改变时需要重新进行初始化，不建议使用懒加载，可能会引发页面层级错误
 
 @param containnerVC 当前所在控制器
 @return 实例化对象
 */
+ (instancetype)initWithContainnerVC:(UIViewController *)containnerVC;

/**
 环境配置
 默认为线上环境
 配置一次即可，若多次配置，则以最后一次配置的环境为准
 @param service 环境类型
 */
- (void)setServerURL:(ServerType)service;

/**
 打开医师SDK首页
 
 @param clientId 厂商的ClientId
 */
- (void)startDoctor:(NSString *)clientId;
/**
 打开医师SDK首页
 
 @param clientId 厂商的ClientId
 @param phoneNum 用户手机号(可用于证书下载/证书找回)
 */
- (void)startDoctor:(NSString *)clientId phoneNum:(NSString*)phoneNum;
/**
 打开特定的证书管理页面
 
 @param clientId 厂商的ClientId
 @param type     页面类型
 */
- (void)startUrl:(NSString *)clientId pageType:(PageType)type;
/**
 打开特定的证书管理页面
 
 @param clientId 厂商的ClientId
 @param type     页面类型
 @param phoneNum 用户手机号(可用于证书下载/证书找回)
 */
- (void)startUrl:(NSString *)clientId pageType:(PageType)type phoneNum:(NSString*)phoneNum;
/**
 医网签单次签名
 
 @param uniqueId 服务端同步处方后得到的唯一标示uniqueId
 @param clientId 厂商的ClientId
 @param block 回调block
 */
- (void)signRecipe:(NSString *)uniqueId userClientId:(NSString *)clientId response:(SignetResponseBlock)block;

/**
 医网签批量签名接口
 
 @param uniqueIds 服务端同步处方后得到的uniqueId的数组
 @param clientId 厂商的ClientId
 @param block 回调block
 */
- (void)batchsignList:(NSMutableArray *)uniqueIds userClientId:(NSString *)clientId   response:(SignetResponseBlock)block;

/**
 医网签二维码处方签名(已废弃, 建议使用qrSign方法代替)
 
 @param qrString 二维码扫描得到的数据
 @param clientId 厂商的ClientId
 @param block 回调block
 */
- (void)qrSignRecipe:(NSString *)qrString userClientId:(NSString *)clientId response:(SignetResponseBlock)block __attribute__((deprecated("已废弃, 建议使用qrSign方法代替")));


/**
 医网签二维码处理（目前支持二维码处方签名与oauth登录）
 
 @param qrString 解析数据
 @param clientId 厂商唯一标识
 @param block 回调block
 */
- (void)qrSign:(NSString *)qrString userClientId:(NSString *)clientId response:(SignetResponseBlock)block;

/**
 获取用户信息
 
 @param block 回调block
 */
- (void)getCertInfo:(NSString *)clientId withblock:(CertInfoBlock)block;

/**
 获取openId接口
 
 @return openId
 */
+ (NSString *)getOpenId;


/**
 判断是否存在证书
 
 @return  BOOL
 */
+ (BOOL)existsCert;


/**
 判断是否设置签章
 
 @return  BOOL
 */
+ (BOOL)existsStamp;


/**
 删除证书
 
 @return BOOL型
 */
+(NSString *)bjca_removeCert;


/**
 是否处于免密状态
 
 @return 状态
 */
+(BOOL)bjca_FreePin;

/**
 删除用户保存的pin码
 */
+(void)bjca_removePin;


/**
 获取当前版本号
 
 @return 当前版本号
 */
+(NSString *)bjca_getVersion;

/**
 获取sdk当前环境url
 
 @return 当前sdk环境url
 */
+(NSString *)bjca_getAddress;


@end
