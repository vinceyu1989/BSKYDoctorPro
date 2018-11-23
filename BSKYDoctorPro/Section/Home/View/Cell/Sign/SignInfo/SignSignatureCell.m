//
//  SignSignatureCell.m
//  BSKYDoctorPro
//
//  Created by 何雷 on 2017/12/29.
//  Copyright © 2017年 ky. All rights reserved.
//

#import "SignSignatureCell.h"
#import "SignatureShowView.h"

@interface SignSignatureCell()

@property (weak, nonatomic) IBOutlet UIImageView *imagesView;
@property (nonatomic, strong) SignatureShowView  *signatureView;
@property (weak, nonatomic) IBOutlet UILabel *remarkLabel;

@end

@implementation SignSignatureCell

- (void)awakeFromNib {
    [super awakeFromNib];
    [self.remarkLabel setBorderColor:[UIColor colorWithHexString:@"#666666"] width:0.8];
    UITapGestureRecognizer *gesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(showSignureView:)];
    gesture.numberOfTapsRequired = 1;
    gesture.numberOfTouchesRequired = 1;
    [self.imagesView addGestureRecognizer:gesture];
}

- (void)showSignureView:(UITapGestureRecognizer *)sender {
    if (!self.signatureView) {
        self.signatureView = [[SignatureShowView alloc] init];
        self.signatureView.backgroundColor = [UIColor whiteColor];
        Bsky_WeakSelf
        self.signatureView.block = ^(UIImage *image) {
            Bsky_StrongSelf
            UIImage *img = [image imageByResizeToSize:self.imagesView.size];
            self.imagesView.image = img;
            if (self.imageBlock) { //图片尺寸待定
                self.imageBlock(image);
            }
        };
        self.signatureView.dismissBlock = ^(SignatureShowView *view) {
            Bsky_StrongSelf
            self.signatureView = nil;
        };
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

@end
