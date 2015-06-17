//
//  BLMenuButton.m
//  biu
//
//  Created by Tony Wu on 6/2/15.
//  Copyright (c) 2015 BiuLove. All rights reserved.
//

#import "BLMenuButton.h"
#import "Masonry.h"

@interface BLMenuButton ()

@property (strong, nonatomic) UIImageView *imageViewIcon;
@property (strong, nonatomic) UILabel *lbTitle;

@end

@implementation BLMenuButton

#pragma mark -
#pragma mark Initialzation
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
    self.backgroundColor = [UIColor clearColor];
    
    _imageViewIcon = [[UIImageView alloc] init];
    _imageViewIcon.backgroundColor = [UIColor clearColor];
    _imageViewIcon.userInteractionEnabled = NO;
    [self addSubview:_imageViewIcon];
    
    _lbTitle = [[UILabel alloc] init];
    _lbTitle.backgroundColor = [UIColor clearColor];
    _lbTitle.textAlignment = NSTextAlignmentRight;
    _lbTitle.font = [BLFontDefinition normalFont:20.0f];
    _lbTitle.userInteractionEnabled = NO;
    [self addSubview:_lbTitle];
    
    [self.imageViewIcon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.imageViewIcon.superview);
        make.top.equalTo(self.imageViewIcon.superview);
        make.bottom.equalTo(self.imageViewIcon.superview);
        make.width.equalTo(@35.4f);
    }];
    
    [self.lbTitle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.lbTitle.superview);
        make.bottom.equalTo(self.lbTitle.superview);
        make.left.equalTo(self.imageViewIcon.mas_right).with.offset(20.7f);
    }];
}

#pragma mark -
#pragma mark Touches
- (void)setHighlighted:(BOOL)highlighted {
    if (highlighted) {
        if (self.highlightIcon) {
            self.imageViewIcon.image = self.highlightIcon;
        }
        if (self.highlightColor) {
            self.lbTitle.textColor = self.highlightColor;
        }
    } else {
        self.imageViewIcon.image = self.icon;
        self.lbTitle.textColor = self.blTitleColor;
    }
    [super setHighlighted:highlighted];
}

#pragma mark -
#pragma mark Setter
- (void)setBlTitle:(NSString *)blTitle {
    _blTitle = blTitle;
    self.lbTitle.text = blTitle;
}

- (void)setBlTitleColor:(UIColor *)blTitleColor {
    _blTitleColor = blTitleColor;
    self.lbTitle.textColor = blTitleColor;
}

- (void)setIcon:(UIImage *)icon {
    _icon = icon;
    self.imageViewIcon.image = icon;
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
