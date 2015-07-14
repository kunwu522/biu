//
//  AppDelegate.m
//  biu
//
//  Created by Tony Wu on 5/5/15.
//  Copyright (c) 2015 BiuLove. All rights reserved.
//

#import "BLAppDelegate.h"
#import "BLWelcomeViewController.h"
#import "BLMatchViewController.h"
#import "BLMatchedViewController.h"
#import "BLWaitingResponseViewController.h"
#import "BLMenuNavController.h"
#import "BLMenuViewController.h"
#import "BLProfileViewController.h"
#import <TSMessages/TSMessageView.h>
#if TARGET_IPHONE_SIMULATOR
#import "UIApplication+SimulatorRemoteNotifications.h"
#endif

@interface BLAppDelegate ()

@property (assign, nonatomic) NSInteger badgeCount;

@end

@implementation BLAppDelegate

@synthesize passwordItem, welNavController;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
     self.passwordItem = [[KeychainItemWrapper alloc] initWithIdentifier:@"Password" accessGroup:nil];
    
    // Get current user
    self.currentUser = [[User alloc] initWithFromUserDefault];
    
    NSLog(@"SCREEN (%i x %i) SCALE: %i", (int)[UIScreen mainScreen].bounds.size.width, (int)[UIScreen mainScreen].bounds.size.height, (int)[UIScreen mainScreen].scale);
    
    // Add Navigation
    BLWelcomeViewController *welcomeViewController = [[BLWelcomeViewController alloc] initWithNibName:nil bundle:nil];
    self.welNavController = [[UINavigationController alloc] initWithRootViewController:welcomeViewController];
    self.welNavController.navigationBarHidden = YES;
    self.window.rootViewController = self.welNavController;
    
    // Let the device know we want to receive push notifications
    UIUserNotificationType types = UIUserNotificationTypeBadge | UIUserNotificationTypeSound | UIUserNotificationTypeAlert;
    UIUserNotificationSettings *settings = [UIUserNotificationSettings settingsForTypes:types categories:nil];
    [[UIApplication sharedApplication] registerUserNotificationSettings:settings];
    [[UIApplication sharedApplication] registerForRemoteNotifications];
    self.badgeCount = [UIApplication sharedApplication].applicationIconBadgeNumber;
    
#if TARGET_IPHONE_SIMULATOR
    [application listenForRemoteNotifications];
#endif
    
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

#pragma mark -
#pragma mark Push Notification Delegate
- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
    self.deviceToken = [[[deviceToken description] stringByTrimmingCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"<>"]] stringByReplacingOccurrencesOfString:@" " withString:@""];
    NSLog(@"Got device token as %@", self.deviceToken);
}

- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error {
    NSLog(@"Error in registration. Error: %@", error);
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo {
    NSLog(@"Receive notfication: %@.", userInfo);
    NSDictionary *aps = [userInfo objectForKey:@"aps"];
    if (!aps) {
        NSLog(@"Received notification not valided.");
        return;
    }
    NSString *category = [aps objectForKey:@"category"];
    if ([category isEqualToString:@"MATCHED"]) {
        User *matchedUser = [[User alloc] initWithDictionary:[userInfo objectForKey:@"matched_user"]];
        if (!matchedUser) {
            NSLog(@"Received notification not valided, matched user is nil.");
            return;
        }
        if (self.masterNavController && [self.masterNavController isKindOfClass:[BLMenuNavController class]]) {
            [((BLMenuNavController *)self.masterNavController) backToRootViewController];
            UINavigationController *masterViewController = (UINavigationController *)((BLMenuNavController *)self.masterNavController).rootViewController;
            if ([masterViewController.topViewController isKindOfClass:[BLMatchViewController class]]) {
                BLMatchViewController *matchViewController = (BLMatchViewController *)masterViewController.topViewController;
                [matchViewController matched:matchedUser];
            } else {
                NSLog(@"instance type error.");
            }
        } else {
            BLMatchViewController *matchViewController = [[BLMatchViewController alloc] initWithNibName:nil bundle:nil];
            BLMenuViewController *menuViewController = [[BLMenuViewController alloc] init];
            UINavigationController *masterNavViewController = [[UINavigationController alloc] initWithRootViewController:matchViewController];
            masterNavViewController.navigationBarHidden = YES;
            BLMenuNavController *menuNavController = [[BLMenuNavController alloc] initWithRootViewController:masterNavViewController
                                                                                          menuViewController:menuViewController];
            [self.window.rootViewController presentViewController:menuNavController animated:YES completion:^{
                UINavigationController *masterViewController = (UINavigationController *)((BLMenuNavController *)self.masterNavController).rootViewController;
                if ([masterViewController.topViewController isKindOfClass:[BLMatchViewController class]]) {
                    BLMatchViewController *matchViewController = (BLMatchViewController *)masterViewController.topViewController;
                    [matchViewController matched:matchedUser];
                } else {
                    NSLog(@"instance type error.");
                }
            }];
        }
    } else if ([category isEqualToString:@"MATCH_ACCEPTED"]) {
        if (self.masterNavController && [self.masterNavController isKindOfClass:[BLMenuNavController class]]) {
            [((BLMenuNavController *)self.masterNavController) backToRootViewController];
            UINavigationController *masterViewController = (UINavigationController *)((BLMenuNavController *)self.masterNavController).rootViewController;
            if ([masterViewController.visibleViewController isKindOfClass:[BLMatchedViewController class]]) {
                BLMatchedViewController *matchedViewController = (BLMatchedViewController *)masterViewController.visibleViewController;
                [matchedViewController matchedUserAccepted];
            } else if ([masterViewController.visibleViewController isKindOfClass:[BLWaitingResponseViewController class]]) {
                BLWaitingResponseViewController *waitingViewController = (BLWaitingResponseViewController *)masterViewController.visibleViewController;
                [waitingViewController matchedUserAccepted];
            } else {
                BLMatchedViewController *matchedViewController = [[BLMatchedViewController alloc] initWithNibName:nil bundle:nil];
                [masterViewController.navigationController presentViewController:matchedViewController animated:YES completion:^{
                    [matchedViewController matchedUserAccepted];
                }];
            }
        }
    } else if ([category isEqualToString:@"MATCH_REJECTED"]) {
        if (self.masterNavController && [self.masterNavController isKindOfClass:[BLMenuNavController class]]) {
            [((BLMenuNavController *)self.masterNavController) backToRootViewController];
            UINavigationController *masterViewController = (UINavigationController *)((BLMenuNavController *)self.masterNavController).rootViewController;
            if ([masterViewController.visibleViewController isKindOfClass:[BLMatchedViewController class]]) {
                BLMatchedViewController *matchedViewController = (BLMatchedViewController *)masterViewController.visibleViewController;
                [matchedViewController matchedUserRejected];
            } else if ([masterViewController.visibleViewController isKindOfClass:[BLWaitingResponseViewController class]]) {
                BLWaitingResponseViewController *waitingViewController = (BLWaitingResponseViewController *)masterViewController.visibleViewController;
                [waitingViewController matchedUserRejected];
            } else {
                BLMatchedViewController *matchedViewController = [[BLMatchedViewController alloc] initWithNibName:nil bundle:nil];
                [masterViewController.navigationController presentViewController:matchedViewController animated:YES completion:^{
                    [matchedViewController matchedUserRejected];
                }];
            }
        }
    } else {
        NSLog(@"Unsupport category push notification");
    }
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo fetchCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler {
    NSLog(@"Receive notfication: %@.", userInfo);
    NSDictionary *aps = [userInfo objectForKey:@"aps"];
    if (!aps) {
        NSLog(@"Received notification not valided.");
        return;
    }
    NSString *category = [aps objectForKey:@"category"];
    if ([category isEqualToString:@"MATCHED"]) {
        User *matchedUser = [[User alloc] initWithDictionary:[userInfo objectForKey:@"matched_user"]];
        if (!matchedUser) {
            NSLog(@"Received notification not valided, matched user is nil.");
            return;
        }
        [self receivedMatchedNotification:application matchedUser:matchedUser];
    } else if ([category isEqualToString:@"MATCH_ACCEPTED"]) {
        [self receivedAcceptedNotification:application matchedUser:nil];
    } else if ([category isEqualToString:@"MATCH_REJECTED"]) {
        [self receivedRejectedNotification:application];
    }
}

#pragma mark -
#pragma mark Create menu nav view controller
- (BLMenuNavController *)menuNavControllerWithCurrentViewController:(UIViewController *)viewController {
    BLMatchViewController *matchViewController = [[BLMatchViewController alloc] init];
    UINavigationController *masterNavController = [[UINavigationController alloc] initWithRootViewController:matchViewController];
    masterNavController.navigationBarHidden = YES;
    BLMenuViewController *menuViewCotroller = [[BLMenuViewController alloc] init];
    BLMenuNavController *menuNavController = [[BLMenuNavController alloc] initWithRootViewController:masterNavController menuViewController:menuViewCotroller];
    
    return menuNavController;
}

- (void)receivedMatchedNotification:(UIApplication *)application matchedUser:(User *)matchedUser {
    switch (application.applicationState) {
        case UIApplicationStateActive:
        {
            UIViewController *currentRootController = [self currentDisplayViewController];
            if ([currentRootController isKindOfClass:[BLMenuNavController class]]) {
                BLMenuNavController *menuNavController = (BLMenuNavController *)currentRootController;
                [menuNavController backToRootViewController];
                BLMatchViewController *matchViewController = (BLMatchViewController *)((UINavigationController *)menuNavController.rootViewController).topViewController;
                [matchViewController matched:matchedUser];
            } else {
                NSLog(@"instance type error.");
            }
            break;
        }
        case UIApplicationStateInactive:
            
            break;
        case UIApplicationStateBackground:
            
            break;
        default:
            break;
    }
}

- (void)receivedAcceptedNotification:(UIApplication *)application matchedUser:(User *)matchedUser {
    switch (application.applicationState) {
        case UIApplicationStateActive:
        {
            UIViewController *currentRootController = [self currentDisplayViewController];
            if ([currentRootController isKindOfClass:[BLMenuNavController class]]) {
                BLMenuNavController *menuNavController = (BLMenuNavController *)currentRootController;
                [menuNavController backToRootViewController];
                UIViewController *viewController = (BLMatchViewController *)((UINavigationController *)menuNavController.rootViewController).visibleViewController;
                if ([viewController isKindOfClass:[BLMatchedViewController class]]) {
                    [((BLMatchedViewController *)viewController) matchedUserAccepted];
                } else if ([viewController isKindOfClass:[BLWaitingResponseViewController class]]) {
                    [((BLWaitingResponseViewController *)viewController)matchedUserAccepted];
                } else {
                    NSLog(@"instance type error.");
                }
            } else {
                NSLog(@"instance type error.");
            }
            break;
        }
        default:
            break;
    }
}

- (void)receivedRejectedNotification:(UIApplication *)application {
    switch (application.applicationState) {
        case UIApplicationStateActive:
        {
            UIViewController *currentRootController = [self currentDisplayViewController];
            if ([currentRootController isKindOfClass:[BLMenuNavController class]]) {
                BLMenuNavController *menuNavController = (BLMenuNavController *)currentRootController;
                [menuNavController backToRootViewController];
                UIViewController *viewController = (BLMatchViewController *)((UINavigationController *)menuNavController.rootViewController).visibleViewController;
                if ([viewController isKindOfClass:[BLMatchedViewController class]]) {
                    [((BLMatchedViewController *)viewController) matchedUserRejected];
                } else if ([viewController isKindOfClass:[BLWaitingResponseViewController class]]) {
                    [((BLWaitingResponseViewController *)viewController)matchedUserRejected];
                } else {
                    NSLog(@"instance type error.");
                }
            } else {
                NSLog(@"instance type error.");
            }
            break;
        }
        default:
            break;
    }
}

- (UIViewController *)currentDisplayViewController {
    UINavigationController *navController = (UINavigationController *)self.window.rootViewController;
    return navController.visibleViewController;
}

@end
