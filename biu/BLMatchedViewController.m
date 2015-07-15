//
//  BLMatchedViewController.m
//  biu
//
//  Created by Tony Wu on 7/3/15.
//  Copyright (c) 2015 BiuLove. All rights reserved.
//

#import "BLMatchedViewController.h"
#import "BLWaitingResponseViewController.h"
#import "BLBlurView.h"
#import "Masonry.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import <TSMessages/TSMessage.h>

@interface BLMatchedViewController ()

@property (strong, nonatomic) BLBlurView *blurUserInfoView;
@property (strong, nonatomic) UIImageView *matchedUserImageView;
@property (strong, nonatomic) UIButton *btnMessage;
@property (strong, nonatomic) UIButton *btnClose;
@property (strong, nonatomic) UIButton *btnMatchedUserInfo;
@property (strong, nonatomic) User *currentUser;
@property (assign, nonatomic) BOOL isMatchedUserAccepted;

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
    [self.view addSubview:self.btnMatchedUserInfo];
    [self.view addSubview:self.blurUserInfoView];
    
    [self layoutSubViews];
}

- (void)viewWillAppear:(BOOL)animated {
    [self.matchedUserImageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@rect/avatar/%@", [BLHTTPClient blBaseURL], self.matchedUser.userId]]
                                 placeholderImage:nil
                                          options:SDWebImageHandleCookies | SDWebImageProgressiveDownload | SDWebImageCacheMemoryOnly];
}

#pragma mark Layouts
- (void)layoutSubViews {
    [self.matchedUserImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.matchedUserImageView.superview);
    }];
    
    [self.btnMatchedUserInfo mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.btnMatchedUserInfo.superview).with.offset([BLGenernalDefinition resolutionForDevices:31.2f]);
        make.right.equalTo(self.btnMatchedUserInfo.superview).with.offset([BLGenernalDefinition resolutionForDevices:-20.8f]);
        make.width.height.equalTo([NSNumber numberWithDouble:[BLGenernalDefinition resolutionForDevices:45.3f]]);
    }];
    
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
}

#pragma mark -
#pragma mark Public methods
- (void)matchedUserAccepted {
    // TODO: Show notification
    self.isMatchedUserAccepted = YES;
    [TSMessage showNotificationInViewController:self
                                          title:NSLocalizedString(@"were accepted title", nil)
                                       subtitle:NSLocalizedString(@"were accepted subtitle", nil)
                                           type:TSMessageNotificationTypeMessage
                                       duration:TSMessageNotificationDurationEndless canBeDismissedByUser:YES];
}

- (void)matchedUserRejected {
    // TODO: Show notification
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
    [[BLHTTPClient sharedBLHTTPClient] match:self.currentUser event:BLMatchEventAccept distance:nil matchedUser:self.matchedUser success:^(NSURLSessionDataTask *task, id responseObject) {
        NSLog(@"Accepted matched user...");
        if (self.isMatchedUserAccepted) {
            // TODO: goto message view controller
            NSLog(@"Go to message view controller");
        } else {
            BLWaitingResponseViewController *waitingViewController = [[BLWaitingResponseViewController alloc]initWithNibName:nil bundle:nil];
            waitingViewController.matchedUser = self.matchedUser;
            [self.navigationController pushViewController: waitingViewController animated:YES];
        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        NSLog(@"start communication failed, error: %@", error);
        UIAlertView *av = [[UIAlertView alloc] initWithTitle:nil message:error.localizedDescription delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil];
        [av show];
    }];
}

- (void)showMatchedUserInfo:(id)sender {
    
}

- (void)close:(id)sender {
    [[BLHTTPClient sharedBLHTTPClient] match:self.currentUser event:BLMatchEventReject distance:nil matchedUser:self.matchedUser success:^(NSURLSessionDataTask *task, id responseObject) {
        NSLog(@"Rejected matched user.");
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        NSLog(@"Rejected matched user failed. error: %@", error);
    }];
    if ([self.delegate respondsToSelector:@selector(didRejectedMatchedUser)]) {
        [self.delegate didRejectedMatchedUser];
    }
    [self.navigationController popViewControllerAnimated:YES];
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

@end