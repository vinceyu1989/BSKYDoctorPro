//
//  NSDateFormatter+BSKY.h
//  BSKYDoctorPro
//
//  Created by LinfengYU on 2017/9/11.
//  Copyright © 2017年 ky. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDateFormatter (BSKY)

+ (NSDateFormatter *)sharedInstance;

+ (NSDateFormatter *)eventDateFormatter;

+ (NSDateFormatter *)monthFormatter;

@end
