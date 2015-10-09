//
//  BLMatchedViewController.m
//  biu
//
//  Created by Tony Wu on 7/3/15.
//  Copyright (c) 2015 BiuLove. All rights reserved.
//

#import "BLMatchedViewController.h"
#import "BLWaitingResponseViewController.h"
#import "BLMessagesViewController.h"
#import "BLBlurView.h"
#import "Masonry.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import <TSMessages/TSMessage.h>
#import <MBProgressHUD/MBProgressHUD.h>

@interface BLMatchedViewController () <BLMessagesViewControllerDelegate, BLWaitingResponseViewCongtrollerDelegate, BLMatchNotificationDelegate, MBProgressHUDDelegate> {
    MBProgressHUD *_HUD;
}

@property (strong, nonatomic) BLBlurView *blurUserInfoView;
@property (strong, nonatomic) UIImageView *matchedUserImageView;
@property (strong, nonatomic) UIButton *btnMessage;
@property (strong, nonatomic) UIButton *btnClose;
@property (strong, nonatomic) UIButton *btnMatchedUserInfo;
@property (strong, nonatomic) UIView *matchedUserInfo;
@property (strong, nonatomic) User *currentUser;
@property (assign, nonatomic) NSInteger coupleState;
@property (assign, nonatomic) NSInteger coupleResult;
@property (strong, nonatomic) UIButton *btnReport;//举报

@end

@implementation BLMatchedViewController

#pragma mark -
#pragma mark Life Cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.isMatchedUserAccepted = NO;
    
    [self.view addSubview:self.matchedUserImageView];
    [self.view addSubview:self.btnClose];
    [self.view addSubview:self.btnMessage];
//    [self.view addSubview:self.btnMatchedUserInfo];
    [self.view addSubview:self.blurUserInfoView];
    [self.view addSubview:self.btnReport];

    [self layoutSubViews];
    
    [self addHUD];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self fetchUserMatchedInfo];
//    [self.matchedUserImageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@rect/avatar/%@", [BLHTTPClient blBaseURL], self.matchedUser.userId]]
//                                 placeholderImage:nil
//                                          options:SDWebImageHandleCookies | SDWebImageProgressiveDownload | SDWebImageCacheMemoryOnly];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(matchedUserAccepted) name:@"matched user accepted" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(matchedUserRejected) name:@"matched user rejected" object:nil];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    BLAppDelegate *blAppDelegate = (BLAppDelegate *)[[UIApplication sharedApplication] delegate];
    blAppDelegate.notificationDelegate = self;
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    BLAppDelegate *blAppDelegate = (BLAppDelegate *)[[UIApplication sharedApplication] delegate];
    blAppDelegate.notificationDelegate = nil;
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:YES];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"matched user accepted" object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"matched user rejected" object:nil];
}

#pragma mark Layouts
- (void)layoutSubViews {
    [self.matchedUserImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.matchedUserImageView.superview);
    }];
    
//    [self.btnMatchedUserInfo mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.equalTo(self.btnMatchedUserInfo.superview).with.offset([BLGenernalDefinition resolutionForDevices:31.2f]);
//        make.right.equalTo(self.btnMatchedUserInfo.superview).with.offset([BLGenernalDefinition resolutionForDevices:-20.8f]);
//        make.width.height.equalTo([NSNumber numberWithDouble:[BLGenernalDefinition resolutionForDevices:45.3f]]);
//    }];
    
    [self.btnClose mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.btnClose.superview).with.offset([BLGenernalDefinition resolutionForDevices:60.0f]);
        make.bottom.equalTo(self.btnClose.superview).with.offset([BLGenernalDefinition resolutionForDevices:-62.0f]);
        make.width.height.equalTo([NSNumber numberWithDouble:[BLGenernalDefinition resolutionForDevices:88.0f]]);
    }];
    
    [self.btnMessage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.btnMessage.superview).with.offset([BLGenernalDefinition resolutionForDevices:-60.0f]);
        make.bottom.equalTo(self.btnMessage.superview).with.offset([BLGenernalDefinition resolutionForDevices:-62.0f]);
        make.width.height.equalTo([NSNumber numberWithDouble:[BLGenernalDefinition resolutionForDevices:88.0f]]);
    }];
    
    [self.btnReport mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.btnReport.superview).with.offset([BLGenernalDefinition resolutionForDevices:20.8f]);
        make.right.equalTo(self.btnReport.superview).with.offset([BLGenernalDefinition resolutionForDevices:-20.8f]);
        make.width.height.equalTo([NSNumber numberWithDouble:[BLGenernalDefinition resolutionForDevices:46.0f]]);
    }];

}

#pragma mark -
#pragma mark Public methods
- (void)matchedUserAccepted {
    self.isMatchedUserAccepted = YES;
    [TSMessage showNotificationInViewController:self
                                          title:NSLocalizedString(@"were accepted title", nil)
                                       subtitle:NSLocalizedString(@"were accepted subtitle", nil)
                                           type:TSMessageNotificationTypeMessage
                                       duration:TSMessageNotificationDurationEndless canBeDismissedByUser:YES];
}

- (void)matchedUserRejected {
    [TSMessage dismissActiveNotification];
    [TSMessage showNotificationInViewController:self
                                          title:NSLocalizedString(@"were rejected title", nil)
                                       subtitle:NSLocalizedString(@"were rejected subtitle", nil)
                                           type:TSMessageNotificationTypeMessage
                                       duration:TSMessageNotificationDurationEndless canBeDismissedByUser:YES];
    self.btnMessage.enabled = NO;
}

- (void)matchedUserTimeout {
    if ([self.delegate respondsToSelector:@selector(didRejectedMatchedUser)]) {
        [self.delegate didRejectedMatchedUser];
    }
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark -
#pragma mark Actions
- (void)startCommunication:(id)sender {
    [_HUD show:YES];
    [[BLHTTPClient sharedBLHTTPClient] match:self.currentUser event:BLMatchEventAccept distance:nil matchedUser:self.matchedUser success:^(NSURLSessionDataTask *task, id responseObject) {
        [_HUD hide:YES];
        NSLog(@"Accepted matched user...");
        if (self.isMatchedUserAccepted) {
            NSLog(@"Go to message view controller");
            BLMessagesViewController *messageViewController = [[BLMessagesViewController alloc] init];
            messageViewController.delegate = self;
            messageViewController.sender = self.currentUser;
            messageViewController.receiver = self.matchedUser;
            [self.navigationController pushViewController:messageViewController animated:YES];
        } else {
            BLWaitingResponseViewController *waitingViewController = [[BLWaitingResponseViewController alloc]initWithNibName:nil bundle:nil];
//            waitingViewController.matchedUser = self.matchedUser;
            waitingViewController.delegate = self;
            [self.navigationController pushViewController: waitingViewController animated:YES];
        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        [_HUD hide:YES];
        NSLog(@"start communication failed, error: %@", error);
        UIAlertView *av = [[UIAlertView alloc] initWithTitle:nil message:error.localizedDescription delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil];
        [av show];
    }];
}

- (void)showMatchedUserInfo:(id)sender {
    
}

- (void)close:(id)sender {
    [_HUD show:YES];
    [[BLHTTPClient sharedBLHTTPClient] match:self.currentUser event:BLMatchEventReject distance:nil matchedUser:self.matchedUser success:^(NSURLSessionDataTask *task, id responseObject) {
        NSLog(@"Rejected matched user.");
        [self.navigationController popViewControllerAnimated:YES];
        [_HUD hide:YES];
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        NSLog(@"Rejected matched user failed. error: %@", error);
        [_HUD hide:YES];
    }];
}

- (void)reportClick:(id)sender {
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"是否确定举报该人?" message:nil delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"举报", nil];
    [alert show];
}

#pragma mark - Delegates
#pragma mark BLMessageViewController delegate
- (void)didDismissBLMessagesViewController:(BLMessagesViewController *)vc {
    [self.delegate didCloseConversation];
//    [[BLHTTPClient sharedBLHTTPClient] match:self.currentUser event:BLMatchEventClose distance:nil matchedUser:self.matchedUser success:^(NSURLSessionDataTask *task, id responseObject) {
//        NSLog(@"Stop conversation user successed.");
//        [self.delegate didCloseConversation];
//    } failure:^(NSURLSessionDataTask *task, NSError *error) {
//        NSLog(@"Stop conversation faield.");
//    }];
}

- (void)didCloseConversation {
    [self.delegate didCloseConversation];
//    [[BLHTTPClient sharedBLHTTPClient] match:self.currentUser event:BLMatchEventClose distance:nil matchedUser:self.matchedUser success:^(NSURLSessionDataTask *task, id responseObject) {
//        NSLog(@"Stop conversation user successed.");
//        [self.delegate didCloseConversation];
//    } failure:^(NSURLSessionDataTask *task, NSError *error) {
//        NSLog(@"Stop conversation faield.");
//    }];
}

- (void)didRejectMatchedUser {
    if ([self.delegate respondsToSelector:@selector(didRejectedMatchedUser)]) {
        [self.delegate didRejectedMatchedUser];
    }
    [self.navigationController popToRootViewControllerAnimated:YES];
}

#pragma mark BLMatchNotification delegates
- (void)receiveAcceptedNotification:(User *)matchedUser {
    self.isMatchedUserAccepted = YES;
    [TSMessage showNotificationInViewController:self
                                          title:NSLocalizedString(@"were accepted title", nil)
                                       subtitle:NSLocalizedString(@"were accepted subtitle", nil)
                                           type:TSMessageNotificationTypeMessage
                                       duration:TSMessageNotificationDurationEndless canBeDismissedByUser:YES];
}

- (void)receiveRejectedNotification {
    [TSMessage showNotificationInViewController:self
                                          title:NSLocalizedString(@"were rejected title", nil)
                                       subtitle:NSLocalizedString(@"were rejected subtitle", nil)
                                           type:TSMessageNotificationTypeMessage
                                       duration:TSMessageNotificationDurationEndless canBeDismissedByUser:YES];
    self.btnMessage.enabled = NO;
}

#pragma mark - Private methods
- (void)fetchUserMatchedInfo {

    [[BLHTTPClient sharedBLHTTPClient] getMatchInfo:self.currentUser success:^(NSURLSessionDataTask *task, id responseObject) {
        [self.currentUser updateState:[[[responseObject objectForKey:@"user"] objectForKey:@"state"] integerValue]];
        self.coupleState = [[responseObject objectForKey:@"state"] integerValue];
        self.coupleResult = [[responseObject objectForKey:@"result"] integerValue];
        self.matchedUser = [[User alloc] initWithDictionary:[responseObject objectForKey:@"matched_user"]];
        SDWebImageManager *manager = [SDWebImageManager sharedManager];
        if ((self.matchedUser.avatar_url == nil) || ([self.matchedUser.avatar_large_url isKindOfClass:[NSNull class]])) {
            
            self.matchedUserImageView.image = [UIImage imageNamed:@"Launch.png"];
        } else {
            [manager downloadImageWithURL:[NSURL URLWithString:self.matchedUser.avatar_large_url]
                                  options:SDWebImageHandleCookies | SDWebImageProgressiveDownload | SDWebImageCacheMemoryOnly
                                 progress:^(NSInteger receivedSize, NSInteger expectedSize) {
                                     // progression tracking code
                                     [_HUD show:YES];
                                 }
                                completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, BOOL finished, NSURL *imageURL) {
                                    [_HUD hide:YES];
                                    if (image) {
                                        // do something with image
                                        self.matchedUserImageView.image = image;
                                    }
                                }];
        }
        [self reloadViewController];
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        NSLog(@"Get match info failed, error: %@.", error.localizedDescription);
    }];
}

- (void)reloadViewController {
    switch (self.coupleState) {
        case BLCoupleStateStart:
            if (self.matchedUser.state == BLMatchStateWaiting) {
                self.isMatchedUserAccepted = YES;
                [TSMessage showNotificationInViewController:self
                                                      title:NSLocalizedString(@"were accepted title", nil)
                                                   subtitle:NSLocalizedString(@"were accepted subtitle", nil)
                                                       type:TSMessageNotificationTypeMessage
                                                   duration:TSMessageNotificationDurationEndless canBeDismissedByUser:YES];
            }
            break;
        case BLCoupleStateCommunication:
        {
            BLMessagesViewController *messageViewController = [[BLMessagesViewController alloc] init];
            messageViewController.delegate = self;
            messageViewController.sender = self.currentUser;
            messageViewController.receiver = self.matchedUser;
            [self.navigationController pushViewController:messageViewController animated:YES];
            break;
        }
        case BLCoupleStateFinish:
        {
            if (self.coupleResult == BLCoupleResultReject) {
                [self.navigationController popToRootViewControllerAnimated:YES];
            } else if (self.coupleResult == BLCoupleResultBeenRejected) {
                [TSMessage showNotificationInViewController:self
                                                      title:NSLocalizedString(@"were rejected title", nil)
                                                   subtitle:NSLocalizedString(@"were rejected subtitle", nil)
                                                       type:TSMessageNotificationTypeMessage
                                                   duration:TSMessageNotificationDurationEndless canBeDismissedByUser:YES];
                self.btnMessage.enabled = NO;
            }
            break;
        }
        default:
            break;
    }
}

#pragma mark -
#pragma mark Getter
- (UIImageView *)matchedUserImageView {
    if (!_matchedUserImageView) {
        _matchedUserImageView = [[UIImageView alloc] init];
        _matchedUserImageView.contentMode = UIViewContentModeScaleAspectFill;
    }
    return _matchedUserImageView;
}

- (UIButton *)btnMessage {
    if (!_btnMessage) {
        _btnMessage = [[UIButton alloc] init];
        [_btnMessage setImage:[UIImage imageNamed:@"matched_message_icon.png"] forState:UIControlStateNormal];
        [_btnMessage addTarget:self action:@selector(startCommunication:) forControlEvents:UIControlEventTouchUpInside];
        _btnMessage.alpha = 0.8f;
    }
    return _btnMessage;
}

- (UIButton *)btnClose {
    if (!_btnClose) {
        _btnClose = [[UIButton alloc] init];
        [_btnClose setImage:[UIImage imageNamed:@"matched_close_icon.png"] forState:UIControlStateNormal];
        [_btnClose addTarget:self action:@selector(close:) forControlEvents:UIControlEventTouchUpInside];
        _btnClose.alpha = 0.8f;
    }
    return _btnClose;
}

- (UIButton *)btnReport {
    if (!_btnReport) {
        _btnReport = [[UIButton alloc] init];
        _btnReport.backgroundColor = [UIColor colorWithRed:213.0f / 255.0f green:213.0f / 255.0f blue:213.0f / 255.0f alpha:0.8f];
        [_btnReport setTitle:@"举报" forState:UIControlStateNormal];
        [_btnReport setTintColor:[UIColor whiteColor]];
        _btnReport.titleLabel.font = [UIFont systemFontOfSize:[BLGenernalDefinition resolutionForDevices:11.0f]];
        _btnReport.layer.cornerRadius = [BLGenernalDefinition resolutionForDevices:46.0f]/2;
        _btnReport.layer.masksToBounds = YES;
        _btnReport.layer.borderWidth = 0.5;
        [_btnReport.layer setBorderColor:([UIColor whiteColor].CGColor)];
        [_btnReport addTarget:self action:@selector(reportClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _btnReport;
}

- (UIButton *)btnMatchedUserInfo {
    if (!_btnMatchedUserInfo) {
        _btnMatchedUserInfo = [[UIButton alloc] init];
        [_btnMatchedUserInfo setImage:[UIImage imageNamed:@"menu_icon.png"] forState:UIControlStateNormal];
        [_btnMatchedUserInfo addTarget:self action:@selector(showMatchedUserInfo:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _btnMatchedUserInfo;
}

- (BLBlurView *)blurUserInfoView {
    if (!_blurUserInfoView) {
        _blurUserInfoView = [[BLBlurView alloc] initWithFrame:CGRectMake(0, -150.0f, self.view.bounds.size.width, 150.0f)];
        _blurUserInfoView.blurStyle = BLBlurStyleDark;
    }
    return _blurUserInfoView;
}

- (User *)currentUser {
    if (!_currentUser) {
        _currentUser = [[User alloc] initWithFromUserDefault];
    }
    return _currentUser;
}

- (void)addHUD {
    _HUD = [[MBProgressHUD alloc] initWithView:self.view];
    _HUD.labelText = @"loading";
    _HUD.delegate = self;
    [self.view addSubview:_HUD];
}


#pragma mark UIAlertView Delegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 1) {
        [self close:_btnClose];
    }
}
@end
