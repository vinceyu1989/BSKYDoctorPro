//
//  NSDateFormatter+BSKY.m
//  BSKYDoctorPro
//
//  Created by LinfengYU on 2017/9/11.
//  Copyright © 2017年 ky. All rights reserved.
//

#import "NSDateFormatter+BSKY.h"

@implementation NSDateFormatter (BSKY)

+ (NSDateFormatter *)sharedInstance {
    static NSDateFormatter *dateFormatter;
    if(!dateFormatter){
        dateFormatter = [NSDateFormatter new];
        dateFormatter.dateFormat = @"yyyy-MM-dd";
    }
    
    return dateFormatter;
}

+ (NSDateFormatter *)eventDateFormatter {
    NSDateFormatter* dateFormatter = [NSDateFormatter sharedInstance];
    dateFormatter.dateFormat = @"yyyy-MM-dd";
    return dateFormatter;
}

+ (NSDateFormatter *)monthFormatter {
    NSDateFormatter* dateFormatter = [NSDateFormatter sharedInstance];
    dateFormatter.dateFormat = @"yyyy-MM";
    return dateFormatter;
}

@end
