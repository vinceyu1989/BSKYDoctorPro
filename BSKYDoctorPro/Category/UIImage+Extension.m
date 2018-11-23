//
//  UIImage+Extension.m
//  Dingding
//
//  Created by 陈欢 on 14-3-3.
//  Copyright (c) 2014年 陈欢. All rights reserved.
//

#import "UIImage+Extension.h"
#import <Accelerate/Accelerate.h>

#define kCompresseionDataLength (500000.0f) //最大压缩大小(50k)

@implementation UIImage (Extension)

+ (UIImage*)circleImage:(UIImage*)image withParam:(CGFloat)inset
{
    //在retian屏幕上要使用这个函数，才能保证不失真
    UIGraphicsBeginImageContextWithOptions(image.size, NO, [UIScreen mainScreen].scale);
	CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetLineWidth(context, inset);
    CGContextSetStrokeColorWithColor(context, [UIColor colorWithRed:255.f green:255.f blue:255.f alpha:.6].CGColor);
	CGRect rect = CGRectMake(inset, inset, image.size.width - inset * 2.0f, image.size.height - inset * 2.0f);
	CGContextAddEllipseInRect(context, rect);
	CGContextClip(context);
	
	[image drawInRect:rect];
    CGContextAddEllipseInRect(context, rect);
	CGContextStrokePath(context);
    UIImage *newimg = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newimg;
}

+ (UIImage*)circleImage:(UIImage*)image withParam:(CGFloat)inset withSize:(CGSize)imageSize
{
    //在retian屏幕上要使用这个函数，才能保证不失真
    UIGraphicsBeginImageContextWithOptions(imageSize, NO, [UIScreen mainScreen].scale);
	CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetLineWidth(context, 2);
    CGContextSetStrokeColorWithColor(context, [UIColor colorWithRed:255.f green:255.f blue:255.f alpha:.6].CGColor);
	CGRect rect = CGRectMake(inset, inset, imageSize.width - inset * 2.0f, imageSize.height - inset * 2.0f);
	CGContextAddEllipseInRect(context, rect);
	CGContextClip(context);
	
	[image drawInRect:rect];
    CGContextAddEllipseInRect(context, rect);
	CGContextStrokePath(context);
    UIImage *newimg = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newimg;
}

+ (UIImage*)cornerImage:(UIImage*)image withParam:(CGFloat)corner withSize:(CGSize)imageSize
{
    //在retian屏幕上要使用这个函数，才能保证不失真
    UIGraphicsBeginImageContextWithOptions(imageSize, NO, [UIScreen mainScreen].scale);
	CGContextRef context = UIGraphicsGetCurrentContext();
	CGRect rect = CGRectMake(0,
                             0,
                             imageSize.width,
                             imageSize.height);
    UIBezierPath *path = [UIBezierPath bezierPathWithRoundedRect:rect
                                                    byRoundingCorners:UIRectCornerBottomLeft|UIRectCornerBottomRight
                                                     cornerRadii:CGSizeMake(corner,
                                                                            corner)];
	CGContextAddPath(context, [path CGPath]);
	CGContextClip(context);
	
	[image drawInRect:rect];

    UIImage *newimg = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newimg;
}

+ (UIImage*)circleImageWithRadius:(CGFloat)radius Color:(UIColor *)color
{
    //在retian屏幕上要使用这个函数，才能保证不失真
    CGSize imageSize = CGSizeMake(radius, radius);
    UIGraphicsBeginImageContextWithOptions(imageSize, NO, [UIScreen mainScreen].scale);
	CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, color.CGColor);
	CGRect rect = CGRectMake(0, 0, imageSize.width, imageSize.height);
    CGContextAddEllipseInRect(context, rect);
	CGContextFillPath(context);
    UIImage *newimg = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return newimg;
}

+ (UIImage*)verticalBarWithWidth:(CGFloat)width Height:(CGFloat)height Color:(UIColor *)color
{
    //在retian屏幕上要使用这个函数，才能保证不失真
    CGSize imageSize = CGSizeMake(width, height);
    UIGraphicsBeginImageContextWithOptions(imageSize, NO, [UIScreen mainScreen].scale);
	CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, color.CGColor);
	CGRect rect = CGRectMake(0, 0, imageSize.width, imageSize.height);
    CGContextAddRect(context, rect);
	CGContextFillPath(context);
    UIImage *newimg = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return newimg;
}

+ (UIImage *)imageWithColor:(UIColor *)color size:(CGSize)size{
    CGSize imageSize = size;
    UIGraphicsBeginImageContextWithOptions(imageSize, NO, [UIScreen mainScreen].scale);
	CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, color.CGColor);
    CGContextFillRect(context, CGRectMake(0, 0, size.width, size.height));
    UIImage *newimg = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newimg;
}
+ (UIImage *)createImageWithColor:(UIColor *)color
{
    CGSize size = CGSizeMake(1.0, 1.0);
    return [UIImage imageWithColor:color size:size];
}
+ (UIImage *)cutCenterImage:(UIImage *)image size:(CGSize)size{
    CGFloat scale = [UIScreen mainScreen].scale;
    CGSize originSize = CGSizeMake(image.size.width, image.size.height);
    CGSize imageSize = CGSizeMake(size.width * scale, size.height * scale);
    
    if(originSize.width < imageSize.width)
    {
        originSize.height *= imageSize.width/originSize.width;
        originSize.width = imageSize.width;
    }
    if(originSize.height < imageSize.height){
        originSize.width *= imageSize.height/originSize.height;
        originSize.height = imageSize.height;
    }
    
    CGRect frame;
    frame.origin.x = (originSize.width - imageSize.width)/2;
    frame.origin.y = (originSize.height - imageSize.height)/2;
    frame.size = imageSize;
    
    CGImageRef subImageRef = CGImageCreateWithImageInRect(image.CGImage, frame);
    CGRect smallBounds = CGRectMake(0, 0, CGImageGetWidth(subImageRef), CGImageGetHeight(subImageRef));
    
    UIGraphicsBeginImageContext(smallBounds.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextDrawImage(context, smallBounds, subImageRef);
    UIImage* smallImage = [UIImage imageWithCGImage:subImageRef];
    CGImageRelease(subImageRef);
    UIGraphicsEndImageContext();
    
    return smallImage;
}

+ (UIImage *)cutImage:(UIImage *)image size:(CGSize)size{
    CGFloat scale = [UIScreen mainScreen].scale;
    CGSize originSize = CGSizeMake(image.size.width, image.size.height);
    CGSize imageSize = CGSizeMake(size.width * scale, size.height * scale);
    
    if(originSize.width < imageSize.width)
    {
        originSize.height *= imageSize.width/originSize.width;
        originSize.width = imageSize.width;
    }
    if(originSize.height < imageSize.height){
        originSize.width *= imageSize.height/originSize.height;
        originSize.height = imageSize.height;
    }
    
    CGRect frame;
    frame.origin.x = 0;
    frame.origin.y = 0;
    frame.size = imageSize;
    
    CGImageRef subImageRef = CGImageCreateWithImageInRect(image.CGImage, frame);
    CGRect smallBounds = CGRectMake(0, 0, CGImageGetWidth(subImageRef), CGImageGetHeight(subImageRef));
    
    UIGraphicsBeginImageContext(smallBounds.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextDrawImage(context, smallBounds, subImageRef);
    UIImage* smallImage = [UIImage imageWithCGImage:subImageRef];
    CGImageRelease(subImageRef);
    UIGraphicsEndImageContext();
    
    return smallImage;
}

/**
 *  竖切图片
 *
 *  @param image    图片
 *  @param size     需要调整的大小
 *
 *  @return UIImage
 */
+ (UIImage *)cutVerticalImage:(UIImage *)image size:(CGSize)size{
    CGFloat scale = [UIScreen mainScreen].scale;
    CGSize originSize = CGSizeMake(image.size.width, image.size.height);
    CGSize imageSize = CGSizeMake(size.width * scale, size.height * scale);
    
    CGRect frame;
    
    
    if (originSize.width/originSize.height <= imageSize.width/imageSize.height)
    {
        originSize.width *= imageSize.width/originSize.width;
        originSize.height *= imageSize.width/originSize.width;

        frame.origin.y = (originSize.height - imageSize.height)/2;
        frame.origin.x = 0;
    }
    else
    {

        originSize.width *= imageSize.height/originSize.height;
        originSize.height *= imageSize.height/originSize.height;

        
        frame.origin.x = (originSize.width - imageSize.width)/2;
        frame.origin.y = 0;
    }
    
    



     
    UIGraphicsBeginImageContext(originSize);
    
    [image drawInRect:CGRectMake(0, 0, originSize.width, originSize.height)];
    UIImage *scaledImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();

    frame.size = imageSize;
    
    CGImageRef subImageRef = CGImageCreateWithImageInRect(scaledImage.CGImage, frame);
    CGRect smallBounds = CGRectMake(0, 0, CGImageGetWidth(subImageRef), CGImageGetHeight(subImageRef));
    
    UIGraphicsBeginImageContext(smallBounds.size);
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextDrawImage(context, frame, subImageRef);
    
    UIImage* smallImage = [UIImage imageWithCGImage:subImageRef];
    
    NSLog(@"改变后图片的宽度为%f,图片的高度为%f",[smallImage size].width,[smallImage size].height);
    
    CGImageRelease(subImageRef);
    UIGraphicsEndImageContext();
    

    return smallImage;
}

+ (UIImage *)handleImage:(UIImage *)originalImage withSize:(CGSize)size
{
    CGFloat scale = [UIScreen mainScreen].scale;
    CGSize imageSize = CGSizeMake(size.width * scale, size.height * scale);
    
    CGSize originalsize = [originalImage size];
    NSLog(@"改变前图片的宽度为%f,图片的高度为%f",originalsize.width,originalsize.height);
    
    //原图长宽均小于标准长宽的，不作处理返回原图
    if (originalsize.width < imageSize.width && originalsize.height < imageSize.height)
    {
        return originalImage;
    }
    
    //原图长宽均大于标准长宽的，按比例缩小至最大适应值
    else if(originalsize.width > imageSize.width && originalsize.height > imageSize.height)
    {
        CGFloat rate = 1.0;
        CGFloat widthRate = originalsize.width/imageSize.width;
        CGFloat heightRate = originalsize.height/imageSize.height;
        
        rate = widthRate>heightRate?heightRate:widthRate;
        
        CGImageRef imageRef = nil;
        
        if (heightRate>widthRate)
        {
            imageRef = CGImageCreateWithImageInRect([originalImage CGImage], CGRectMake(0, originalsize.height/2-imageSize.height*rate/2, originalsize.width, imageSize.height*rate));//获取图片整体部分
        }
        else
        {
            imageRef = CGImageCreateWithImageInRect([originalImage CGImage], CGRectMake(originalsize.width/2-imageSize.width*rate/2, 0, imageSize.width*rate, originalsize.height));//获取图片整体部分
        }
        UIGraphicsBeginImageContext(imageSize);//指定要绘画图片的大小
        CGContextRef con = UIGraphicsGetCurrentContext();
        
        CGContextTranslateCTM(con, 0.0, imageSize.height);
        CGContextScaleCTM(con, 1.0, -1.0);
        
        CGContextDrawImage(con, CGRectMake(0, 0, imageSize.width, imageSize.height), imageRef);
        
        UIImage *standardImage = UIGraphicsGetImageFromCurrentImageContext();
        NSLog(@"改变后图片的宽度为%f,图片的高度为%f",[standardImage size].width,[standardImage size].height);
        
        UIGraphicsEndImageContext();
        CGImageRelease(imageRef);
        
        return standardImage;
    }
    
    //原图长宽有一项大于标准长宽的，对大于标准的那一项进行裁剪，另一项保持不变
    else if(originalsize.height > imageSize.height || originalsize.width > imageSize.width)
    {
        CGImageRef imageRef = nil;
        
        if(originalsize.height > imageSize.height)
        {
            imageRef = CGImageCreateWithImageInRect([originalImage CGImage], CGRectMake(0, originalsize.height/2-imageSize.height/2, originalsize.width, imageSize.height));//获取图片整体部分
        }
        else if (originalsize.width>imageSize.width)
        {
            imageRef = CGImageCreateWithImageInRect([originalImage CGImage], CGRectMake(originalsize.width/2-imageSize.width/2, 0, imageSize.width, originalsize.height));//获取图片整体部分
        }
        
        UIGraphicsBeginImageContext(imageSize);//指定要绘画图片的大小
        CGContextRef con = UIGraphicsGetCurrentContext();
        
        CGContextTranslateCTM(con, 0.0, imageSize.height);
        CGContextScaleCTM(con, 1.0, -1.0);
        
        CGContextDrawImage(con, CGRectMake(0, 0, imageSize.width, imageSize.height), imageRef);
        
        UIImage *standardImage = UIGraphicsGetImageFromCurrentImageContext();
        NSLog(@"改变后图片的宽度为%f,图片的高度为%f",[standardImage size].width,[standardImage size].height);
        
        UIGraphicsEndImageContext();
        CGImageRelease(imageRef);
        
        return standardImage;
    }
    
    //原图为标准长宽的，不做处理
    else
    {
        return originalImage;
    }
}
+ (UIImage *)scaleImage:(UIImage *)img ToSize:(CGSize)size{
    
//    UIGraphicsBeginImageContext(size);
//    
//    // 绘制改变大小的图片
//    [img drawInRect:CGRectMake(0, 0, size.width, size.height)];
//    
//    // 从当前context中创建一个改变大小后的图片
//    UIImage* scaledImage = UIGraphicsGetImageFromCurrentImageContext();
//    
//    // 使当前的context出堆栈
//    UIGraphicsEndImageContext();
//    
//    // 返回新的改变大小后的图片
//    return scaledImage;

    //Determine whether the screen is retina
    if([[UIScreen mainScreen] scale] == 2.0){      // @2x
        UIGraphicsBeginImageContextWithOptions(size, NO, 2.0);
    }else if([[UIScreen mainScreen] scale] == 3.0){ // @3x ( iPhone 6plus 、iPhone 6s plus)
        UIGraphicsBeginImageContextWithOptions(size, NO, 3.0);
    }else{
        UIGraphicsBeginImageContext(size);
    }
    // 绘制改变大小的图片
    [img drawInRect:CGRectMake(0, 0, size.width, size.height)];
    // 从当前context中创建一个改变大小后的图片
    UIImage* scaledImage = UIGraphicsGetImageFromCurrentImageContext();
    // 使当前的context出堆栈
    UIGraphicsEndImageContext();
    // 返回新的改变大小后的图片
    return scaledImage;
}

- (NSData *)compressedData:(CGFloat)compressionQuality
{
    if (compressionQuality<=1.0 && compressionQuality >=0)
    {
        return UIImageJPEGRepresentation(self, compressionQuality);
    }
    else
    {
        return UIImageJPEGRepresentation(self, 1.f);
    }
}

- (CGFloat)compressionQuality
{
    NSData *data = UIImageJPEGRepresentation(self, 1.0);
    NSUInteger dataLength = [data length];
    if(dataLength>kCompresseionDataLength)
    {
        return 1.0-kCompresseionDataLength/dataLength;
    }
    else
    {
        return 1.0;
    }
}

- (NSData *)compressedData {
    CGFloat quality = [self compressionQuality];
    return [self compressedData:quality];
}
//图片压缩到指定大小
- (UIImage*)imageByScalingAndCroppingForSize:(CGSize)targetSize
{
    UIImage *sourceImage = self;
    UIImage *newImage = nil;
    CGSize imageSize = sourceImage.size;
    CGFloat width = imageSize.width;
    CGFloat height = imageSize.height;
    CGFloat targetWidth = targetSize.width;
    CGFloat targetHeight = targetSize.height;
    CGFloat scaleFactor = 0.0;
    CGFloat scaledWidth = targetWidth;
    CGFloat scaledHeight = targetHeight;
    CGPoint thumbnailPoint = CGPointMake(0.0,0.0);
    
    if (CGSizeEqualToSize(imageSize, targetSize) == NO)
    {
        CGFloat widthFactor = targetWidth / width;
        CGFloat heightFactor = targetHeight / height;
        
        if (widthFactor > heightFactor)
            scaleFactor = heightFactor; // scale to fit height
        else
            scaleFactor = widthFactor; // scale to fit width
        scaledWidth= width * scaleFactor;
        scaledHeight = height * scaleFactor;
        
        // center the image
        if (widthFactor > heightFactor)
        {
            thumbnailPoint.x = (targetWidth - scaledWidth) * 0.5;
        }
        else if (widthFactor < heightFactor)
        {
            thumbnailPoint.y = (targetHeight - scaledHeight) * 0.5;
        }
    }
    
    UIGraphicsBeginImageContext(targetSize); // this will crop
    
    CGRect thumbnailRect = CGRectZero;
    thumbnailRect.origin = thumbnailPoint;
    thumbnailRect.size.width= scaledWidth;
    thumbnailRect.size.height = scaledHeight;
    
    [sourceImage drawInRect:thumbnailRect];
    
    newImage = UIGraphicsGetImageFromCurrentImageContext();
    if(newImage == nil)
        NSLog(@"could not scale image");
    
    //pop the context to get back to the default
    UIGraphicsEndImageContext();
    return newImage;
}

//设置图片透明度
+ (UIImage *)imageByApplyingAlpha:(CGFloat)alpha  image:(UIImage*)image
{
    UIGraphicsBeginImageContextWithOptions(image.size, NO, 0.0f);
    
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    CGRect area = CGRectMake(0, 0, image.size.width, image.size.height);
    
    CGContextScaleCTM(ctx, 1, -1);
    CGContextTranslateCTM(ctx, 0, -area.size.height);
    
    CGContextSetBlendMode(ctx, kCGBlendModeMultiply);
    
    CGContextSetAlpha(ctx, alpha);
    
    CGContextDrawImage(ctx, area, image.CGImage);
    
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    return newImage;
}
+ (UIImage *)blurImage:(UIImage *)image blur:(CGFloat)blur;
{
    // 模糊度越界
    if (blur < 0.f || blur > 1.f) {
        blur = 0.5f;
    }
    int boxSize = (int)(blur * 40);
    boxSize = boxSize - (boxSize % 2) + 1;
    CGImageRef img = image.CGImage;
    vImage_Buffer inBuffer, outBuffer;
    vImage_Error error;
    void *pixelBuffer;
    //从CGImage中获取数据
    CGDataProviderRef inProvider = CGImageGetDataProvider(img);
    CFDataRef inBitmapData = CGDataProviderCopyData(inProvider);
    //设置从CGImage获取对象的属性
    inBuffer.width = CGImageGetWidth(img);
    inBuffer.height = CGImageGetHeight(img);
    inBuffer.rowBytes = CGImageGetBytesPerRow(img);
    
    inBuffer.data = (void*)CFDataGetBytePtr(inBitmapData);
    
    pixelBuffer = malloc(CGImageGetBytesPerRow(img) *
                         CGImageGetHeight(img));
    
    if(pixelBuffer == NULL)
        NSLog(@"No pixelbuffer");
    
    outBuffer.data = pixelBuffer;
    outBuffer.width = CGImageGetWidth(img);
    outBuffer.height = CGImageGetHeight(img);
    outBuffer.rowBytes = CGImageGetBytesPerRow(img);
    
    error = vImageBoxConvolve_ARGB8888(&inBuffer, &outBuffer, NULL, 0, 0, boxSize, boxSize, NULL, kvImageEdgeExtend);
    
    if (error) {
        NSLog(@"error from convolution %ld", error);
    }
    
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGContextRef ctx = CGBitmapContextCreate(
                                             outBuffer.data,
                                             outBuffer.width,
                                             outBuffer.height,
                                             8,
                                             outBuffer.rowBytes,
                                             colorSpace,
                                             kCGImageAlphaNoneSkipLast);
    CGImageRef imageRef = CGBitmapContextCreateImage (ctx);
    UIImage *returnImage = [UIImage imageWithCGImage:imageRef];
    
    CGContextRelease(ctx);
    CGColorSpaceRelease(colorSpace);
    
    free(pixelBuffer);
    CFRelease(inBitmapData);
    
    CGColorSpaceRelease(colorSpace);
    CGImageRelease(imageRef);
    
    return returnImage;
}

+ (UIImage *)creatNonInterpolatedUIImageFormCIImage:(CIImage *)image withSize:(CGFloat)size
{
    CGRect extent = CGRectIntegral(image.extent);
    CGFloat scale = MIN(size/CGRectGetWidth(extent), size/CGRectGetHeight(extent));
    
    // 1. 创建bitmap
    size_t width = CGRectGetWidth(extent) * scale;
    size_t height = CGRectGetHeight(extent) * scale;
    CGColorSpaceRef cs = CGColorSpaceCreateDeviceGray();
    CGContextRef bitmapRef = CGBitmapContextCreate(nil, width, height, 8, 0, cs, (CGBitmapInfo)kCGImageAlphaNone);
    CIContext *context = [CIContext contextWithOptions:nil];
    CGImageRef bitmapImage = [context createCGImage:image fromRect:extent];
    CGContextSetInterpolationQuality(bitmapRef, kCGInterpolationNone);
    CGContextScaleCTM(bitmapRef, scale, scale);
    CGContextDrawImage(bitmapRef, extent, bitmapImage);
    
    // 2.保存bitmap图片
    CGImageRef scaledImage = CGBitmapContextCreateImage(bitmapRef);
    CGContextRelease(bitmapRef);
    CGImageRelease(bitmapImage);
    return [UIImage imageWithCGImage:scaledImage];
}
+ (UIImage *)imageWithBase64Str:(NSString *)base64Str
{
    if (![base64Str isKindOfClass:[NSString class]] || !base64Str || base64Str.length < 1) {
        return nil;
    }
    NSData *decodeData = [[NSData alloc]initWithBase64EncodedString:base64Str options:(NSDataBase64DecodingIgnoreUnknownCharacters)];
    // 将NSData转为UIImage
    UIImage *decodedImage = [UIImage imageWithData: decodeData];
    
    return decodedImage;
}

@end
