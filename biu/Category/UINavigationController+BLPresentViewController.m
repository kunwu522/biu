//
//  UINavgationController(BLPresentViewController).m
//  biu
//
//  Created by Tony Wu on 8/25/15.
//  Copyright (c) 2015 BiuLove. All rights reserved.
//

#import "UINavigationController+BLPresentViewController.h"


@implementation UINavigationController (BLPresentViewController)

- (void)presentViewController:(UIViewController *)viewController {
    CATransition *transition = [CATransition animation];
    transition.duration = 0.2;
    transition.type = kCATransitionMoveIn;
    transition.subtype = kCATransitionFromTop;
    
    [self.view.layer addAnimation:transition forKey:kCATransition];
    [self pushViewController:viewController animated:NO];
}

- (void)dismissViewController {
    CATransition *transition = [CATransition animation];
    transition.duration = 0.2;
    transition.type = kCATransitionReveal;
    transition.subtype = kCATransitionFromBottom;
    
    [self.view.layer addAnimation:transition forKey:kCATransition];
    [self popViewControllerAnimated:NO];
}

@end
