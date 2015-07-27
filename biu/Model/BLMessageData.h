//
//  BLMessageData.h
//  biu
//
//  Created by Tony Wu on 7/16/15.
//  Copyright (c) 2015 BiuLove. All rights reserved.
//

#import <Foundation/Foundation.h>

#import <JSQMessagesViewController/JSQMessages.h>

@interface BLMessageData : NSObject

@property (strong, nonatomic) NSMutableArray *messages;

@property (strong, nonatomic) JSQMessagesBubbleImage *outgoingBubbleImageData;

@property (strong, nonatomic) JSQMessagesBubbleImage *incomingBubbleImageData;

- (void)addPhotoMediaMessage:(UIImage *)image sender:(User *)sender;

@end
