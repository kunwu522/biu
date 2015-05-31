//
//  BLFontDefinition.m
//  biu
//
//  Created by WuTony on 5/27/15.
//  Copyright (c) 2015 BiuLove. All rights reserved.
//

#import "BLFontDefinition.h"

@implementation BLFontDefinition

static NSString *NORMAL_FONT = @"ArialMT";


+ (UIFont *)normalFont:(CGFloat)fontSize {
    return [UIFont fontWithName:@"ArialMT" size:fontSize];
}

+ (UIFont *)boldFont:(CGFloat)fontSize {
    return [UIFont fontWithName:@"Arial-BoldMT" size:fontSize];
}

+ (CGSize)normalFontSizeForString:(NSString *)string fontSize:(CGFloat)fontSize {
    CGSize size;
#ifdef __IPHONE_7_0
    size = [string sizeWithAttributes:@{NSFontAttributeName: [BLFontDefinition normalFont:fontSize]}];
#else
    size = [string sizeWithFont:[BLFontDefinition normalFont:fontSize]];
#endif
    return size;
}

@end
