//
//  UIPlaceHolderTextView.h
//  eDuShi
//
//  Created by aladdin on 14/12/23.
//  Copyright (c) 2014年 aladdin. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CATPlaceHolderTextView : UITextView
{
	UIColor *placeholderColor;

   @private
	UILabel *placeHolderLabel;
}

@property (nonatomic, retain) UILabel *placeHolderLabel;
@property (nonatomic, retain) NSString *placeholder;
@property (nonatomic, retain) UIColor *placeholderColor;

- (void)textChanged:(NSNotification *)notification;

@end
