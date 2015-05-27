//
//  AppDelegate.h
//  biu
//
//  Created by Tony Wu on 5/5/15.
//  Copyright (c) 2015 BiuLove. All rights reserved.
//

#import <UIKit/UIKit.h>

@class KeychainItemWrapper;

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (nonatomic, retain) KeychainItemWrapper *passwordItem;
@property (nonatomic, retain) UINavigationController *masterNavController;

@end

