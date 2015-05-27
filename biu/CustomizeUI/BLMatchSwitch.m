//
//  BLMatchSwitch.m
//  biu
//
//  Created by Tony Wu on 5/27/15.
//  Copyright (c) 2015 BiuLove. All rights reserved.
//

#import "BLMatchSwitch.h"
@interface BLMatchSwitch () {
    BOOL currentVisualValue;
    BOOL startTrackingValue;
    BOOL didChangeWhileTracking;
    BOOL isAnimating;
}

@property (retain, nonatomic) UIColor *inactiveColor;
@property (retain, nonatomic) UIColor *activeColor;
@property (retain, nonatomic) UIColor *borderColor;
@property (retain, nonatomic) UIColor *shadowColor;

@property (retain, nonatomic) UIView *background;
@property (retain, nonatomic) UIView *nob;
@property (retain, nonatomic) UIImageView *imageViewNob;

- (void)showOn:(BOOL)animated;
- (void)showOff:(BOOL)animated;
- (void)setup;

@end

@implementation BLMatchSwitch

@synthesize on;

- (id)init {
    self = [super initWithFrame:CGRectMake(0, 0, 250.0f, 78.0f)];
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

- (id)initWithFrame:(CGRect)frame {
    CGRect initialFrame;
    if (CGRectIsEmpty(frame)) {
        initialFrame = CGRectMake(0, 0, 250.f, 78.0f);
    } else {
        initialFrame = frame;
    }
    self = [super initWithFrame:frame];
    if (self) {
        [self setup];
    }
    return self;
}

- (void)setup {
    self.on = NO;
    _inactiveColor = [UIColor colorWithRed:213.0 / 255.0 green:217.0 / 255.0 blue:221.0 / 255.0 alpha:1.0f];
    _activeColor = [UIColor colorWithRed:68.0 / 255.0 green:229.0 / 255.0 blue:175.0 / 255.0 alpha:1.0f];
    currentVisualValue = NO;
    
    _background = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
    _background.backgroundColor = [UIColor clearColor];
    _background.layer.cornerRadius = self.frame.size.height * 0.5f;
    _background.userInteractionEnabled = NO;
    _background.clipsToBounds = YES;
    [self addSubview:_background];
    
    _nob = [[UIView alloc] initWithFrame:CGRectMake(1, 1, self.frame.size.height - 2, self.frame.size.height - 2)];
    _nob.backgroundColor = [UIColor clearColor];
    _nob.layer.cornerRadius = (self.frame.size.height * 0.5) - 1;
    _nob.layer.masksToBounds = NO;
    _nob.userInteractionEnabled = NO;
    [self addSubview:_nob];
    
    _imageViewNob = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, _nob.frame.size.width, _nob.frame.size.height)];
    _imageViewNob.image = [UIImage imageNamed:@"logo.png"];
    _imageViewNob.contentMode = UIViewContentModeCenter;
    _imageViewNob.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    [_nob addSubview:_imageViewNob];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

#pragma mark - Touch Tracking
- (BOOL)beginTrackingWithTouch:(UITouch *)touch withEvent:(UIEvent *)event {
    [super beginTrackingWithTouch:touch withEvent:event];
    
    startTrackingValue = self.on;
    didChangeWhileTracking = NO;
    
    CGFloat activeKnobWidth = self.bounds.size.height - 2 + 5;
    isAnimating = YES;
    [UIView animateWithDuration:0.3 delay:0.0 options:UIViewAnimationOptionCurveEaseOut|UIViewAnimationOptionBeginFromCurrentState animations:^{
        if (self.on) {
            _nob.frame = CGRectMake(self.bounds.size.width - (activeKnobWidth + 1), _nob.frame.origin.y, activeKnobWidth, _nob.frame.size.height);
            _background.backgroundColor = _inactiveColor;
        }
        else {
            _nob.frame = CGRectMake(_nob.frame.origin.x, _nob.frame.origin.y, activeKnobWidth, _nob.frame.size.height);
            _background.backgroundColor = _activeColor;
        }
    } completion:^(BOOL finished) {
        isAnimating = NO;
    }];
    
    return YES;
}

- (BOOL)continueTrackingWithTouch:(UITouch *)touch withEvent:(UIEvent *)event {
    [super continueTrackingWithTouch:touch withEvent:event];
    
    // Get touch location
    CGPoint lastPoint = [touch locationInView:self];
    
    // update the switch to the correct visuals depending on if
    // they moved their touch to the right or left side of the switch
    if (lastPoint.x > self.bounds.size.width * 0.5) {
        [self showOn:YES];
        if (!startTrackingValue) {
            didChangeWhileTracking = YES;
        }
    }
    else {
        [self showOff:YES];
        if (startTrackingValue) {
            didChangeWhileTracking = YES;
        }
    }
    
    return YES;
}

- (void)endTrackingWithTouch:(UITouch *)touch withEvent:(UIEvent *)event {
    [super endTrackingWithTouch:touch withEvent:event];
    
    BOOL previousValue = self.on;
    
    if (didChangeWhileTracking) {
        [self setOn:currentVisualValue animated:YES];
    }
    else {
        [self setOn:!self.on animated:YES];
    }
    
    if (previousValue != self.on)
        [self sendActionsForControlEvents:UIControlEventValueChanged];
}

- (void)cancelTrackingWithEvent:(UIEvent *)event {
    [super cancelTrackingWithEvent:event];
    
    // just animate back to the original value
    if (self.on)
        [self showOn:YES];
    else
        [self showOff:YES];
}

#pragma mark State Changes


/*
 * update the looks of the switch to be in the on position
 * optionally make it animated
 */
- (void)showOn:(BOOL)animated {
    CGFloat normalKnobWidth = self.bounds.size.height - 2;
    CGFloat activeKnobWidth = normalKnobWidth + 5;
    if (animated) {
        isAnimating = YES;
        [UIView animateWithDuration:0.3 delay:0.0 options:UIViewAnimationOptionCurveEaseOut|UIViewAnimationOptionBeginFromCurrentState animations:^{
            if (self.tracking)
                _nob.frame = CGRectMake(self.bounds.size.width - (activeKnobWidth + 1), _nob.frame.origin.y, activeKnobWidth, _nob.frame.size.height);
            else
                _nob.frame = CGRectMake(self.bounds.size.width - (normalKnobWidth + 1), _nob.frame.origin.y, normalKnobWidth, _nob.frame.size.height);
            _background.backgroundColor = _activeColor;
        } completion:^(BOOL finished) {
            isAnimating = NO;
        }];
    }
    
    currentVisualValue = YES;
}

/*
 * update the looks of the switch to be in the off position
 * optionally make it animated
 */
- (void)showOff:(BOOL)animated {
    CGFloat normalKnobWidth = self.bounds.size.height - 2;
    CGFloat activeKnobWidth = normalKnobWidth + 5;
    if (animated) {
        isAnimating = YES;
        [UIView animateWithDuration:0.3 delay:0.0 options:UIViewAnimationOptionCurveEaseOut|UIViewAnimationOptionBeginFromCurrentState animations:^{
            if (self.tracking) {
                _nob.frame = CGRectMake(1, _nob.frame.origin.y, activeKnobWidth, _nob.frame.size.height);
                _background.backgroundColor = self.activeColor;
            }
            else {
                _nob.frame = CGRectMake(1, _nob.frame.origin.y, normalKnobWidth, _nob.frame.size.height);
                _background.backgroundColor = self.inactiveColor;
            }
        } completion:^(BOOL finished) {
            isAnimating = NO;
        }];
    }
    
    currentVisualValue = NO;
}

/*
 * Set (without animation) whether the switch is on or off
 */
- (void)setOn:(BOOL)isOn {
    [self setOn:isOn animated:NO];
}


/*
 * Set the state of the switch to on or off, optionally animating the transition.
 */
- (void)setOn:(BOOL)isOn animated:(BOOL)animated {
    self.on = isOn;
    
    if (isOn) {
        [self showOn:animated];
    }
    else {
        [self showOff:animated];
    }
}

@end
