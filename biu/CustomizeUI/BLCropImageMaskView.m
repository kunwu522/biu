//
//  BLCropImageMaskView.m
//  biu
//
//  Created by Tony Wu on 6/18/15.
//  Copyright (c) 2015 BiuLove. All rights reserved.
//

#import "BLCropImageMaskView.h"

@interface BLCropImageMaskView ()

@property (assign, nonatomic) CGRect cropRect;

@end

@implementation BLCropImageMaskView

- (void)setCropSize:(CGSize)size {
    CGFloat x = (CGRectGetWidth(self.bounds) - size.width) / 2;
    CGFloat y = (CGRectGetHeight(self.bounds) - size.height) / 2;
    _cropRect = CGRectMake(x, y, size.width, size.height);
    
    [self setNeedsDisplay];
}

- (CGSize)cropSize {
    return _cropRect.size;
}

- (CGRect)cropBounds {
    return _cropRect;
}

- (void)drawRect:(CGRect)rect {
    [super drawRect:rect];
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    CGContextSetRGBFillColor(ctx, 0, 0, 0, .4);
    CGContextFillRect(ctx, self.bounds);
    
    CGRect clippingEllipseRect = _cropRect;
    CGContextAddEllipseInRect(ctx, clippingEllipseRect);
    
    CGContextClip(ctx);
    
    CGContextClearRect(ctx, clippingEllipseRect);
}

@end
