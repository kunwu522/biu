//
//  BLMenuViewViewController.h
//  biu
//
//  Created by WuTony on 5/31/15.
//  Copyright (c) 2015 BiuLove. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BLMenuViewController : UIViewController

@property (retain, nonatomic) UIViewController *rootController;
@property (retain, nonatomic) UIViewController *selectedViewController;
@property (retain, nonatomic) NSArray *viewControllers;

- (id)initWithRootViewControllr:(UIViewController *)rootController;
- (id)addViewController:(UIViewController *)viewController;

@end
