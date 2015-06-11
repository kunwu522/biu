//
//  BLFontDefinition.m
//  biu
//
//  Created by WuTony on 5/27/15.
//  Copyright (c) 2015 BiuLove. All rights reserved.
//

#import "BLFontDefinition.h"

@implementation BLFontDefinition

static NSString *FONT_LIGHT = @"FontLight";
static NSString *FONT_LIGHT_ITALIC = @"FontLightItalic";
static NSString *FONT_NORMAL = @"FontNormal";
static NSString *FONT_NORMAL_ITALIC = @"FontNormalItalic";
static NSString *FONT_BOLD = @"FontBold";

+ (UIFont *)lightFont:(CGFloat)fontSize {
    return [UIFont fontWithName:NSLocalizedString(FONT_LIGHT, nil) size:fontSize];
}

+ (UIFont *)lightItalicFont:(CGFloat)fontSize {
    return [UIFont fontWithName:NSLocalizedString(FONT_LIGHT_ITALIC, nil) size:fontSize];
}

+ (UIFont *)normalFont:(CGFloat)fontSize {
    return [UIFont fontWithName:NSLocalizedString(FONT_NORMAL, nil) size:fontSize];
}

+ (UIFont *)italicFont:(CGFloat)fontSize {
    return [UIFont fontWithName:NSLocalizedString(FONT_NORMAL_ITALIC, nil) size:fontSize];
}

+ (UIFont *)boldFont:(CGFloat)fontSize {
    return [UIFont fontWithName:NSLocalizedString(FONT_BOLD, nil) size:fontSize];
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
