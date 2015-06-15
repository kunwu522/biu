//
//  AppDelegate.h
//  biu
//
//  Created by Tony Wu on 5/5/15.
//  Copyright (c) 2015 BiuLove. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BLMenuViewController.h"
#import "KeychainItemWrapper.h"
#import "User.h"

@class KeychainItemWrapper;

@interface BLAppDeleate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (strong, nonatomic) User *currentUser;

@property (strong, nonatomic) UINavigationController *welNavController;
@property (strong, nonatomic) UINavigationController *fillingInfoNavController;
@property (nonatomic, retain) BLMenuViewController *menuViewController;

@property (nonatomic, retain) KeychainItemWrapper *passwordItem;

@end
