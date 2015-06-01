//
//  AppDelegate.m
//  biu
//
//  Created by Tony Wu on 5/5/15.
//  Copyright (c) 2015 BiuLove. All rights reserved.
//

#import "AppDelegate.h"

#import "KeychainItemWrapper.h"
#import "BLMatchViewController.h"
#import "BLProfileViewController.h"

@interface AppDelegate ()

@end

@implementation AppDelegate

@synthesize passwordItem, masterNavController, menuViewController;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
     self.passwordItem = [[KeychainItemWrapper alloc] initWithIdentifier:@"Password" accessGroup:nil];
    
    // Add Navigation
    UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:self.window.rootViewController];
    navController.navigationBarHidden = YES;
    self.window.rootViewController = navController;
    
    // Create master navigation controller
    BLMatchViewController *matchViewController = [[BLMatchViewController alloc] initWithNibName:nil bundle:nil];
    BLProfileViewController *profileViewController = [[BLProfileViewController alloc] initWithNibName:nil bundle:nil];
    
    NSArray *viewControllers = [NSArray arrayWithObjects:profileViewController, nil];
    
    // Create BL Menu view controller
    self.menuViewController = [[BLMenuViewController alloc] initWithRootViewControllr:matchViewController];
    self.menuViewController.viewControllers = viewControllers;
    
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
