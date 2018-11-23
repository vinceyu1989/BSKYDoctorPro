//
//  KPublicConst.h
//  BjcaSignSDK
//
//  Created by 吴兴 on 2018/3/14.
//  Copyright © 2018年 吴兴. All rights reserved.
//

#ifndef KPublicConst_h
#define KPublicConst_h

/** 业务类型 */
typedef NS_ENUM(NSInteger ,BusinessSignetType) {
    //    证书下载
    BusinessSignetTypeRegist,
    //    证书找回
    BusinessSignetTypeFindBack,
    //    证书升级
    BusinessSignetTypeUpdate,
    //    处方签名
    BusinessSignetTypeSignData,
    //    设置签章
    BusinessSignetTypeSetStamp,
    //    Oauth登录
    BusinessSignetTypeOauth,
    //    暂未开放业务
    BusinessSignetTypeNull,
};

//SDK地址
typedef NS_ENUM(NSInteger,ServerType) {
    //    正式环境
    Public,
    //    集成环境
    Integrate,
    //    开发环境
    Dev,
    //    测试环境
    Test,
};

//SDK用户打开的页面的类型
typedef NS_ENUM(NSInteger,PageType) {
    //    首页
    PageTypeHome,
    //    证书下载
    PageTypeDownLoad,
    //    证书找回
    PageTypeFindBack,
    //    设置签章
    PageTypeSetStamp,
    //    凭证更新
    PageTypeUpdateCert,
};


/**
 业务回调函数
 
 @param businessType 业务类型
 @param result 返回结果，多为字典类型
 */
typedef void(^SignetResponseBlock)(BusinessSignetType businessType,
                                   id result);

/**
 证书信息回调函数
 
 @param result 返回结果，多为字典类型
 */
typedef void(^CertInfoBlock)(id result);



#endif /* KPublicConst_h */
