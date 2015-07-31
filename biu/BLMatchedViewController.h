//
//  BLMatchedViewController.h
//  biu
//
//  Created by Tony Wu on 7/3/15.
//  Copyright (c) 2015 BiuLove. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol BLMatchedViewControllerDelegate <NSObject>

- (void)didRejectedMatchedUser;
- (void)didCloseConversation;

@end

@interface BLMatchedViewController : UIViewController

@property (strong, nonatomic) User *matchedUser;
@property (assign, nonatomic) BOOL isMatchedUserAccepted;
@property (weak, nonatomic) id<BLMatchedViewControllerDelegate> delegate;

- (void)matchedUserRejected;
- (void)matchedUserAccepted;
- (void)matchedUserTimeout;

@end
