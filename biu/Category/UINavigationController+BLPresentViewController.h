//
//  UINavgationController(BLPresentViewController).h
//  biu
//
//  Created by Tony Wu on 8/25/15.
//  Copyright (c) 2015 BiuLove. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UINavigationController (BLPresentViewController)

- (void)presentViewController:(UIViewController *)viewController;
- (void)dismissViewController;

@end
