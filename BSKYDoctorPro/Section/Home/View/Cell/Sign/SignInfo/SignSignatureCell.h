//
//  SignSignatureCell.h
//  BSKYDoctorPro
//
//  Created by 何雷 on 2017/12/29.
//  Copyright © 2017年 ky. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^SignSignatureCellBlock)(UIImage *image);

@interface SignSignatureCell : UITableViewCell

@property (nonatomic, copy) SignSignatureCellBlock imageBlock;

@end
