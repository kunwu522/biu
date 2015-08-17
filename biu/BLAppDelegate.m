//
//  AppDelegate.m
//  biu
//
//  Created by Tony Wu on 5/5/15.
//  Copyright (c) 2015 BiuLove. All rights reserved.
//

/*
                        _ooOoo_
                       o8888888o
                       88" . "88
                       (| -_- |)
                       O\  =  /O
                    ____/`---'\____
                  .'  \\|     |//  `.
 
 
 佛曰:
         写字楼里写字间，写字间里程序员；
         程序人员写程序，又拿程序换酒钱。
         酒醒只在网上坐，酒醉还来网下眠；
         酒醉酒醒日复日，网上网下年复年。
         但愿老死电脑间，不愿鞠躬老板前；
         奔驰宝马贵者趣，公交自行程序员。
         别人笑我忒疯癫，我笑自己命太贱；
         不见满街漂亮妹，哪个归得程序员？
 
 */

#import "BLAppDelegate.h"
#import "BLWelcomeViewController.h"
#import "BLMatchViewController.h"
#import "BLMatchedViewController.h"
#import "BLWaitingResponseViewController.h"
#import "BLMenuNavController.h"
#import "BLMenuViewController.h"
#import "BLProfileViewController.h"
#import <TSMessages/TSMessageView.h>
#import "BLLoginViewController.h"
#import <ShareSDK/ShareSDK.h>
#import <TencentOpenAPI/TencentOAuth.h>
#import "WeiboSDK.h"
#import "WXApi.h"
#import "BLHTTPClient.h"
#import "BLMatchedViewController.h"
#import "BLMenuViewController.h"
#import "WBHttpRequest+WeiboUser.h"

#if TARGET_IPHONE_SIMULATOR
#import "UIApplication+SimulatorRemoteNotifications.h"
#endif

@interface BLAppDelegate ()

@property (assign, nonatomic) NSInteger badgeCount;

@end

@implementation BLAppDelegate 
@synthesize openid = _openid;
@synthesize access_token = _access_token;
@synthesize xmppStream;
@synthesize passwordItem, welNavController;
@synthesize username = _username;
@synthesize avatar_url = _avatar_url;
@synthesize avatar_large_url = _avatar_large_url;

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
    
    
    //    向微信注册
    [WXApi registerApp:@"wx67c27b7cc14de1aa" withDescription:kAppDescription];
    
    //    向新浪微博注册
    [WeiboSDK enableDebugMode:YES];
    [WeiboSDK registerApp:kWeiBoAppKey];
    
    return YES;
}

#pragma mark --微信
//重写AppDelegate的handleOpenURL和openURL方法
- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url {
    if ([url.scheme isEqualToString:kWeiXinAppId]) {
        return [WXApi handleOpenURL:url delegate:self];
    } else if ([url.scheme isEqualToString:kWeiBoAppKey]) {
        return [TencentOAuth HandleOpenURL:url] || [WeiboSDK handleOpenURL:url delegate:self];
    } else {
        return YES;
    }
}

- (BOOL)application:(UIApplication *)application
            openURL:(NSURL *)url
  sourceApplication:(NSString *)sourceApplication
         annotation:(id)annotation{
    if ([url.scheme isEqualToString:kWeiXinAppId]) {
        return [WXApi handleOpenURL:url delegate:self];
    } else if ([url.scheme isEqualToString:@"wb747887283"]) {
//        return [WeiboSDK handleOpenURL:url delegate:self];
        return [TencentOAuth HandleOpenURL:url] || [WeiboSDK handleOpenURL:url delegate:self];
    }else{
        return YES;
    }
}

- (void)onReq:(BaseReq *)req {
    
}

//授权后回调 WXApiDelegate
- (void)onResp:(BaseResp *)resp {

    /*
     ErrCode ERR_OK = 0(用户同意)
     ERR_AUTH_DENIED = -4（用户拒绝授权）
     ERR_USER_CANCEL = -2（用户取消）
     code    用户换取access_token的code，仅在ErrCode为0时有效
     state   第三方程序发送时用来标识其请求的唯一性的标志，由第三方程序调用sendReq时传入，由微信终端回传，state字符串长度不能超过1K
     lang    微信客户端当前语言
     country 微信用户当前国家信息
     */
    SendAuthResp *aresp = (SendAuthResp *)resp;
    if (aresp.errCode == 0) {
        NSString *code = aresp.code;

        NSString *url = [NSString stringWithFormat:@"https://api.weixin.qq.com/sns/oauth2/access_token?appid=%@&secret=%@&code=%@&grant_type=authorization_code", kWeiXinAppId, kWeiXinAppSecret, code];
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            NSURL *zoneUrl = [NSURL URLWithString:url];
            NSString *zoneStr = [NSString stringWithContentsOfURL:zoneUrl encoding:NSUTF8StringEncoding error:nil];
            NSData *data = [zoneStr dataUsingEncoding:NSUTF8StringEncoding];
            dispatch_async(dispatch_get_main_queue(), ^{
                if (data) {
                    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
                   
                    self.access_token = [dic objectForKey:@"access_token"];
                    self.openid = [dic objectForKey:@"openid"];
                    
                    if (_openid) {
                        [self getUserInfo];
                    }
                }  
            });  
        });
        
    }
}

//获取微信数据
- (void)getUserInfo {
    NSString *url =[NSString stringWithFormat:@"https://api.weixin.qq.com/sns/userinfo?access_token=%@&openid=%@",_access_token,_openid];
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSURL *zoneUrl = [NSURL URLWithString:url];
        NSString *zoneStr = [NSString stringWithContentsOfURL:zoneUrl encoding:NSUTF8StringEncoding error:nil];
        NSData *data = [zoneStr dataUsingEncoding:NSUTF8StringEncoding];
        dispatch_async(dispatch_get_main_queue(), ^{
            if (data) {
                NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
                
                self.username = [dic objectForKey:@"nickname"];
                self.avatar_url = [dic objectForKey:@"headimgurl"];
                self.avatar_large_url = self.avatar_url;
                [[NSUserDefaults standardUserDefaults] setObject:self.username forKey:@"username"];
                [[NSUserDefaults standardUserDefaults] setObject:self.avatar_url forKey:@"avatar_url"];
                //像素1242             
                if (self.openid) {
                    
                     NSDictionary *dic =[[NSDictionary alloc] initWithObjectsAndKeys:self.username, @"username",
                                         self.avatar_url, @"avatar_url",
                                         self.avatar_url, @"avatar_large_url",
                                         self.openid,@"openid" ,nil];
                    
                    [[NSNotificationCenter defaultCenter] postNotificationName:@"weixinIfo" object:dic];
                }
            }
        });
    });
}
#pragma mark --新浪微博
//https://api.weibo.com/oauth2/default.html，新浪默认授权回调页（随便写，只取后边的code值）
//获取userID和accessToken，及个人信息
- (void)didReceiveWeiboResponse:(WBBaseResponse *)response {
//应用名字: self.username = [[response.userInfo objectForKey:@"app"] objectForKey:@"name"];
//应用头像: self.avatar_url = [[response.userInfo objectForKey:@"app"] objectForKey:@"logo"];
    
    self.access_token = [response.userInfo objectForKey:@"access_token"];
    self.openid = [response.userInfo objectForKey:@"uid"];
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    //https://api.weibo.com/2/users/show.json?access_token="+accessToken+"&uid="+uid
    NSString *str = [NSString stringWithFormat:@"https://api.weibo.com/2/users/show.json?access_token=%@&uid=%@",self.access_token,self.openid];
    [manager GET:str parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"%@",responseObject);

        self.username = responseObject[@"name"];
        self.avatar_url = responseObject[@"avatar_large"];
        self.avatar_large_url = responseObject[@"avatar_hd"];
        
        NSDictionary *dic =[[NSDictionary alloc] initWithObjectsAndKeys:self.username, @"username", self.avatar_url, @"avatar_url", self.avatar_large_url, @"avatar_large_url", self.openid,@"openid" ,nil];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"weiboIfo" object:dic];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        // TODO: 加个日志
        NSLog(@"failure, error: %@.", error.localizedDescription);
    }];
    
//    avatar_hd，1024X1024像素
//    avatar_large,180X180像素
}
- (void)didReceiveWeiboRequest:(WBBaseRequest *)request{
    
}
- (void)tencentDidNotLogin:(BOOL)cancelled{
    
}
- (void)tencentDidLogin{
    
}
- (void)tencentDidNotNetWork{
    
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

#pragma mark - Public methods
- (BOOL)connect {
    [self setupStream];
    
    if (![xmppStream isDisconnected]) {
        return YES;
    }
    
    if (self.currentUser.phone == nil || self.currentUser.password == nil) {
        return NO;
    }
    
#if TARGET_IPHONE_SIMULATOR
    [xmppStream setMyJID:[XMPPJID jidWithString:[NSString stringWithFormat:@"%@@localhost", self.currentUser.phone]]];
#else
    [xmppStream setMyJID:[XMPPJID jidWithString:[NSString stringWithFormat:@"%@@biulove.com", self.currentUser.phone]]];
    [xmppStream setHostName:@"123.56.129.119"];
#endif
    
    NSError *error = nil;
    if (![xmppStream connectWithTimeout:XMPPStreamTimeoutNone error:&error]) {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Error"
                                                            message:[NSString stringWithFormat:@"Can't connect to server %@", [error localizedDescription]]
                                                           delegate:nil
                                                  cancelButtonTitle:@"Ok"
                                                  otherButtonTitles:nil];
        [alertView show];
        return NO;
    }
    
    return YES;
}

- (void)disconnect {
    [self goOffline];
    [xmppStream disconnect];
}

#pragma mark - Private methods
- (void)setupStream {
    xmppStream = [[XMPPStream alloc] init];
    [xmppStream addDelegate:self delegateQueue:dispatch_get_main_queue()];
}

- (void)goOnline {
    XMPPPresence *presence = [XMPPPresence presence];
    [[self xmppStream] sendElement:presence];
}

- (void)goOffline {
    XMPPPresence *presence = [XMPPPresence presenceWithType:@"unavailable"];
    [[self xmppStream] sendElement:presence];
}

#pragma mark - Delegates
#pragma mark XMPP Delegate
- (void)xmppStreamDidConnect:(XMPPStream *)sender {
    NSLog(@"Connection to the server successful.");
    isOpen = YES;
    NSError *error = nil;
    [self.xmppStream authenticateWithPassword:self.currentUser.password error:&error];
}

- (void)xmppStreamDidAuthenticate:(XMPPStream *)sender {
    NSLog(@"authentication successful.");
    [self goOnline];
}

- (void)xmppStream:(XMPPStream *)sender didReceiveMessage:(XMPPMessage *)message {
    NSString *body = [[message elementForName:@"body"] stringValue];
    NSString *displayName = [[message attributeForName:@"from"] stringValue];
    
    NSMutableDictionary *m = [[NSMutableDictionary alloc] init];
    [m setObject:body forKey:@"msg"];
    [m setObject:displayName forKey:@"sender"];
    
    if (self.messageDelegate) {
        [self.messageDelegate newMessageReceived:m];
    }
    
    if ([[UIApplication sharedApplication] applicationState] == UIApplicationStateActive) {
        NSLog(@"Receive new message: %@, from %@.", body, displayName);
    } else {
        // We are not active, so use a local notification instead
        UILocalNotification *localNotification = [[UILocalNotification alloc] init];
        localNotification.alertAction = @"Ok";
        localNotification.alertBody = [NSString stringWithFormat:@"From: %@\n\n%@",displayName,body];
        
        [[UIApplication sharedApplication] presentLocalNotificationNow:localNotification];
    }
}

#pragma mark Push Notification Delegate
- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
    self.deviceToken = [[[deviceToken description] stringByTrimmingCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"<>"]] stringByReplacingOccurrencesOfString:@" " withString:@""];
    NSLog(@"Got device token as %@", self.deviceToken);
    if (self.deviceToken) {
        [[NSUserDefaults standardUserDefaults] setObject:self.deviceToken   forKey:@"device_token"];
    }
    
    NSDictionary *dic = [[NSDictionary alloc] init];
    dic = [[NSUserDefaults standardUserDefaults] dictionaryRepresentation];
    User *user = [User new];
    user.userId = dic[@"user_id"];
    user.token = dic[@"device_token"];
    
    if ((user.userId) && (user.token)) {
        [[BLHTTPClient sharedBLHTTPClient] registToken:user.token user:user success:^(NSURLSessionDataTask *task, id responseObject) {
            NSLog(@"Regist device token successed.");
        } failure:^(NSURLSessionDataTask *task, NSError *error) {
            NSLog(@"Regist device token failed.");
        }];
    }
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
    NSLog(@"Receive notfication: %@. application state: %ld", userInfo, application.applicationState);
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
    } else if ([category isEqualToString:@"CONVERSATION_CLOSE"]) {
        [self receivedCloseNotification:application];
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
            NSLog(@"App's state is active...");
            if (self.notificationDelegate
                && [self.notificationDelegate respondsToSelector:@selector(receiveMatchedNotification:)]) {
                [self.notificationDelegate receiveMatchedNotification:matchedUser];
            } else {
                NSLog(@"error: notification delegate is %@", NSStringFromClass([self.notificationDelegate class]));
            }
            break;
        }
        case UIApplicationStateInactive:
            NSLog(@"App's state is inactive...");
            break;
        case UIApplicationStateBackground:
            NSLog(@"App's state is background...");
            break;
        default:
            NSLog(@"App's state is %ld", (long)application.applicationState);
            break;
    }
}

- (void)receivedAcceptedNotification:(UIApplication *)application matchedUser:(User *)matchedUser {
    switch (application.applicationState) {
        case UIApplicationStateActive:
        {
            if (self.notificationDelegate
                && [self.notificationDelegate respondsToSelector:@selector(receiveAcceptedNotification:)]) {
                [self.notificationDelegate receiveAcceptedNotification:matchedUser];
            } else {
                NSLog(@"error: notification delegate is %@", NSStringFromClass([self.notificationDelegate class]));
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
            if (self.notificationDelegate
                && [self.notificationDelegate respondsToSelector:@selector(receiveRejectedNotification)]) {
                [self.notificationDelegate receiveRejectedNotification];
            } else {
                NSLog(@"error: notification delegate is %@", NSStringFromClass([self.notificationDelegate class]));
            }
            break;
        }
        default:
            break;
    }
}

- (void)receivedCloseNotification:(UIApplication *)application {
    switch (application.applicationState) {
        case UIApplicationStateActive:
        {
            if (self.notificationDelegate
                && [self.notificationDelegate respondsToSelector:@selector(receiveCloseNotification)]) {
                [self.notificationDelegate receiveCloseNotification];
            } else {
                NSLog(@"error: notification delegate is %@", NSStringFromClass([self.notificationDelegate class]));
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
