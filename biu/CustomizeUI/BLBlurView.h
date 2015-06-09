//
//  BLBlurView.h
//  biu
//
//  Created by Tony Wu on 6/1/15.
//  Copyright (c) 2015 BiuLove. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BLBlurView : UIView

typedef NS_ENUM(NSInteger, BLBlurStyle) {
    BLBlurStyleUndefined = 0,
    BLBlurStyleDark = 1,
    BLBlurCondensedDark = 2,
    BLBlurStyleLight = 3,
    BLBlurStylePurple = 4
};

@property (retain, nonatomic) UIView *parentView;
@property (assign, nonatomic) BLBlurStyle blurStyle;
@property (retain, nonatomic) UIImageView *backgroundImageView;

- (void)blurWithView:(UIView *)view;
- (void)blurWithViewAync:(UIView *)view;

@end
