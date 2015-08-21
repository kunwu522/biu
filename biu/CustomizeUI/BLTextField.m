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

#pragma mark -
#pragma mark Initialization
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
    [[UITextField appearance] setTintColor:[BLColorDefinition greenColor]];
}

#pragma mark -
#pragma mark Public method
- (void)showClearButton {
    UIButton *clearButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [clearButton setImage:[UIImage imageNamed:@"textfield_delete_icon.png"] forState:UIControlStateNormal];
    [clearButton addTarget:self action:@selector(clearTextField:) forControlEvents:UIControlEventTouchUpInside];
    
    self.rightViewMode = UITextFieldViewModeWhileEditing; //can be changed to UITextFieldViewModeNever,    UITextFieldViewModeWhileEditing,   UITextFieldViewModeUnlessEditing
    [self setRightView:clearButton];
}

#pragma mark -
#pragma mark Actions
- (void)clearTextField:(id)sender {
    self.text = @"";
}

#pragma mark -
#pragma mark Customize Textfield
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

- (CGRect)rightViewRectForBounds:(CGRect)bounds {
    CGFloat width = bounds.size.height - 8;
    return CGRectMake(bounds.size.width - bounds.size.height, (bounds.size.height - width) * 0.5, width, width);
}

- (void)drawPlaceholderInRect:(CGRect)rect {
    if (self.placeholder) {
        UIFont *placeholderTextFont = [BLFontDefinition lightItalicFont:15.0f];
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
