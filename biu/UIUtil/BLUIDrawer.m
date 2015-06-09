//
//  BLUIDrawer.m
//  biu
//
//  Created by Tony Wu on 6/9/15.
//  Copyright (c) 2015 BiuLove. All rights reserved.
//

#import "BLUIDrawer.h"

@implementation BLUIDrawer

+ (CAShapeLayer *)drawSinglelineWithStartPoint:(CGPoint)startPoint EndPoint:(CGPoint)endPoint Color:(CGColorRef)color {
    UIBezierPath *path = [UIBezierPath bezierPath];
    [path moveToPoint:startPoint];
    [path addLineToPoint:endPoint];
    
    CAShapeLayer *layer = [CAShapeLayer layer];
    layer.path = [path CGPath];
    layer.strokeColor = color;
    layer.lineWidth = 1.0f;
    layer.fillColor = [UIColor clearColor].CGColor;
    [layer setMasksToBounds:NO];
    
    return layer;
}

@end
