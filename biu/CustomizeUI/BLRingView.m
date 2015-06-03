//
//  BLRingView.m
//  biu
//
//  Created by Tony Wu on 6/3/15.
//  Copyright (c) 2015 BiuLove. All rights reserved.
//

#import "BLRingView.h"

@implementation BLRingView


// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
    CGContextRef contextRef = UIGraphicsGetCurrentContext();
    CGContextSetLineWidth(contextRef, self.ringWidth);
    CGContextSetStrokeColorWithColor(contextRef, self.ringColor.CGColor);
    CGContextStrokeEllipseInRect(contextRef, rect);
}


@end
