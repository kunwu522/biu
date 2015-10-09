//
//  UIViewController+BLBlurMenu.m
//  BLBlurMenu
//
//  Created by Tony Wu on 6/16/15.
//  Copyright (c) 2015 BiuLove. All rights reserved.
//

#import "UIViewController+BLMenuNavController.h"
#import "BLMenuNavController.h"

@implementation UIViewController (BLMenuNavViewController)

- (BLMenuNavController *)menuNavController {
    UIViewController *parent = self.parentViewController;
    while (parent) {
        if ([parent isKindOfClass:[BLMenuNavController class]]) {
            return (BLMenuNavController *)parent;
        } else if (parent.parentViewController && parent.parentViewController != parent) {
            parent = parent.parentViewController;
        } else {
            parent = nil;
        }
    }
    return nil;
}

- (void)presentMenuViewController:(id)sender {
    [self.menuNavController presentMenuViewController];
}

- (void)backToRootViewController:(id)sender {
    [self.menuNavController backToRootViewController];
}

- (void)closeViewToRootViewController:(id)sender {
    [self.menuNavController closeViewToRootViewController];
    
    
}


@end
