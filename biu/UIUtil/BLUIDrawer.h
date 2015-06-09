//
//  BLUIDrawer.h
//  biu
//
//  Created by Tony Wu on 6/9/15.
//  Copyright (c) 2015 BiuLove. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BLUIDrawer : NSObject

+ (CAShapeLayer *)drawSinglelineWithStartPoint:(CGPoint)startPoint EndPoint:(CGPoint)endPoint Color:(CGColorRef)color;

@end
