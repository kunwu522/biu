//
//  BLImageUtil.h
//  biu
//
//  Created by Tony Wu on 7/3/15.
//  Copyright (c) 2015 BiuLove. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BLImageUtil : NSObject

+ (UIImage *)imageWithCompress:(UIImage *)image;
+ (UIImage *)imageWithImage:(UIImage *)image aspectScaleFitSize:(CGSize)size;
+ (UIImage *)rotatePhotoToUp:(UIImage *)image;

@end
