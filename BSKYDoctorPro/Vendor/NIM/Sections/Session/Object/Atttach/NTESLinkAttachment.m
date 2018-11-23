//
//  NTESLinkAttachment.m
//  BSKYDoctorPro
//
//  Created by vince on 2018/11/12.
//  Copyright © 2018年 ky. All rights reserved.
//

#import "NTESLinkAttachment.h"
#import "NTESSessionLinkContentView.h"

@implementation NTESLinkAttachment

- (NSString *)encodeAttachment
{
    NSDictionary *dict = @{
                           CMType : @(CustomMessageTypelink),
                           CMData : @{
                                   CMLinkPacketTitle    : self.title,
                                   CMLinkPacketDescribe : self.describe,
                                   CMLinkPacketDataModel: self.dataStr,
                                   }
                           };
    NSData *data = [NSJSONSerialization dataWithJSONObject:dict
                                                   options:0
                                                     error:nil];
    NSString *content = nil;
    if (data) {
        content = [[NSString alloc] initWithData:data
                                        encoding:NSUTF8StringEncoding];
    }
    return content;
}


- (NSString *)cellContent:(NIMMessage *)message{
    return @"NTESSessionLinkContentView";
}

- (CGSize)contentSize:(NIMMessage *)message cellWidth:(CGFloat)width{
    CGFloat w = 240.0f;
    CGFloat h = 67.0f;
    
    return CGSizeMake(w, h);
}

- (UIEdgeInsets)contentViewInsets:(NIMMessage *)message
{
    CGFloat bubblePaddingForImage    = 3.f;
    CGFloat bubbleArrowWidthForImage = 5.f;
    if (message.isOutgoingMsg) {
        return  UIEdgeInsetsMake(bubblePaddingForImage,bubblePaddingForImage,bubblePaddingForImage,bubblePaddingForImage + bubbleArrowWidthForImage);
    }else{
        return  UIEdgeInsetsMake(bubblePaddingForImage,bubblePaddingForImage + bubbleArrowWidthForImage, bubblePaddingForImage,bubblePaddingForImage);
    }
}

- (BOOL)canBeRevoked
{
    return YES;
}

- (BOOL)canBeForwarded
{
    return YES;
}

@end
