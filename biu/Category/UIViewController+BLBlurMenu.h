//
//  UIViewController+BLBlurMenu.h
//  BLBlurMenu
//
//  Created by Tony Wu on 6/16/15.
//  Copyright (c) 2015 BiuLove. All rights reserved.
//

#import <UIKit/UIKit.h>

@class BLBlurMenu;

@interface UIViewController (BLBlurMenu)

@property (strong, readonly, nonatomic) BLBlurMenu *blurMenuViewController;

- (void)presentMenuViewController:(id)sender;
- (void)backToRootViewController:(id)sender;

@end
