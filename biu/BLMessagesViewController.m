//
//  BLMessagesViewController.m
//  biu
//
//  Created by Tony Wu on 7/15/15.
//  Copyright (c) 2015 BiuLove. All rights reserved.
//

#import "BLMessagesViewController.h"
#import "Masonry.h"
#import "BLMAMapViewController.h"

@interface BLMessagesViewController () <BLMessageDelegate, UIAlertViewDelegate, BLMatchNotificationDelegate>

@property (strong, nonatomic) UIButton *btnBack;
@property (strong, nonatomic) UIButton *btnMap;
@property (strong, nonatomic) User *currentUser;
@property (assign, nonatomic) NSInteger coupleState;
@property (assign, nonatomic) NSInteger coupleResult;

@end

@implementation BLMessagesViewController

#pragma mark -
#pragma mark View life cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = self.receiver.username;
    self.senderId = [NSString stringWithFormat:@"%@", self.sender.userId];
    self.senderDisplayName = self.sender.username;
    self.showLoadEarlierMessagesHeader = NO;
    self.navigationController.toolbarHidden = YES;
    
    self.collectionView.backgroundColor = [UIColor colorWithRed:232.0f / 255.0f green:233.0f / 255.0f blue:234.0f / 255.0f alpha:1.0f];
    self.collectionView.collectionViewLayout.incomingAvatarViewSize = CGSizeZero;
    self.collectionView.collectionViewLayout.outgoingAvatarViewSize = CGSizeZero;
    self.collectionView.collectionViewLayout.messageBubbleFont = [BLFontDefinition lightFont:18.0f];
    self.automaticallyScrollsToMostRecentMessage = YES;
    self.topContentAdditionalInset = [BLGenernalDefinition resolutionForDevices:80.0f];
    self.inputToolbar.contentView.leftBarButtonItem = nil;
    
    // Reset textView frame
    [self blAppDelegate].messageDelegate = self;
    [self.view addSubview:self.btnBack];
    [self.view addSubview:self.btnMap];
    self.messageData = [[BLMessageData alloc] init];
    [self loadLayouts];
    
    self.coupleState = -1;
    self.coupleResult = -1;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(receiveCloseNotification) name:@"close conversation" object:nil];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    if (self.currentUser.phone) {
        if ([[self blAppDelegate] connect]) {
            NSLog(@"Connecting to server...");
        } else {
            NSLog(@"Connection failed.");
        }
    }
    self.collectionView.collectionViewLayout.springinessEnabled = YES;
    [self blAppDelegate].notificationDelegate = self;
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self blAppDelegate].notificationDelegate = nil;
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"close conversation" object:nil];
}

#pragma mark Layouts
- (void)loadLayouts {
    [self.btnMap mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.btnMap.superview).with.offset([BLGenernalDefinition resolutionForDevices:31.2f]);
        make.right.equalTo(self.btnMap.superview).with.offset([BLGenernalDefinition resolutionForDevices:-20.8f]);
        make.width.height.equalTo([NSNumber numberWithDouble:[BLGenernalDefinition resolutionForDevices:45.3]]);
    }];
    
    [self.btnBack mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.btnBack.superview).with.offset([BLGenernalDefinition resolutionForDevices:31.2f]);
        make.left.equalTo(self.btnBack.superview).with.offset([BLGenernalDefinition resolutionForDevices:20.8f]);
        make.width.height.equalTo([NSNumber numberWithDouble:[BLGenernalDefinition resolutionForDevices:45.3]]);
    }];
}


#pragma mark - Actions
- (void)back:(id)sender {
    UIAlertView *av = [[UIAlertView alloc] initWithTitle:nil
                                                 message:NSLocalizedString(@"Chat is instance! No record if you close the page!!", nil)
                                                delegate:self
                                       cancelButtonTitle:NSLocalizedString(@"Cancel", nil)
                                       otherButtonTitles:@"Ok", nil];
    av.tag = 0;
    [av show];
}

- (void)showMap:(id)sender {
    BLMAMapViewController *maMapVC = [[BLMAMapViewController alloc] init];
    [self.navigationController pushViewController:maMapVC animated:YES];
}

#pragma mark - JSQMessagesViewController method overrides
- (void)didPressSendButton:(UIButton *)button
           withMessageText:(NSString *)text
                  senderId:(NSString *)senderId
         senderDisplayName:(NSString *)senderDisplayName
                      date:(NSDate *)date {
    [JSQSystemSoundPlayer jsq_playMessageSentSound];
    JSQMessage *message = [[JSQMessage alloc] initWithSenderId:senderId senderDisplayName:senderDisplayName date:date text:text];
    
    if (text.length > 0) {
        NSXMLElement *body = [NSXMLElement elementWithName:@"body"];
        [body setStringValue:text];
        NSXMLElement *message = [NSXMLElement elementWithName:@"message"];
        [message addAttributeWithName:@"type" stringValue:@"chat"];
#if TARGET_IPHONE_SIMULATOR
        [message addAttributeWithName:@"to" stringValue:[NSString stringWithFormat:@"%@@localhost", self.receiver.phone]];
#else
        if (self.receiver.phone) {
            [message addAttributeWithName:@"to" stringValue:[NSString stringWithFormat:@"%@@biulove.com", self.receiver.phone]];
        } else if (self.receiver.open_id) {
            [message addAttributeWithName:@"to" stringValue:[NSString stringWithFormat:@"%@@biulove.com", self.receiver.open_id]];
        } else {
            NSLog(@"There is something error. no phone and openId");
            return;
        }
#endif
        [message addChild:body];
        
        [[self blAppDelegate].xmppStream sendElement:message];
    }
    
    [self.messageData.messages addObject:message];
    [self finishSendingMessageAnimated:YES];
}

#pragma mark - Delegates
#pragma mark BLMessageDelegate
- (void)newMessageReceived:(NSDictionary *)message {
    self.showTypingIndicator = !self.showTypingIndicator;
    [self scrollToBottomAnimated:YES];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        JSQMessage *newMessage = [JSQMessage messageWithSenderId:[NSString stringWithFormat:@"%@", self.receiver.userId]
                                                     displayName:self.receiver.username
                                                            text:[message objectForKey:@"msg"]];
        
        [JSQSystemSoundPlayer jsq_playMessageReceivedSound];
        [self.messageData.messages addObject:newMessage];
        [self finishReceivingMessageAnimated:YES];
    });
    
}

#pragma mark JSQMessage CollectionView DataSource
- (id<JSQMessageData>)collectionView:(JSQMessagesCollectionView *)collectionView messageDataForItemAtIndexPath:(NSIndexPath *)indexPath {
    return [self.messageData.messages objectAtIndex:indexPath.item];
}

- (id<JSQMessageBubbleImageDataSource>)collectionView:(JSQMessagesCollectionView *)collectionView
             messageBubbleImageDataForItemAtIndexPath:(NSIndexPath *)indexPath {
    JSQMessage *message = [self.messageData.messages objectAtIndex:indexPath.item];
    if ([message.senderId isEqualToString:self.senderId]) {
        return self.messageData.outgoingBubbleImageData;
    }
    return self.messageData.incomingBubbleImageData;
}

- (id<JSQMessageAvatarImageDataSource>)collectionView:(JSQMessagesCollectionView *)collectionView
                    avatarImageDataForItemAtIndexPath:(NSIndexPath *)indexPath {
    return nil;
}

- (NSAttributedString *)collectionView:(JSQMessagesCollectionView *)collectionView attributedTextForCellTopLabelAtIndexPath:(NSIndexPath *)indexPath {
//    if (indexPath.item % 3 == 0) {
//        JSQMessage *message = [self.messageData.messages objectAtIndex:indexPath.item];
//        return [[JSQMessagesTimestampFormatter sharedFormatter] attributedTimestampForDate:message.date];
//    }

//    if (indexPath.item == 0) {
//        NSString *text = NSLocalizedString(@"You've just started your lovestory", nil);
//        UIFont *placeholderTextFont = [BLFontDefinition normalFont:12.0f];
//        UIColor *placeholderTextColor = [UIColor whiteColor];
//        
//        // dictionary of attributes, font, paragraphstyle, and color
//        NSDictionary *attrs = @{NSFontAttributeName : placeholderTextFont,
//                     NSForegroundColorAttributeName : placeholderTextColor};
//        NSAttributedString *attributedString = [[NSAttributedString alloc] initWithString:text attributes:attrs];
//        return attributedString;
//    }
    return nil;
}

- (NSAttributedString *)collectionView:(JSQMessagesCollectionView *)collectionView attributedTextForCellBottomLabelAtIndexPath:(NSIndexPath *)indexPath {
    JSQMessage *message = [self.messageData.messages objectAtIndex:indexPath.item];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"HH:mm"];
    NSString *time = [formatter stringFromDate:message.date];
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    if (message.senderId == self.senderId) {
        paragraphStyle.alignment = NSTextAlignmentRight;
    } else {
        paragraphStyle.alignment = NSTextAlignmentLeft;
    }
    NSDictionary *attributes = @{NSFontAttributeName : [BLFontDefinition lightFont:12.0f],
                       NSParagraphStyleAttributeName : paragraphStyle,
                      NSForegroundColorAttributeName : [UIColor lightGrayColor]};
    return [[NSAttributedString alloc] initWithString:time attributes:attributes];
}

- (NSAttributedString *)collectionView:(JSQMessagesCollectionView *)collectionView attributedTextForMessageBubbleTopLabelAtIndexPath:(NSIndexPath *)indexPath {
    JSQMessage *message = [self.messageData.messages objectAtIndex:indexPath.item];
    
    if ([message.senderId isEqualToString:self.senderId]) {
        return nil;
    }
    
    if (indexPath.item - 1 > 0) {
        JSQMessage *previousMessage = [self.messageData.messages objectAtIndex:indexPath.item - 1];
        if ([[previousMessage senderId] isEqualToString:message.senderId]) {
            return nil;
        }
    }
    
    return [[NSAttributedString alloc] initWithString:message.senderDisplayName];
}

#pragma mark UICollectionView DataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.messageData.messages.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    JSQMessagesCollectionViewCell *cell = (JSQMessagesCollectionViewCell *)[super collectionView:collectionView cellForItemAtIndexPath:indexPath];
    JSQMessage *msg = [self.messageData.messages objectAtIndex:indexPath.item];
    if (!msg.isMediaMessage) {
        cell.textView.textColor = [UIColor blackColor];
        cell.textView.linkTextAttributes = @{ NSForegroundColorAttributeName : cell.textView.textColor,
                                              NSUnderlineStyleAttributeName : @(NSUnderlineStyleSingle | NSUnderlinePatternSolid) };
    }
    
    if (indexPath.item == 0) {
//        cell.cellTopLabel.backgroundColor = [UIColor colorWithRed:160.0f / 255.0f green:160.0f / 255.0f blue:161.0f / 255.0f alpha:1.0f];
//        CGFloat width = cell.bounds.size.width - 120.0f;
//        cell.cellTopLabel.frame = CGRectMake((cell.bounds.size.width - width) * 0.5f, 0, width, 30.0f);
//        cell.cellTopLabel.layer.cornerRadius = 5.0f;
//        cell.cellTopLabel.clipsToBounds = YES;
        CGFloat width = cell.bounds.size.width - 120.0f;
        UILabel *lbStart = [[UILabel alloc] initWithFrame:CGRectMake((cell.bounds.size.width - width) * 0.5f, 0, width, 30.0f)];
        lbStart.text = NSLocalizedString(@"You've just started your lovestory", nil);
//        lbStart.text = @"You've just started your lovestory";
        lbStart.textAlignment = NSTextAlignmentCenter;
        lbStart.textColor = [UIColor whiteColor];
        lbStart.font = [BLFontDefinition boldFont:10.0f];
        lbStart.backgroundColor = [UIColor colorWithRed:160.0f / 255.0f green:160.0f / 255.0f blue:161.0f / 255.0f alpha:1.0f];
        lbStart.layer.cornerRadius = 5.0f;
        lbStart.clipsToBounds = YES;
        [cell addSubview:lbStart];
    }
    
    // add customized time label
//    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
//    [formatter setDateFormat:@"HH:mm"];
//    NSString *time = [formatter stringFromDate:msg.date];
//    CGSize size = [BLFontDefinition sizeForString:time font:[BLFontDefinition lightFont:10.0f]];
//    UILabel *lbTime = [[UILabel alloc] init];
//    if ([msg.senderId isEqualToString:self.senderId]) {
//        lbTime.frame = CGRectMake(cell.messageBubbleContainerView.frame.origin.x - 20.0f, cell.messageBubbleContainerView.frame.origin.y + 10.0f, size.width + 2, size.height + 2);
//    } else {
//        lbTime.frame = CGRectMake(cell.messageBubbleContainerView.frame.origin.x + cell.messageBubbleContainerView.frame.size.width + 10.0f, cell.messageBubbleContainerView.frame.origin.y + 10.0f, size.width + 2, size.height + 2);
//    }
//    lbTime.textColor = [UIColor lightGrayColor];
//    lbTime.text = time;
//    lbTime.font = [BLFontDefinition lightFont:10.0f];
//    [cell addSubview:lbTime];
    
    return cell;
}

#pragma mark JSQMessage collection view flow layout delegate
- (CGFloat)collectionView:(JSQMessagesCollectionView *)collectionView
                   layout:(JSQMessagesCollectionViewFlowLayout *)collectionViewLayout heightForCellTopLabelAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.item == 0) {
        return kJSQMessagesCollectionViewCellLabelHeightDefault + 20;
    } else {
        return 5.0f;
    }
}

- (CGFloat)collectionView:(JSQMessagesCollectionView *)collectionView
                   layout:(JSQMessagesCollectionViewFlowLayout *)collectionViewLayout heightForMessageBubbleTopLabelAtIndexPath:(NSIndexPath *)indexPath
{
    /**
     *  iOS7-style sender name labels
     */
    JSQMessage *currentMessage = [self.messageData.messages objectAtIndex:indexPath.item];
    if ([[currentMessage senderId] isEqualToString:self.senderId]) {
        return 0.0f;
    }
    
    if (indexPath.item - 1 > 0) {
        JSQMessage *previousMessage = [self.messageData.messages objectAtIndex:indexPath.item - 1];
        if ([[previousMessage senderId] isEqualToString:[currentMessage senderId]]) {
            return 0.0f;
        }
    }
    
    return kJSQMessagesCollectionViewCellLabelHeightDefault;
}

- (CGFloat)collectionView:(JSQMessagesCollectionView *)collectionView
                   layout:(JSQMessagesCollectionViewFlowLayout *)collectionViewLayout heightForCellBottomLabelAtIndexPath:(NSIndexPath *)indexPath
{
    return 20.0f;
}

#pragma mark Responding to collection view tap events

- (void)collectionView:(JSQMessagesCollectionView *)collectionView
                header:(JSQMessagesLoadEarlierHeaderView *)headerView didTapLoadEarlierMessagesButton:(UIButton *)sender {
    NSLog(@"Load earlier messages!");
}

- (void)collectionView:(JSQMessagesCollectionView *)collectionView didTapAvatarImageView:(UIImageView *)avatarImageView
           atIndexPath:(NSIndexPath *)indexPath {
    NSLog(@"Tapped avatar!");
}

- (void)collectionView:(JSQMessagesCollectionView *)collectionView didTapMessageBubbleAtIndexPath:(NSIndexPath *)indexPath {
    NSLog(@"Tapped message bubble!");
}

- (void)collectionView:(JSQMessagesCollectionView *)collectionView didTapCellAtIndexPath:(NSIndexPath *)indexPath
         touchLocation:(CGPoint)touchLocation {
    NSLog(@"Tapped cell at %@!", NSStringFromCGPoint(touchLocation));
}

#pragma mark UIAlertView Delegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    switch (alertView.tag) {
        case 0:
            if (buttonIndex == 1) {
                [[self blAppDelegate] disconnect];
                [self.delegate didDismissBLMessagesViewController:self];
            }
            break;
        case 1:
            if (buttonIndex == 0) {
                [[self blAppDelegate] disconnect];
                [self.delegate didDismissBLMessagesViewController:self];
            }
            break;
        default:
            break;
    }
}

#pragma mark MatchNotification delegate
- (void)receiveCloseNotification {
    UIAlertView *av = [[UIAlertView alloc] initWithTitle:nil message:@"对方已经退出对话" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil];
    av.tag = 1;
    [av show];
}

#pragma mark - Private methods
- (void)fetchUserMatchedInfo {
    [[BLHTTPClient sharedBLHTTPClient] getMatchInfo:self.currentUser success:^(NSURLSessionDataTask *task, id responseObject) {
        [self.currentUser updateState:[[[responseObject objectForKey:@"user"] objectForKey:@"state"] integerValue]];
        if ([[responseObject objectForKey:@"state"] integerValue]) {
            self.coupleState = [[responseObject objectForKey:@"state"] integerValue];
            self.coupleResult = [[responseObject objectForKey:@"result"] integerValue];
        }
        [self reloadViewController];
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        NSLog(@"Get match info failed, error: %@.", error.localizedDescription);
    }];
}

- (void)reloadViewController {
    if (self.coupleState == -1) {
        UIAlertView *av = [[UIAlertView alloc] initWithTitle:nil message:@"对方已经退出对话" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil];
        av.tag = 1;
        [av show];
        return;
    }
    
    switch (self.coupleState) {
        case BLCoupleStateStart:
        {
            NSLog(@"invailed state.");
            break;
        }
        case BLCoupleStateCommunication:
        {
            NSLog(@"State is communication, stay on this view");
            break;
        }
        case BLCoupleStateFinish:
        default:
            break;
    }
}

#pragma mark -
#pragma mark Getter
- (UIButton *)btnBack {
    if (!_btnBack) {
        _btnBack = [[UIButton alloc] init];
        [_btnBack setImage:[UIImage imageNamed:@"back_icon2.png"] forState:UIControlStateNormal];
        [_btnBack addTarget:self action:@selector(back:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _btnBack;
}

- (UIButton *)btnMap {
    if (!_btnMap) {
        _btnMap = [[UIButton alloc] init];
        [_btnMap setImage:[UIImage imageNamed:@"menu_icon.png"] forState:UIControlStateNormal];
        [_btnMap addTarget:self action:@selector(showMap:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _btnMap;
}

- (User *)currentUser {
    if (!_currentUser) {
        _currentUser = [[User alloc] initWithFromUserDefault];
    }
    return _currentUser;
}

- (BLAppDelegate *)blAppDelegate {
    return (BLAppDelegate *)[[UIApplication sharedApplication] delegate];
}

@end
