//
//  BskyMacroDefinition.h
//  BSKYResidents
//
//  Created by 何雷 on 2017/7/18.
//  Copyright © 2017年 何雷. All rights reserved.
//

#ifndef BskyMacroDefinition_h
#define BskyMacroDefinition_h


//-------------------获取设备大小-------------------------
// NavigationBar高度
#define NAVIGATION_BAR_HEIGHT 44

// Tabbar高度
#define TAB_BAR_HEIGHT 49

// StatusBar高度
#define STATUS_BAR_HEIGHT [[UIApplication sharedApplication] statusBarFrame].size.height

// NavigationBar + StatusBar 高度
#define TOP_BAR_HEIGHT (NAVIGATION_BAR_HEIGHT + STATUS_BAR_HEIGHT)

// iPhone X底部高度
#define SafeAreaBottomHeight (SCREEN_HEIGHT == 812.0 ? 34 : 0)

// 全部底部高度
#define BOTTOM_BAR_HEIGHT (TAB_BAR_HEIGHT + SafeAreaBottomHeight)

// 获取屏幕宽度和高度
#define SCREEN_WIDTH ([UIScreen mainScreen].bounds.size.width)
#define SCREEN_HEIGHT ([UIScreen mainScreen].bounds.size.height)

#define Screen40 ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(640, 1136), [[UIScreen mainScreen] currentMode].size) : NO)
#define Screen47 ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(750, 1334), [[UIScreen mainScreen] currentMode].size) : NO)
#define Screen55 ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? (CGSizeEqualToSize(CGSizeMake(1080, 1920), [[UIScreen mainScreen] currentMode].size) || CGSizeEqualToSize(CGSizeMake(1242, 2208), [[UIScreen mainScreen] currentMode].size)) : NO)

//------------------单例写法-------------------

#define SYNTHESIZE_SINGLETON_FOR_CLASS_HEADER(__CLASSNAME__)	\
\
+ (__CLASSNAME__*) sharedInstance;	\


#define SYNTHESIZE_SINGLETON_FOR_CLASS(__CLASSNAME__)	\
\
static __CLASSNAME__ *instance = nil;   \
\
+ (__CLASSNAME__ *)sharedInstance{ \
static dispatch_once_t onceToken;   \
dispatch_once(&onceToken, ^{    \
if (nil == instance){   \
instance = [[__CLASSNAME__ alloc] init];    \
}   \
}); \
\
return instance;   \
}   \

//----------------------系统----------------------------
// 获取系统版本
#define IOS_VERSION [[[UIDevice currentDevice] systemVersion] floatValue]     //浮点型
#define CURRENT_SYSTEM_VERSION [[UIDevice currentDevice] systemVersion]       //字符串型
#define LESS_IOS8_2                 ([[[UIDevice currentDevice] systemVersion] doubleValue] <= 8.2)
#define IOS9                        ([[[UIDevice currentDevice] systemVersion] doubleValue] >= 9.0 && [[[UIDevice currentDevice] systemVersion] doubleValue] < 10.0)
#define IOS11                       ([[[UIDevice currentDevice] systemVersion] doubleValue] >= 11.0 && [[[UIDevice currentDevice] systemVersion] doubleValue] < 12.0)
// 获取当前语言
#define CURRENT_LANGUAGE ([[NSLocale preferredLanguages] objectAtIndex:0])


//----------------------颜色类---------------------------
// 带有RGBA的颜色设置
#define RGBA(R, G, B, A) [UIColor colorWithRed:R/255.0 green:G/255.0 blue:B/255.0 alpha:A]

// 带有RGB的颜色设置
#define RGB(R, G, B) [UIColor colorWithRed:R/255.0 green:G/255.0 blue:B/255.0 alpha:1.f]

#define UIColorFromRGBA(rgbValue, alphaValue) [UIColor \
colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 \
green:((float)((rgbValue & 0x00FF00) >> 8))/255.0 \
blue:((float)(rgbValue & 0x0000FF))/255.0 \
alpha:alphaValue]

#define UIColorFromRGB(rgbValue) UIColorFromRGBA(rgbValue, 1.0)

// 弱引用
#define WS(weakSelf)  __weak __typeof(&*self)weakSelf = self;

#ifndef    weakify

#define weakify(x) \
_Pragma("clang diagnostic push") \
_Pragma("clang diagnostic ignored \"-Wshadow\"") \
autoreleasepool{} __weak __typeof__(x) __weak_##x##__ = x; \
_Pragma("clang diagnostic pop")

#endif

#ifndef    strongify

#define strongify(x) \
_Pragma("clang diagnostic push") \
_Pragma("clang diagnostic ignored \"-Wshadow\"") \
try{} @finally{} __typeof__(x) x = __weak_##x##__; \
_Pragma("clang diagnostic pop")

#endif

#define Bsky_WeakSelf        @weakify(self);
#define Bsky_StrongSelf      @strongify(self);

#endif

