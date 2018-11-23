//
//  SDGridItemCacheTool.m
//  GSD_ZHIFUBAO
//
//  Created by gsd on 15/8/11.
//  Copyright (c) 2015年 GSD. All rights reserved.
//

#import "GridItemCacheTool.h"

@implementation GridItemCacheTool

static NSString * const kItemsArrayCacheKey = @"ItemsArrayCacheKey";

+ (NSArray *)itemsArray
{
    return [[NSUserDefaults standardUserDefaults] objectForKey:kItemsArrayCacheKey];
}

+ (void)saveItemsArray:(NSArray *)array
{
    [[NSUserDefaults standardUserDefaults] setObject:[array copy] forKey:kItemsArrayCacheKey];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

@end
