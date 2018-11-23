//
//  HomeHeadBtn.m
//  BSKYDoctorPro
//
//  Created by 何雷 on 2017/8/17.
//  Copyright © 2017年 ky. All rights reserved.
//

#import "HomeHeadBtn.h"

@implementation HomeHeadBtn

- (void)layoutSubviews{
    
    [super layoutSubviews];
        
    CGRect imageRect = self.imageView.frame;
    
    imageRect.size = self.imageView.image.size;
    
    self.imageView.frame = CGRectMake(self.width-imageRect.size.width+2, imageRect.origin.y, imageRect.size.width, imageRect.size.height);
    
    self.titleLabel.frame = CGRectMake(0, 0, self.titleLabel.width, self.titleLabel.height);
}

@end
