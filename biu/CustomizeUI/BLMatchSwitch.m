//
//  BLMatchSwitchTest.m
//  biu
//
//  Created by WuTony on 5/30/15.
//  Copyright (c) 2015 BiuLove. All rights reserved.
//

#import "BLMatchSwitch.h"

@interface BLMatchSwitch () {
    CGPoint _previousTouchPoint;
    CGFloat _maxDelta;
    CGPoint _startKnobCenter;
    CGPoint _startInactiveBg;
    CGPoint _startActiveBg;
}

@property (retain, nonatomic) UIView *inactiveBackground;
@property (retain, nonatomic) UIView *activeBackground;
@property (retain, nonatomic) UILabel *inactiveLabel;
@property (retain, nonatomic) UILabel *activeLabel;
@property (retain, nonatomic) UIImageView *nob;

@end

@implementation BLMatchSwitch

@synthesize on;

- (void)setup {
    if (CGRectIsEmpty(self.frame)) {
        self.frame = CGRectMake(0, 0, 250.0f, 78.0f);
    }
    self.layer.cornerRadius = self.frame.size.height / 2.0f;
    self.clipsToBounds = YES;
    
    _activeBackground = [[UIView alloc] initWithFrame:CGRectMake(self.frame.size.height - self.frame.size.width, 0, self.frame.size.width, self.frame.size.height)];
    _activeBackground.backgroundColor = [UIColor colorWithRed:68.0 / 255.0 green:229.0 / 255.0 blue:175.0 / 255.0 alpha:1.0f];
    _activeBackground.userInteractionEnabled = NO;
    _activeBackground.layer.cornerRadius = _activeBackground.frame.size.height * 0.5f;
    _activeBackground.clipsToBounds = YES;
    [self addSubview:_activeBackground];
    
    NSString *activeText = NSLocalizedString(@"Matching...", nil);
    CGSize activeLabelSize = [BLFontDefinition normalFontSizeForString:activeText fontSize:18.0f];
    _activeLabel = [[UILabel alloc] initWithFrame:CGRectMake((_activeBackground.frame.size.width - activeLabelSize.width) * 0.5 - 25,
                                                             (_activeBackground.frame.size.height - activeLabelSize.height) * 0.5,
                                                             activeLabelSize.width, activeLabelSize.height)];
    _activeLabel.textAlignment = NSTextAlignmentCenter;
    _activeLabel.textColor = [UIColor whiteColor];
    _activeLabel.font = [BLFontDefinition normalFont:18.0f];
    _activeLabel.numberOfLines = 1;
    _activeLabel.text = activeText;
    _activeLabel.userInteractionEnabled = NO;
    [_activeBackground addSubview:_activeLabel];
    
    _inactiveBackground = [[UIView alloc] initWithFrame:self.bounds];
    _inactiveBackground.backgroundColor = [UIColor colorWithRed:213.0 / 255.0 green:217.0 / 255.0 blue:221.0 / 255.0 alpha:1.0f];
    _inactiveBackground.userInteractionEnabled = NO;
    _inactiveBackground.layer.cornerRadius = _inactiveBackground.frame.size.height * 0.5f;
    _inactiveBackground.clipsToBounds = YES;
    [self addSubview:_inactiveBackground];
    
    NSString *inactiveText = NSLocalizedString(@"Slide to love", nil);
    CGSize inactiveLabelSize = [BLFontDefinition normalFontSizeForString:inactiveText fontSize:18.0f];
    _inactiveLabel = [[UILabel alloc] initWithFrame:CGRectMake((_inactiveBackground.frame.size.width - inactiveLabelSize.width) * 0.5 + 25,
                                                       (_inactiveBackground.frame.size.height - inactiveLabelSize.height) * 0.5,
                                                       inactiveLabelSize.width, inactiveLabelSize.height)];
    _inactiveLabel.textAlignment = NSTextAlignmentCenter;
    _inactiveLabel.textColor = [UIColor whiteColor];
    _inactiveLabel.font = [BLFontDefinition normalFont:18.0f];
    _inactiveLabel.numberOfLines = 1;
    _inactiveLabel.text = inactiveText;
    _inactiveLabel.userInteractionEnabled = NO;
    [_inactiveBackground addSubview:_inactiveLabel];
    
    _nob = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.height, self.frame.size.height)];
    _nob.image = [UIImage imageNamed:@"logo.png"];
    _nob.userInteractionEnabled = NO;
    [self addSubview:_nob];
    
    _maxDelta = self.frame.size.width - _nob.frame.size.width;
    self.on = NO;
}

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

- (void)layoutSubviews {
    [super layoutSubviews];
}


#pragma mark - Handle touching
- (BOOL)beginTrackingWithTouch:(UITouch *)touch withEvent:(UIEvent *)event {
    _previousTouchPoint = [touch locationInView:self];
    _startActiveBg = _activeBackground.center;
    _startInactiveBg = _inactiveBackground.center;
    _startKnobCenter = _nob.center;
    BOOL b = CGRectContainsPoint(_nob.frame, _previousTouchPoint);
    return b;
}

- (BOOL)continueTrackingWithTouch:(UITouch *)touch withEvent:(UIEvent *)event {
    CGPoint touchPoint = [touch locationInView:self];
    CGFloat delta = MIN(touchPoint.x - _previousTouchPoint.x, _maxDelta);
    
    CGPoint knobCenter = _nob.center;
    knobCenter.x = _startKnobCenter.x + delta;
    _nob.center = knobCenter;
    CGPoint activeBackgroundCenter = _activeBackground.center;
    activeBackgroundCenter.x = _startActiveBg.x + delta;
    _activeBackground.center = activeBackgroundCenter;
    CGPoint inactiveBackgroundCenter = _inactiveBackground.center;
    inactiveBackgroundCenter.x = _startInactiveBg.x + delta;
    _inactiveBackground.center = inactiveBackgroundCenter;
    return YES;
}

- (void)endTrackingWithTouch:(UITouch *)touch withEvent:(UIEvent *)event {
    CGPoint touchPoint = [touch locationInView:self];
    CGFloat delta = touchPoint.x - _previousTouchPoint.x;
    NSLog(@"ABS delta: %f", fabs(delta));
    if (fabs(delta) > (_maxDelta * 0.5f)) {
        self.on ? [self showOff:YES] : [self showOn:YES];
        [self sendActionsForControlEvents:UIControlEventValueChanged];
    } else {
        self.on ? [self showOn:YES] : [self showOff:YES];
    }
    
}

- (void)showOn:(BOOL)animated {
    if (animated) {
        [UIView animateWithDuration:0.2f animations:^{
            CGPoint knobCenter = CGPointMake(self.frame.size.width - _nob.frame.size.width * 0.5f, _nob.center.y);
            _nob.center = knobCenter;
            CGPoint activeBgCenter = CGPointMake(self.frame.size.width * 0.5f, _activeBackground.center.y);
            _activeBackground.center = activeBgCenter;
            CGPoint inactiveBgCenter = CGPointMake(self.frame.size.width * 1.5f - _nob.frame.size.width, _inactiveBackground.center.y);
            _inactiveBackground.center = inactiveBgCenter;
        }];
    } else {
        CGPoint knobCenter = CGPointMake(self.frame.size.width - _nob.frame.size.width * 0.5f, _nob.center.y);
        _nob.center = knobCenter;
        CGPoint activeBgCenter = CGPointMake(self.frame.size.width * 0.5f, _activeBackground.center.y);
        _activeBackground.center = activeBgCenter;
        CGPoint inactiveBgCenter = CGPointMake(self.frame.size.width * 1.5f - _nob.frame.size.width, _inactiveBackground.center.y);
        _inactiveBackground.center = inactiveBgCenter;
    }
    self.on = YES;
}

- (void)showOff:(BOOL)animated {
    if (animated) {
        [UIView animateWithDuration:0.2f animations:^{
            CGPoint knobCenter = CGPointMake(_nob.frame.size.width * 0.5f, _nob.center.y);
            _nob.center = knobCenter;
            CGPoint activeBgCenter = CGPointMake(_nob.frame.size.width - self.frame.size.width * 0.5f, _activeBackground.center.y);
            _activeBackground.center = activeBgCenter;
            CGPoint inactiveBgCenter = CGPointMake(self.frame.size.width * 0.5f, _inactiveBackground.center.y);
            _inactiveBackground.center = inactiveBgCenter;
        }];
    } else {
        CGPoint knobCenter = CGPointMake(_nob.frame.size.width * 0.5f, _nob.center.y);
        _nob.center = knobCenter;
        CGPoint activeBgCenter = CGPointMake(_nob.frame.size.width - self.frame.size.width * 0.5f, _activeBackground.center.y);
        _activeBackground.center = activeBgCenter;
        CGPoint inactiveBgCenter = CGPointMake(self.frame.size.width * 0.5f, _inactiveBackground.center.y);
        _inactiveBackground.center = inactiveBgCenter;
    }
    self.on = NO;
}

@end
