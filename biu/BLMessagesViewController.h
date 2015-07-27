//
//  BLMessagesViewController.h
//  biu
//
//  Created by Tony Wu on 7/15/15.
//  Copyright (c) 2015 BiuLove. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <JSQMessagesViewController/JSQMessages.h>
#import "BLMessageData.h"

@class BLMessagesViewController;

@protocol BLMessagesViewControllerDelegate <NSObject>

- (void)didDismissBLMessagesViewController:(BLMessagesViewController *)vc;

@end


@interface BLMessagesViewController : JSQMessagesViewController

@property (weak, nonatomic) id<BLMessagesViewControllerDelegate> delegate;

@property (strong, nonatomic) BLMessageData *messageData;

@property (strong, nonatomic) User *sender;
@property (strong, nonatomic) User *receiver;

@end