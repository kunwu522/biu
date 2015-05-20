//
//  BLTextField.m
//  biu
//
//  Created by Tony Wu on 5/8/15.
//  Copyright (c) 2015 BiuLove. All rights reserved.
//

#import "BLTextField.h"
#import "BLColorDefinition.h"

@implementation BLTextField

- (void)drawPlaceholderInRect:(CGRect)rect {
    if (self.placeholder) {
        UIFont *placeholderTextFont = [UIFont fontWithName:@"ArialMT" size:15];
        UIColor *placeholderTextColor = [BLColorDefinition grayColor];
        
        NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
        paragraphStyle.alignment = self.textAlignment;
        
        // dictionary of attributes, font, paragraphstyle, and color
        NSDictionary *drawAttributes = @{NSFontAttributeName: placeholderTextFont,
                                         NSParagraphStyleAttributeName : paragraphStyle,
                                         NSForegroundColorAttributeName : placeholderTextColor};
        
        rect.origin.y = (rect.size.height - self.font.lineHeight) / 2.0f;
        rect.size.height = self.font.lineHeight;
        
        [self.placeholder drawInRect:rect withAttributes:drawAttributes];
    }
}

@end
