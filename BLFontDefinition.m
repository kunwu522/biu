//
//  BLFontDefinition.m
//  biu
//
//  Created by WuTony on 5/27/15.
//  Copyright (c) 2015 BiuLove. All rights reserved.
//

#import "BLFontDefinition.h"

@implementation BLFontDefinition

static NSString *NORMAL_FONT = @"HelveticaNeue";

+ (UIFont *)ultraLightFont:(CGFloat)fontSize {
    return [UIFont fontWithName:@"HelveticaNeue-UltraLight" size:fontSize];
}

+ (UIFont *)ultraLightItalic:(CGFloat)fontSize {
    return [UIFont fontWithName:@"HelveticaNeue-UltraLightItalic" size:fontSize];
}

+ (UIFont *)lightFont:(CGFloat)fontSize {
    return [UIFont fontWithName:@"HelveticaNeue-Light" size:fontSize];
}

+ (UIFont *)lightItalicFont:(CGFloat)fontSize {
    return [UIFont fontWithName:@"HelveticaNeue-LightItalic" size:fontSize];
}

+ (UIFont *)normalFont:(CGFloat)fontSize {
    return [UIFont fontWithName:@"HelveticaNeue" size:fontSize];
}

+ (UIFont *)italicFont:(CGFloat)fontSize {
    return [UIFont fontWithName:@"HelveticaNeue-Italic" size:fontSize];
}

+ (UIFont *)boldFont:(CGFloat)fontSize {
    return [UIFont fontWithName:@"HelveticaNeue-Bold" size:fontSize];
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
