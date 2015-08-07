//
//  BLBlurMenu.h
//  BLBlurMenu
//
//  Created by Tony Wu on 6/16/15.
//  Copyright (c) 2015 BiuLove. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BLMenuNavController : UIViewController

@property (strong, nonatomic) UIViewController *rootViewController;
@property (strong, nonatomic) UIViewController *contentViewController;
@property (strong, nonatomic) UIViewController *menuViewController;




- (id)initWithRootViewController:(UIViewController *)rootViewController
              menuViewController:(UIViewController *)menuViewController;
- (void)backToRootViewController;
- (void)closeViewToRootViewController;
- (void)presentMenuViewController;
- (void)hideMenuViewController;
- (void)setContentViewController:(UIViewController *)contentViewController animated:(BOOL)animated;

- (BOOL)displayRootViewController;
@end
