//
//  BLGenernalDefinition.m
//  biu
//
//  Created by Tony Wu on 7/14/15.
//  Copyright (c) 2015 BiuLove. All rights reserved.
//

#import "BLGenernalDefinition.h"

@implementation BLGenernalDefinition

+ (CGFloat)resolutionForDevices:(CGFloat)size {
    if (IS_IPHONE_5) {
        return size * 0.85f;
    } else if (IS_IPHONE_6_PLUS) {
        return size * 1.10f;
    } else {
        return size;
    }
}

@end
