//
//  BLTextField.m
//  biu
//
//  Created by Tony Wu on 5/8/15.
//  Copyright (c) 2015 BiuLove. All rights reserved.
//

#import "BLTextField.h"
#import "BLColorDefinition.h"

#import "Masonry.h"

@interface BLTextField ()

@end

@implementation BLTextField

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setup];
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self setup];
    }
    return self;
}

- (void)setup {
    self.font = [BLFontDefinition lightFont:15.0f];
    self.textColor = [UIColor whiteColor];
}

- (void)drawRect:(CGRect)rect {
    CALayer *border = [CALayer layer];
    CGFloat borderWidth = 1.0f;
    border.borderColor = [[UIColor colorWithRed:112.0 / 255.0 green:115.0 / 255.0 blue:122.0 / 255.0 alpha:1.0f] CGColor];
    border.borderWidth = borderWidth;
    border.frame = CGRectMake(0, rect.size.height - borderWidth, rect.size.width, borderWidth);
    
    [self.layer addSublayer:border];
    self.layer.masksToBounds = YES;
}

- (CGRect)textRectForBounds:(CGRect)bounds {
    bounds.origin.x += 1;
    return bounds;
}

- (CGRect)editingRectForBounds:(CGRect)bounds {
    bounds.origin.x += 1;
    return bounds;
}

- (void)drawPlaceholderInRect:(CGRect)rect {
    if (self.placeholder) {
        UIFont *placeholderTextFont = [BLFontDefinition lightItalicFont:13.0f];
        UIColor *placeholderTextColor = [BLColorDefinition grayColor];
        
        NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
        paragraphStyle.alignment = self.textAlignment;
        
        // dictionary of attributes, font, paragraphstyle, and color
        NSDictionary *drawAttributes = @{NSFontAttributeName: placeholderTextFont,
                                         NSParagraphStyleAttributeName : paragraphStyle,
                                         NSForegroundColorAttributeName : placeholderTextColor};
        
//        rect.origin.y = (rect.size.height - self.font.lineHeight) / 2.0f;
//        rect.size.height = self.font.lineHeight;
        rect.origin.x += 1;
        rect.origin.y += 1;
        
        [self.placeholder drawInRect:rect withAttributes:drawAttributes];
    }
}

@end
