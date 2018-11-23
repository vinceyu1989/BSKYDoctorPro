//
//  SignPreviewSignalCell.m
//  BSKYDoctorPro
//
//  Created by kykj on 2018/1/23.
//  Copyright © 2018年 ky. All rights reserved.
//

#import "SignPreviewSignalCell.h"

@interface SignPreviewSignalCell ()

@property (weak, nonatomic) IBOutlet UIImageView *picturesImage;

@end

@implementation SignPreviewSignalCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setImageViewWithImageStr:(NSString *)str {
    if (str.length == 0) {
        return;
    }
    NSData *decodedImageData = [[NSData alloc] initWithBase64EncodedString:str options:NSDataBase64DecodingIgnoreUnknownCharacters];
    UIImage *decodedImage = [UIImage imageWithData:decodedImageData];
    UIImage *img = [decodedImage imageByResizeToSize:self.picturesImage.size];
    self.picturesImage.image = img;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
