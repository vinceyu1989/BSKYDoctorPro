//
//  BSimagePickerCell.m
//  BSKYDoctorPro
//
//  Created by 快医科技 on 2018/1/11.
//  Copyright © 2018年 ky. All rights reserved.
//

#import "BSimagePickerCell.h"
#import "AppDelegate.h"

@interface BSimagePickerCell ()<UIImagePickerControllerDelegate,UIActionSheetDelegate,UINavigationControllerDelegate>
@property (weak, nonatomic) IBOutlet UIImageView *photoImageView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

@end

@implementation BSimagePickerCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(selectImage)];
    self.photoImageView.userInteractionEnabled = YES;
    [self.photoImageView addGestureRecognizer:tap];
    self.photoImageView.contentMode = UIViewContentModeScaleAspectFit;
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (void)selectImage{
    [self openActionSheetFunc];
}
- (void)openActionSheetFunc
{
    //判断设备是否有具有摄像头(相机)功能
    UIActionSheet *actionSheet = nil;
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera])
    {
        actionSheet = [[UIActionSheet alloc]initWithTitle:@"选择图像" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"拍照",@"从相册选择", nil];
    }
    else
    {
        actionSheet = [[UIActionSheet alloc]initWithTitle:@"选择图像" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"从相册选择", nil];
    }
    actionSheet.delegate = self;
    actionSheet.tag  = 100;
    //显示提示栏
    [actionSheet showInView:[UIApplication sharedApplication].keyWindow];
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (actionSheet.tag == 100)
    {
        NSUInteger sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera])
        {
            switch (buttonIndex)
            {
                case 0:
                    //来源:相机
                    sourceType = UIImagePickerControllerSourceTypeCamera;
                    break;
                case 1:
                    //来源:相册
                    sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
                    break;
                case 2:
                    return;
            }
        }
        else
        {
            if (buttonIndex == 2)
            {
                return;
            }
            else
            {
                sourceType = UIImagePickerControllerSourceTypeSavedPhotosAlbum;
            }
        }
        //跳转到相机或者相册页面
        UIImagePickerController *imagePickerController = [[UIImagePickerController alloc]init];
        imagePickerController.allowsEditing  = YES;
        imagePickerController.sourceType = sourceType;
        imagePickerController.delegate = self;
        AppDelegate *delegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
        UIViewController *root = delegate.window.rootViewController;
        [root presentViewController:imagePickerController animated:YES completion:nil];
    }
}
- (void)setModel:(BSArchiveModel *)model{
    _model = model;
    self.titleLabel.text = model.title;
    if (_model.value.length) {
        NSData *decodedData = [[NSData alloc] initWithBase64EncodedString:_model.value options:0];
        self.photoImageView.image = [UIImage imageWithData:decodedData];
    }
}
//pickerController的代理
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info{
    UIImage *image = [info objectForKey:UIImagePickerControllerOriginalImage];
    self.photoImageView.image = image;
    
    NSData *imageData = [self compressOriginalImageWithSize:image toMaxDataSizeKBytes:200];
    self.model.value = [imageData base64EncodedString];
    
    [picker dismissViewControllerAnimated:YES completion:nil];
   
   
}
/**
 *  压缩图片到指定文件大小(质量压缩)
 *
 *  @param image 目标图片
 *  @param size  目标大小（最大值）
 *
 *  @return 返回的图片文件
 */
- (NSData *)compressOriginalImageWith:(UIImage *)image toMaxDataSizeKBytes:(CGFloat)size{
    NSData * data = UIImageJPEGRepresentation(image, 1.0);
    CGFloat dataKBytes = data.length/1000.0;
    CGFloat maxQuality = 0.9f;
    CGFloat lastData = dataKBytes;
    while (dataKBytes > size && maxQuality > 0.01f) {
        maxQuality = maxQuality - 0.1f;
        data = UIImageJPEGRepresentation(image, maxQuality);
        dataKBytes = data.length / 1000.0;
        if (lastData == dataKBytes) {
            break;
        }else{
            lastData = dataKBytes;
        }
    }
    return data;
}
- (NSData *)compressOriginalImageWithSize:(UIImage *)image toMaxDataSizeKBytes:(CGFloat )size{
    NSData * data = UIImageJPEGRepresentation(image, 1.0);
    if (data.length < size * 1000) return data;
    UIImage *resultImage = [UIImage imageWithData:data];
    // Compress by size
    NSUInteger lastDataLength = 0;
    while (data.length > size * 1000 && data.length != lastDataLength) {
        lastDataLength = data.length;
        CGFloat ratio = (CGFloat)size * 1000 / data.length;
        //NSLog(@"Ratio = %.1f", ratio);
        CGSize size = CGSizeMake((NSUInteger)(resultImage.size.width * sqrtf(ratio)),
                                 (NSUInteger)(resultImage.size.height * sqrtf(ratio))); // Use NSUInteger to prevent white blank
        UIGraphicsBeginImageContext(size);
        [resultImage drawInRect:CGRectMake(0, 0, size.width, size.height)];
        resultImage = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        data = UIImageJPEGRepresentation(resultImage, 1);
        //NSLog(@"In compressing size loop, image size = %ld KB", data.length / 1024);
    }
    //NSLog(@"After compressing size loop, image size = %ld KB", data.length / 1024);
    return data;
}
@end
