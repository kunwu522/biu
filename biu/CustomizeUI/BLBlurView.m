//
//  BLBlurView.m
//  biu
//
//  Created by Tony Wu on 6/1/15.
//  Copyright (c) 2015 BiuLove. All rights reserved.
//

#import "BLBlurView.h"
#import "UIImage+ImageEffects.h"

/// Blur color components.
///
@interface BLColorComponents : NSObject

@property(nonatomic, assign) CGFloat radius;
@property(nonatomic, strong) UIColor *tintColor;
@property(nonatomic, assign) CGFloat saturationDeltaFactor;
@property(nonatomic, strong) UIImage *maskImage;

///Light color effect.
///
+ (BLColorComponents *) lightEffect;

///Dark color effect.
///
+ (BLColorComponents *) darkEffect;

+ (BLColorComponents *) condensedDarkDarkEffect;

+ (BLColorComponents *) purpleEffect;

@end

@interface BLBlurView ()

@property (retain, nonatomic) BLColorComponents *colorCompoents;

@end

@implementation BLBlurView

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.blurStyle = BLBlurStyleDark;
        _colorCompoents = [BLColorComponents darkEffect];
        self.backgroundImageView = [[UIImageView alloc] initWithFrame:self.bounds];
        [self addSubview:self.backgroundImageView];
    }
    return self;
}


- (void)blurWithView:(UIView *)view {
    if (CGRectIsEmpty(self.frame)) {
        self.frame = CGRectMake(0, 0, view.frame.size.width, view.frame.size.height);
    }
    
    UIGraphicsBeginImageContextWithOptions(CGSizeMake(CGRectGetWidth(self.frame), CGRectGetHeight(self.frame)), NO, 1);
    [view drawViewHierarchyInRect:CGRectMake(0, 0, view.frame.size.width, view.frame.size.height) afterScreenUpdates:NO];
    
    __block UIImage *snapshot = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        //Blur finished in 0.004884 seconds.
        snapshot = [snapshot applyBlurWithRadius:_colorCompoents.radius tintColor:_colorCompoents.tintColor saturationDeltaFactor:_colorCompoents.saturationDeltaFactor maskImage:_colorCompoents.maskImage];
//        snapshot = [snapshot applyDarkEffect];
        
        dispatch_sync(dispatch_get_main_queue(), ^{
            self.backgroundImageView.image = snapshot;
        });
    });
}

- (void)blurWithViewAync:(UIView *)view {
    if (CGRectIsEmpty(self.frame)) {
        self.frame = CGRectMake(0, 0, view.frame.size.width, view.frame.size.height);
    }
    UIGraphicsBeginImageContextWithOptions(CGSizeMake(CGRectGetWidth(self.frame), CGRectGetHeight(self.frame)), NO, 1);
    [view drawViewHierarchyInRect:CGRectMake(0, 0, view.frame.size.width, view.frame.size.height) afterScreenUpdates:NO];
    UIImage *snapshot = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    snapshot = [snapshot applyDarkEffect];
    self.backgroundImageView.image = snapshot;
}

- (void)setBlurStyle:(BLBlurStyle)blurStyle {
    switch (blurStyle) {
        case BLBlurStyleDark:
            _colorCompoents = [BLColorComponents darkEffect];
            break;
        case BLBlurStyleLight:
            _colorCompoents = [BLColorComponents lightEffect];
            break;
        case BLBlurCondensedDark:
            _colorCompoents = [BLColorComponents condensedDarkDarkEffect];
            break;
        case BLBlurStylePurple:
            _colorCompoents = [BLColorComponents purpleEffect];
        default:
            break;
    }
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end

@implementation BLColorComponents

+ (BLColorComponents *) lightEffect {
    BLColorComponents *components = [[BLColorComponents alloc] init];
    
    components.radius = 6;
    components.tintColor = [UIColor colorWithWhite:.8f alpha:.2f];
    components.saturationDeltaFactor = 1.8f;
    components.maskImage = nil;
    
    return components;
}

+ (BLColorComponents *) darkEffect {
    BLColorComponents *components = [[BLColorComponents alloc] init];
    
    components.radius = 8;
    components.tintColor = [UIColor colorWithRed:0.0f green:0.0 blue:0.0f alpha:0.5f];
    components.saturationDeltaFactor = 5.0f;
    components.maskImage = nil;
    
    return components;
}

+ (BLColorComponents *) purpleEffect {
    BLColorComponents *components = [[BLColorComponents alloc] init];
    
    components.radius = 30;
    components.tintColor = [UIColor colorWithRed:64.0 / 255.0 green:66.0 / 255.0 blue:75.0 / 255.0 alpha:0.9];
    components.saturationDeltaFactor = 1.8f;
    components.maskImage = nil;
    
    return components;
}

+ (BLColorComponents *) condensedDarkDarkEffect {
    BLColorComponents *components = [[BLColorComponents alloc] init];
    
    components.radius = 20;
    components.tintColor = [UIColor colorWithWhite:0.11 alpha:0.73];
    components.saturationDeltaFactor = 1.8f;
    components.maskImage = nil;
    
    return components;
}

@end


