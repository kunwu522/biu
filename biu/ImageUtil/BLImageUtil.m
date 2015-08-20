//
//  BLImageUtil.m
//  biu
//
//  Created by Tony Wu on 7/3/15.
//  Copyright (c) 2015 BiuLove. All rights reserved.
//

#import "BLImageUtil.h"

#define MAX_UPLOAD_IMAGE_SIZE 8 * 1024 * 1024
#define MAX_IMAGE_WIDTH 1500
#define MAX_IMAGE_HEIGHT 1500

@implementation BLImageUtil

+ (UIImage *)imageWithCompress:(UIImage *)image
{
    //Resize image
    if (image.size.width > MAX_IMAGE_WIDTH || image.size.height > MAX_IMAGE_HEIGHT) {
        image = [BLImageUtil imageWithImage:image aspectScaleFitSize:CGSizeMake(MAX_IMAGE_WIDTH, MAX_IMAGE_HEIGHT)];
        NSLog(@"after scale, image size: %f-%f", image.size.width, image.size.height);
    }
    
    //Compress image
    CGFloat compression = 1.0f;
    CGFloat maxCompression = 0.1f;
    
    NSData *imageData = UIImageJPEGRepresentation(image, compression);
    while (imageData.length > MAX_UPLOAD_IMAGE_SIZE && compression > maxCompression) {
        compression -=0.1f;
        imageData = UIImageJPEGRepresentation(image, compression);
    }
    NSLog(@"Image length: %ld", (unsigned long)imageData.length);
    
    if (imageData.length > MAX_UPLOAD_IMAGE_SIZE) {
        return nil;
    }
    return [[UIImage alloc] initWithData:imageData];
}

+ (UIImage *)imageWithImage:(UIImage *)image aspectScaleFitSize:(CGSize)size
{
    CGFloat ratio = fminf(size.height / image.size.height, size.width / image.size.width);
    
    CGFloat width = image.size.width * ratio;
    CGFloat heigth = image.size.height * ratio;
    
    return [BLImageUtil imageWithImage:image toSize:CGSizeMake(width, heigth)];
}

+ (UIImage *)imageWithImage:(UIImage *)image toSize:(CGSize)size
{
    UIGraphicsBeginImageContext(size);
    [image drawInRect:CGRectMake(0, 0, size.width, size.height)];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return newImage;
}

+ (UIImage *)rotatePhotoToUp:(UIImage *)image {
    // No-op if the orientation is already correct
    if (image.imageOrientation == UIImageOrientationUp) return image;
    
    // We need to calculate the proper transformation to make the image upright.
    // We do it in 2 steps: Rotate if Left/Right/Down, and then flip if Mirrored.
    CGAffineTransform transform = CGAffineTransformIdentity;
    
    switch (image.imageOrientation) {
        case UIImageOrientationDown:
        case UIImageOrientationDownMirrored:
            transform = CGAffineTransformTranslate(transform, image.size.width, image.size.height);
            transform = CGAffineTransformRotate(transform, M_PI);
            break;
            
        case UIImageOrientationLeft:
        case UIImageOrientationLeftMirrored:
            transform = CGAffineTransformTranslate(transform, image.size.width, 0);
            transform = CGAffineTransformRotate(transform, M_PI_2);
            break;
            
        case UIImageOrientationRight:
        case UIImageOrientationRightMirrored:
            transform = CGAffineTransformTranslate(transform, 0, image.size.height);
            transform = CGAffineTransformRotate(transform, -M_PI_2);
            break;
        case UIImageOrientationUp:
        case UIImageOrientationUpMirrored:
            break;
    }
    
    switch (image.imageOrientation) {
        case UIImageOrientationUpMirrored:
        case UIImageOrientationDownMirrored:
            transform = CGAffineTransformTranslate(transform, image.size.width, 0);
            transform = CGAffineTransformScale(transform, -1, 1);
            break;
            
        case UIImageOrientationLeftMirrored:
        case UIImageOrientationRightMirrored:
            transform = CGAffineTransformTranslate(transform, image.size.height, 0);
            transform = CGAffineTransformScale(transform, -1, 1);
            break;
        case UIImageOrientationUp:
        case UIImageOrientationDown:
        case UIImageOrientationLeft:
        case UIImageOrientationRight:
            break;
    }
    
    // Now we draw the underlying CGImage into a new context, applying the transform
    // calculated above.
    CGContextRef ctx = CGBitmapContextCreate(NULL, image.size.width, image.size.height,
                                             CGImageGetBitsPerComponent(image.CGImage), 0,
                                             CGImageGetColorSpace(image.CGImage),
                                             CGImageGetBitmapInfo(image.CGImage));
    CGContextConcatCTM(ctx, transform);
    switch (image.imageOrientation) {
        case UIImageOrientationLeft:
        case UIImageOrientationLeftMirrored:
        case UIImageOrientationRight:
        case UIImageOrientationRightMirrored:
            // Grr...
            CGContextDrawImage(ctx, CGRectMake(0,0,image.size.height,image.size.width), image.CGImage);
            break;
            
        default:
            CGContextDrawImage(ctx, CGRectMake(0,0,image.size.width,image.size.height), image.CGImage);
            break;
    }
    
    // And now we just create a new UIImage from the drawing context
    CGImageRef cgimg = CGBitmapContextCreateImage(ctx);
    UIImage *img = [UIImage imageWithCGImage:cgimg];
    CGContextRelease(ctx);
    CGImageRelease(cgimg);
    return img;    
}

@end
