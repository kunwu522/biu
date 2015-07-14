//
//  UIViewController+BLBlurMenu.h
//  BLBlurMenu
//
//  Created by Tony Wu on 6/16/15.
//  Copyright (c) 2015 BiuLove. All rights reserved.
//

#import <UIKit/UIKit.h>

@class BLMenuNavController;

@interface UIViewController (BLMenuNavController)

@property (strong, readonly, nonatomic) BLMenuNavController *menuNavController;

- (void)presentMenuViewController:(id)sender;
- (void)backToRootViewController:(id)sender;

@end
