//
//  BLTextField.m
//  biu
//
//  Created by Tony Wu on 5/8/15.
//  Copyright (c) 2015 BiuLove. All rights reserved.
//

#import "BLTextField.h"

@implementation BLTextField

- (CGRect)placeholderRectForBounds:(CGRect)bounds {
    bounds.origin.x += 3;
    return bounds;
}

- (CGRect)textRectForBounds:(CGRect)bounds {
    bounds.origin.x += 3;
    return bounds;
}

- (void)drawPlaceholderInRect:(CGRect)rect {
    if (self.placeholder) {
        UIFont *placeholderTextFont = [UIFont fontWithName:@"Arial-ItalicMT" size:14];
        UIColor *placeholderTextColor = [UIColor grayColor];
        
        NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
        paragraphStyle.alignment = self.textAlignment;
        
        // dictionary of attributes, font, paragraphstyle, and color
        NSDictionary *drawAttributes = @{NSFontAttributeName: placeholderTextFont,
                                         NSParagraphStyleAttributeName : paragraphStyle,
                                         NSForegroundColorAttributeName : placeholderTextColor};
        
        [self.placeholder drawInRect:rect withAttributes:drawAttributes];
    }
}

- (void)drawRect:(CGRect)rect {
    CALayer *border = [CALayer layer];
    CGFloat borderWidth = 0.5f;
    border.backgroundColor = [[UIColor colorWithRed:107.0 / 255.0 green:108.0 / 255.0 blue:112.0 / 255.0 alpha:1.0f] CGColor];
    border.frame = CGRectMake(0, rect.size.height - borderWidth, rect.size.width, borderWidth);
    
    [self.layer addSublayer:border];
    [super drawRect:rect];
}

@end
