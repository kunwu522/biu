//
//  AppDelegate.h
//  biu
//
//  Created by Tony Wu on 5/5/15.
//  Copyright (c) 2015 BiuLove. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "KeychainItemWrapper.h"
#import "User.h"
#import "XMPPFramework.h"

#define IS_IPHONE_5 (fabs((double)[[UIScreen mainScreen]bounds].size.height - (double)568) < DBL_EPSILON)
#define IS_IPHONE_6 (fabs((double)[[UIScreen mainScreen]bounds].size.height - (double)667) < DBL_EPSILON)
#define IS_IPHONE_6_PLUS (fabs((double)[[UIScreen mainScreen]bounds].size.height - (double)736) < DBL_EPSILON)

@class KeychainItemWrapper;

@protocol BLMessageDelegate <NSObject>
@required
- (void)newMessageReceived:(NSDictionary *)message;

@end

@protocol BLMatchNotificationDelegate <NSObject>

@optional
- (void)receiveMatchedNotification:(User *)matchedUser;
- (void)receiveAcceptedNotification:(User *)matchedUser;
- (void)receiveRejectedNotification;
- (void)receiveCloseNotification;

@end

@interface BLAppDelegate : UIResponder <UIApplicationDelegate, XMPPStreamDelegate> {
    XMPPStream *xmppStream;
    BOOL isOpen;
}

@property (strong, nonatomic) UIWindow *window;

@property (strong, nonatomic) User *currentUser;
@property (strong, nonatomic) NSString *deviceToken;

@property (strong, nonatomic) UINavigationController *welNavController;
@property (strong, nonatomic) UIViewController *masterNavController;
@property (strong, nonatomic) KeychainItemWrapper *passwordItem;

@property (strong, nonatomic, readonly) XMPPStream *xmppStream;
@property (weak, nonatomic) id<BLMessageDelegate> messageDelegate;
@property (weak, nonatomic) id<BLMatchNotificationDelegate> notificationDelegate;

- (BOOL)connect;
- (void)disconnect;

@end


