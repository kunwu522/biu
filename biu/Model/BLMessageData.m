//
//  BLMessageData.m
//  biu
//
//  Created by Tony Wu on 7/16/15.
//  Copyright (c) 2015 BiuLove. All rights reserved.
//

#import "BLMessageData.h"

@implementation BLMessageData

- (id)init {
    self = [super init];
    if (self) {
        self.messages = [NSMutableArray new];
        JSQMessagesBubbleImageFactory *bubbleFactory = [[JSQMessagesBubbleImageFactory alloc] init];
        self.outgoingBubbleImageData = [bubbleFactory outgoingMessagesBubbleImageWithColor:[UIColor colorWithRed:190.0 / 255.0f green:201.0f / 255.0f blue:210.0f / 255.0f alpha:1.0f]];
        self.incomingBubbleImageData = [bubbleFactory incomingMessagesBubbleImageWithColor:[UIColor whiteColor]];
    }
    return self;
}

- (void)addPhotoMediaMessage:(UIImage *)image sender:(User *)sender {
    JSQPhotoMediaItem *photoItem = [[JSQPhotoMediaItem alloc] initWithImage:image];
    JSQMessage *photoMessage = [JSQMessage messageWithSenderId:[NSString stringWithFormat:@"%@", sender.userId]
                                                   displayName:sender.username
                                                         media:photoItem];
    [self.messages addObject:photoMessage];
}

@end
