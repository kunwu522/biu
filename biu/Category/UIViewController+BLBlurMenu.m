//
//  UIViewController+BLBlurMenu.m
//  BLBlurMenu
//
//  Created by Tony Wu on 6/16/15.
//  Copyright (c) 2015 BiuLove. All rights reserved.
//

#import "UIViewController+BLBlurMenu.h"
#import "BLBlurMenu.h"

@implementation UIViewController (BLBlurMenu)

- (BLBlurMenu *)blurMenuViewController {
    UIViewController *parent = self.parentViewController;
    while (parent) {
        if ([parent isKindOfClass:[BLBlurMenu class]]) {
            return (BLBlurMenu *)parent;
        } else if (parent.parentViewController && parent.parentViewController != parent) {
            parent = parent.parentViewController;
        } else {
            parent = nil;
        }
    }
    return nil;
}

- (void)presentMenuViewController:(id)sender {
    [self.blurMenuViewController presentMenuViewController];
}

- (void)backToRootViewController:(id)sender {
    [self.blurMenuViewController backToRootViewController];
}


@end
