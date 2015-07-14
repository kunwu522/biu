//
//  BLWaitingResponseViewController.h
//  biu
//
//  Created by Tony Wu on 7/6/15.
//  Copyright (c) 2015 BiuLove. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BLWaitingResponseViewController : UIViewController

@property (strong, nonatomic) User *matchedUser;

- (void)matchedUserRejected;
- (void)matchedUserAccepted;

@end
