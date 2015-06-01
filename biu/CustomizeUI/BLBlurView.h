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
    BLBlurStypleDark = 1,
    BLBlurStypleLight = 2
};

@property (retain, nonatomic) UIView *parentView;
@property (assign, nonatomic) BLBlurStyle blurStyle;
@property (retain, nonatomic) UIImageView *backgroundImageView;

- (void)blurWithView:(UIView *)view;

@end
