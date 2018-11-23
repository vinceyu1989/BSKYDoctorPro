//
//  NSDate+BRAdd.h
//  BRPickerViewDemo
//
//  Created by 任波 on 2017/8/11.
//  Copyright © 2017年 renb. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDate (BSAdd)
/** 获取当前的时间 */
+ (NSString *)currentDateString;
+ (NSString *)currentDateStringWithFormat:(NSString *)formatterStr;
@end
