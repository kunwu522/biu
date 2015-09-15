//
//  BLMatchViewController.m
//  biu
//
//  Created by Tony Wu on 5/27/15.
//  Copyright (c) 2015 BiuLove. All rights reserved.
//

#import "BLMatchViewController.h"
#import "BLPickerView.h"
#import "BLMatchSwitch.h"
#import "BLMenuNavController.h"
#import "BLMatchedViewController.h"
#import "BLWaitingResponseViewController.h"
#import "BLMessagesViewController.h"
#import "UIViewController+BLMenuNavController.h"
#import "Masonry.h"
#import <CoreLocation/CoreLocation.h>
#import <MBProgressHUD/MBProgressHUD.h>
#import <TransitionKit/TransitionKit.h>

@interface BLMatchViewController () <CLLocationManagerDelegate, BLPickerViewDataSource, BLPickerViewDelegate, BLMatchedViewControllerDelegate, BLMatchNotificationDelegate, MBProgressHUDDelegate, BLMessagesViewControllerDelegate, MBProgressHUDDelegate> {
    MBProgressHUD *_HUD;
}

typedef NS_ENUM(NSInteger, BLMatchViewEvent) {
    BLMatchViewEventNone = 0,
    BLMatchViewEventMatching = 1,
    BLMatchViewEventMatched = 2,
    BLMatchViewEventRecjected = 3,
    BLMatchViewEventStop = 4
};

@property (strong, nonatomic) UIView *background;
@property (strong, nonatomic) UIButton *btnMenu;
@property (strong, nonatomic) UILabel *lbTitle;
@property (strong, nonatomic) BLPickerView *pickViewDistance;
@property (strong, nonatomic) UILabel *pickViewMask;
@property (strong, nonatomic) BLMatchSwitch *matchSwith;
@property (strong, nonatomic) UIPickerView *pickerView;
@property (strong, nonatomic) NSArray *arrayDistanceData;
@property (strong, nonatomic) NSNumber *distance;
@property (strong, nonatomic) CLLocationManager *locationManager;
@property (strong, nonatomic) UIButton *btnMatchSwitch;
@property (assign, nonatomic) BOOL isMatchSwitchOpen;

@property (strong, nonatomic) UIImageView *matchingLeft;
@property (strong, nonatomic) UIImageView *matchingRight;
@property (strong, nonatomic) UIImageView *matchedImageView;
@property (assign, nonatomic) CGPoint startLeftCenter;
@property (assign, nonatomic) CGPoint startRightCenter;

@property (strong, nonatomic) User *currentUser;
@property (strong, nonatomic) User *matchedUser;
@property (assign, nonatomic) NSInteger coupleState;
@property (assign, nonatomic) BOOL hasUpdateFirstLoaction;
@property (assign, nonatomic) BOOL isMatchingAnimationRunning;
@property (assign, nonatomic) BOOL isHeartbeatAimationRunning;
@property (strong, nonatomic) TKStateMachine *viewControlelrStateMachine;

@end

@implementation BLMatchViewController


#pragma mark -
#pragma mark Life cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = [BLColorDefinition backgroundGrayColor];
    
    [self.view addSubview:self.btnMenu];
    
    _lbTitle = [[UILabel alloc] init];
    _lbTitle.font = [BLFontDefinition normalFont:20.0f];
    _lbTitle.textAlignment = NSTextAlignmentCenter;
    _lbTitle.textColor = [BLColorDefinition fontGrayColor];
    _lbTitle.text = NSLocalizedString(@"Set the distance", nil);
    [self.view addSubview:_lbTitle];
    
    _arrayDistanceData = [[NSArray alloc] initWithObjects:@"200",
                                                          @"400",
                                                          @"600",
                                                          @"800",
                                                          @"1000",
                                                          @"1200",
                                                          @"1400",
                                                          @"1600",
                                                          @"1800",
                                                          @"2000",
                                                            nil];
    _pickViewDistance = [[BLPickerView alloc] initWithFrame:CGRectMake(0, [BLGenernalDefinition resolutionForDevices:200],
                                                                       self.view.frame.size.width, [BLGenernalDefinition resolutionForDevices:225.0f])];
    _pickViewDistance.delegate = self;
    _pickViewDistance.dataSource = self;
    _pickViewDistance.fisheyeFactor = 0.001;
    [_pickViewDistance selectRow:4 animated:NO];

    [self.view addSubview:_pickViewDistance];
    self.distance = [_arrayDistanceData objectAtIndex:3];
    
    _matchSwith = [[BLMatchSwitch alloc] init];
    _matchSwith.backgroundColor = [UIColor clearColor];
    [_matchSwith addTarget:self action:@selector(matchToLove:) forControlEvents:UIControlEventValueChanged];
//    [self.view addSubview:_matchSwith];
    [self.view addSubview:self.lbTitle];
    [self.view addSubview:self.pickViewDistance];
//    [self.view addSubview:self.matchSwith];
    [self.view addSubview:self.matchingLeft];
    [self.view addSubview:self.matchingRight];
    [self.view addSubview:self.matchedImageView];
    [self.view addSubview:self.btnMatchSwitch];
    [self loadLayouts];
    [self addHUD];
    
    self.distance = [self.arrayDistanceData objectAtIndex:3];
    self.hasUpdateFirstLoaction = NO;
    self.matchedImageView.alpha = 0.0f;
    self.matchingLeft.alpha = 0.0f;
    self.matchingRight.alpha = 0.0f;
    
    self.isMatchingAnimationRunning = NO;
    self.isHeartbeatAimationRunning = NO;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self fetchUserMatchedInfo];
    // Regiest Notification
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(fetchUserMatchedInfo) name:@"getMatchInfo" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(applicationWillEnterForeground) name:UIApplicationWillEnterForegroundNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(applicationWillResignActive) name:UIApplicationWillResignActiveNotification object:nil];
}

- (void)viewDidAppear:(BOOL)animated {
    [self blAppDelegate].notificationDelegate = self;
}

- (void)viewWillDisappear:(BOOL)animated {
    [self blAppDelegate].notificationDelegate = nil;
}

- (void)viewDidDisappear:(BOOL)animated {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"getMatchInfo" object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIApplicationWillEnterForegroundNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIApplicationWillResignActiveNotification object:nil];
}

#pragma mark - Layouts
- (void)loadLayouts {
    [_lbTitle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view).with.offset([BLGenernalDefinition resolutionForDevices:135.7f]);
        make.centerX.equalTo(self.view.mas_centerX);
    }];
    
//    [_matchSwith mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.bottom.equalTo(self.view).with.offset([BLGenernalDefinition resolutionForDevices:-64.9f]);
//        make.centerX.equalTo(self.view.mas_centerX);
//        make.width.equalTo([NSNumber numberWithDouble:[BLGenernalDefinition resolutionForDevices:250.0f]]);
//        make.height.equalTo([NSNumber numberWithDouble:[BLGenernalDefinition resolutionForDevices:78.0f]]);
//    }];
    
    [self.btnMatchSwitch mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.view).with.offset([BLGenernalDefinition resolutionForDevices:-84.9f]);
        make.centerX.equalTo(self.view.mas_centerX);
        make.width.equalTo([NSNumber numberWithDouble:[BLGenernalDefinition resolutionForDevices:250.0f]]);
        make.height.equalTo([NSNumber numberWithDouble:[BLGenernalDefinition resolutionForDevices:60.0f]]);
    }];
    
    [self.btnMenu mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.btnMenu.superview).with.offset([BLGenernalDefinition resolutionForDevices:31.2f]);
        make.right.equalTo(self.btnMenu.superview).with.offset([BLGenernalDefinition resolutionForDevices:-20.8f]);
        make.width.height.equalTo([NSNumber numberWithDouble:[BLGenernalDefinition resolutionForDevices:45.3f]]);
    }];
    
    [self.matchingLeft mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.matchingLeft.superview).with.offset([BLGenernalDefinition resolutionForDevices:-40.0f]);
        make.centerY.equalTo(self.matchingLeft.superview).with.offset([BLGenernalDefinition resolutionForDevices:-20.0f]);
        make.width.equalTo([NSNumber numberWithDouble:[BLGenernalDefinition resolutionForDevices:80.0f]]);
        make.height.equalTo([NSNumber numberWithDouble:[BLGenernalDefinition resolutionForDevices:160.0f]]);
    }];
    [self.matchingRight mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.matchingRight.superview).with.offset([BLGenernalDefinition resolutionForDevices:40.0f]);
        make.centerY.equalTo(self.matchingRight.superview).with.offset([BLGenernalDefinition resolutionForDevices:-20.0f]);
        make.width.equalTo([NSNumber numberWithDouble:[BLGenernalDefinition resolutionForDevices:80.0f]]);
        make.height.equalTo([NSNumber numberWithDouble:[BLGenernalDefinition resolutionForDevices:160.0f]]);
    }];
    
    [self.matchedImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.matchedImageView.superview);
        make.centerY.equalTo(self.matchedImageView.superview).with.offset([BLGenernalDefinition resolutionForDevices:-20.0f]);
        make.width.height.equalTo([NSNumber numberWithDouble:[BLGenernalDefinition resolutionForDevices:160.0f]]);
    }];
    
        BLAppDelegate *blDelegate = (BLAppDelegate *)[[UIApplication sharedApplication] delegate];
        NSDictionary *dic = [[NSDictionary alloc] init];
        dic = [[NSUserDefaults standardUserDefaults] dictionaryRepresentation];
        User *user = [User new];
        user.userId = dic[@"user_id"];
    
        if (blDelegate.deviceToken && user.userId) {
            [[BLHTTPClient sharedBLHTTPClient] registToken:blDelegate.deviceToken user:user success:^(NSURLSessionDataTask *task, id responseObject) {
                NSLog(@"Regist device token successed.");
            } failure:^(NSURLSessionDataTask *task, NSError *error) {
                NSLog(@"Regist device token failed. error: %@", error.localizedDescription);
            }];
        }
}

#pragma mark -
#pragma mark Public Method
- (void)matched:(User *)matchedUser {
    if (!matchedUser) {
        return;
    }
    self.matchedUser = matchedUser;
    [self stateMachine:BLMatchViewEventMatched];
//    NSError *error = nil;
//    BOOL success = [self.viewControlelrStateMachine fireEvent:@"user matched" userInfo:nil error:&error];
//    if (!success) {
//        NSLog(@"State machine error: %@. Event: close, current state: %@.", error.localizedDescription, self.viewControlelrStateMachine.currentState);
//    }
}

- (void)closeMatching {
//    [self stateMachine:BLMatchViewEventStop];
}

#pragma mark - Delegates

#pragma mark BLMatchStopLocationDelegate
- (void)didFinishLogout {
    
    [_locationManager stopUpdatingLocation];
    NSLog(@"-------------success--------------");
}

#pragma mark Picker View Delegate and Data Source
- (NSInteger)numberOfRowsInPickerView:(BLPickerView *)pickerView {
    return self.arrayDistanceData.count;
}

- (NSString *)pickerView:(BLPickerView *)pickerView titleForRow:(NSInteger)row {
    return [self.arrayDistanceData objectAtIndex:row];
}

- (void)pickerView:(BLPickerView *)pickerView didSelectRow:(NSInteger)row {
    NSLog(@"Select distance: %@", [self.arrayDistanceData objectAtIndex:row]);
    self.distance = [self.arrayDistanceData objectAtIndex:row];
}

#pragma mark CLLocationManagerDelegate
- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations {
    CLLocation* location = [locations lastObject];
    NSDate* eventDate = location.timestamp;
    NSTimeInterval howRecent = [eventDate timeIntervalSinceNow];
    if (fabs(howRecent) < 15.0) {
        // If the event is recent, do something with it.
        NSLog(@"latitude %+.6f, longitude %+.6f\n",
              location.coordinate.latitude,
              location.coordinate.longitude);
        User *locationUser = [User new];
        locationUser.latitude = [NSNumber numberWithDouble:location.coordinate.latitude];
        locationUser.longitude = [NSNumber numberWithDouble:location.coordinate.longitude];
        
        NSDictionary *dic = [[NSUserDefaults standardUserDefaults] dictionaryRepresentation];
        locationUser.userId = dic[@"user_id"];
        
        if (!(locationUser.userId == nil) && !(locationUser.longitude) && !(locationUser.latitude)) {
            return;
        } else {
            [[BLHTTPClient sharedBLHTTPClient] updateLocation:locationUser success:^(NSURLSessionDataTask *task, id responseObject) {
                NSLog(@"Update location successed.");
                self.hasUpdateFirstLoaction = YES;
            } failure:^(NSURLSessionDataTask *task, NSError *error) {
                
                NSLog(@"erroo == %@", error.localizedDescription);
                UIAlertView *av = [[UIAlertView alloc] initWithTitle:nil message:NSLocalizedString(@"Can't connnect to server, please try again later.", nil) delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil];
                [av show];
                [self stopMatching];
            }];

        }
    }
}

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error {
    NSLog(@"Error while getting loaction: %@", error.localizedDescription);
    if (error.code == kCLErrorDenied) {
        NSLog(@"app denied.");
    }
    [_locationManager stopUpdatingLocation];
}

- (void)locationManager:(CLLocationManager *)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status {
    switch (status) {
        case kCLAuthorizationStatusAuthorizedAlways:
        case kCLAuthorizationStatusAuthorizedWhenInUse:
            [manager startUpdatingLocation];
            [self startMatchingAnimation];
            break;
        case kCLAuthorizationStatusNotDetermined:
            break;
        case kCLAuthorizationStatusDenied:
        case kCLAuthorizationStatusRestricted:
        {
//            self.matchSwith.on = NO;
            [self btnMatchSwitchOff];
            self.matchingLeft.alpha = 0.0f;
            self.matchingRight.alpha = 0.0f;
            self.pickViewDistance.alpha = 1.0f;
        }
        default:
            break;
    }
}

#pragma mark BLMatchedViewController Delegate
- (void)didRejectedMatchedUser {
    [self stateMachine:BLMatchViewEventMatching];
}

- (void)didCloseConversation {
//    [self stateMachine:BLMatchViewEventStop];
    [self.navigationController popToRootViewControllerAnimated:YES];
}

#pragma mark BLMessageViewController Delegate
- (void)didDismissBLMessagesViewController:(BLMessagesViewController *)vc {
    [vc.navigationController popToRootViewControllerAnimated:YES];
//    [[BLHTTPClient sharedBLHTTPClient] match:self.currentUser event:BLMatchEventClose distance:nil matchedUser:self.matchedUser success:^(NSURLSessionDataTask *task, id responseObject) {
//        NSLog(@"Stop conversation user successed.");
//        [vc.navigationController popToRootViewControllerAnimated:YES];
//    } failure:^(NSURLSessionDataTask *task, NSError *error) {
//        NSLog(@"Stop conversation faield.");
//    }];
}

#pragma mark BLNotification Delegate
- (void)receiveMatchedNotification:(User *)matchedUser {
    if (!matchedUser) {
        return;
    }
    self.matchedUser = matchedUser;
    [self stateMachine:BLMatchViewEventMatched];
}

- (void)receiveAcceptedNotification:(User *)matchedUser {
    if (!matchedUser) {
        return;
    }
    
    if (self.matchedUser.userId != matchedUser.userId) {
        return;
    }
    
    BLMatchedViewController *matchedViewController = [[BLMatchedViewController alloc] init];
    matchedViewController.matchedUser = self.matchedUser;
    matchedViewController.delegate = self;
    [self.navigationController pushViewController:matchedViewController animated:YES];
    matchedViewController.isMatchedUserAccepted = YES;
}

- (void)receiveRejectedNotification {
    [self stateMachine:BLMatchViewEventRecjected];
}

- (void)receiveCloseNotification {
    [self stateMachine:BLMatchViewEventStop];
}

#pragma mark - Handle Switch
- (void)matchToLove:(BLMatchSwitch *)sender {
    if (sender.on) {
        NSLog(@"Starting to Match...");
//        [self stateMachine:BLMatchViewEventMatching];
        NSDictionary *userInfo = nil;
        NSError *error = nil;
        BOOL success = [self.viewControlelrStateMachine fireEvent:@"open" userInfo:userInfo error:&error];
        if (!success) {
            NSLog(@"State machine error: %@.", error.localizedDescription);
        }
    } else {
        NSLog(@"Finish Matching...");
//        [self stateMachine:BLMatchViewEventStop];
        NSDictionary *userInfo = nil;
        NSError *error = nil;
        BOOL success = [self.viewControlelrStateMachine fireEvent:@"close" userInfo:userInfo error:&error];
        if (!success) {
            NSLog(@"State machine error: %@.", error.localizedDescription);
        }
    }
}

#pragma mark - Actions
- (void)showMenu:(id)sender {
    [self presentMenuViewController:sender];
}

- (void)presentMatchedViewController {
    BLMatchedViewController *matchedViewController = [[BLMatchedViewController alloc] init];
//    matchedViewController.matchedUser = self.matchedUser;
    matchedViewController.delegate = self;
    [self.navigationController pushViewController:matchedViewController animated:YES];
}

- (void)switchMatchButton {
    if (self.isMatchSwitchOpen) {
        [self btnMatchSwitchOff];
//        self.isMatchSwitchOpen = NO;
//        [self.btnMatchSwitch setBackgroundColor:[BLColorDefinition greenColor]];
//        [self.btnMatchSwitch setTitle:NSLocalizedString(@"Start to love", nil) forState:UIControlStateNormal];
        
        NSLog(@"Finish Matching...");
        NSDictionary *userInfo = nil;
        NSError *error = nil;
        BOOL success = [self.viewControlelrStateMachine fireEvent:@"close" userInfo:userInfo error:&error];
        if (!success) {
            NSLog(@"State machine error: %@.", error.localizedDescription);
        }
        
    } else {
        [self btnMatchSwitchOn];
//        self.isMatchSwitchOpen = YES;
//        [self.btnMatchSwitch setBackgroundColor:[UIColor grayColor]];
//        [self.btnMatchSwitch setTitle:NSLocalizedString(@"Stop matching", nil) forState:UIControlStateNormal];
        
        NSLog(@"Starting to Match...");
        NSDictionary *userInfo = nil;
        NSError *error = nil;
        BOOL success = [self.viewControlelrStateMachine fireEvent:@"open" userInfo:userInfo error:&error];
        if (!success) {
            NSLog(@"State machine error: %@.", error.localizedDescription);
        }
    }
}

- (void)timerfired {
    if (self.hasUpdateFirstLoaction) {
//        [[BLHTTPClient sharedBLHTTPClient] matching:self.currentUser success:^(NSURLSessionDataTask *task, id responseObject) {
//            User *matchedUser = [[User alloc] initWithDictionary:[responseObject objectForKey:@"user"]];
//            if (matchedUser) {
//                // TODO: go to matched view;
//            } else {
//                NSLog(@"There no person matched...");
//            }
//        } failure:^(NSURLSessionDataTask *task, NSError *error) {
//            UIAlertView *av = [[UIAlertView alloc] initWithTitle:nil message:NSLocalizedString(@"Matching failed, please try again later", nil) delegate:self cancelButtonTitle:NSLocalizedString(@"Ok", nil) otherButtonTitles:nil];
//            [av show];
//            [self stopMatching];
//        }];
    }
}

#pragma mark - Notifications
- (void)applicationWillEnterForeground {//回到前台
    if (self.currentUser.state == BLMatchStateMatching) {
        [self startMatchingAnimation];
    }
//    [self.locationManager stopMonitoringSignificantLocationChanges];
//    [self.locationManager startUpdatingLocation];
    [self stopSignificantChangeUpdates];
    [self startStandardUpdates];
}

- (void)applicationWillResignActive {//进入后台
    if (self.currentUser.state == BLMatchStateMatching) {
        [self stopMatchingAnimationWithCompletion:nil];
    }
//    [self.locationManager stopUpdatingLocation];
    [self stopStandarUpdates];
    [self startSignificantChangeUpdates];
//    [self.locationManager startMonitoringSignificantLocationChanges];
}

#pragma mark -
#pragma mark Private Methods
- (void)fetchUserMatchedInfo {
    [_HUD show:YES];
    [[BLHTTPClient sharedBLHTTPClient] getMatchInfo:self.currentUser success:^(NSURLSessionDataTask *task, id responseObject) {
        [_HUD hide:YES];
        [self.currentUser updateState:[[[responseObject objectForKey:@"user"] objectForKey:@"state"] integerValue]];
        self.coupleState = [[responseObject objectForKey:@"state"] integerValue];
        self.matchedUser = [[User alloc] initWithDictionary:[responseObject objectForKey:@"matched_user"]];
        [self reloadViewController];
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        [_HUD hide:YES];
        NSLog(@"Get match info failed, error: %@.", error.localizedDescription);
    }];
}

- (void)reloadViewController {
    switch (self.currentUser.state) {
        case BLMatchStateStop:
        {
            NSError *error = nil;
            if (![self.viewControlelrStateMachine.currentState.name isEqualToString:@"idle"]) {
                BOOL success = [self.viewControlelrStateMachine fireEvent:@"close" userInfo:nil error:&error];
                if (!success) {
                    NSLog(@"State machine error: %@. Event: close, current state: %@.", error.localizedDescription, self.viewControlelrStateMachine.currentState);
                }
            }
            break;
        }
        case BLMatchStateMatching:
        {
            NSError *error = nil;
            BOOL success = [self.viewControlelrStateMachine fireEvent:@"start matching" userInfo:nil error:&error];
            if (!success) {
                NSLog(@"State machine error: %@. Event: start matching, current state: %@.", error.localizedDescription, self.viewControlelrStateMachine.currentState);
            }
            break;
        }
        case BLMatchStateMatched:
        {
            NSError *error = nil;
            BOOL success = [self.viewControlelrStateMachine fireEvent:@"user matched" userInfo:nil error:&error];
            if (!success) {
                NSLog(@"State machine error: %@. Event: matchedUser, current state: %@.", error.localizedDescription, self.viewControlelrStateMachine.currentState);
            }
            break;
        }
        case BLMatchStateWaiting:
        {
            BLWaitingResponseViewController *waitingViewController = [[BLWaitingResponseViewController alloc] init];
            waitingViewController.matchedUser = self.matchedUser;
            [self.navigationController pushViewController: waitingViewController animated:YES];
            break;
        }
        case BLMatchStateCommunication:
        {
            BLMessagesViewController *messageViewController = [[BLMessagesViewController alloc] init];
            messageViewController.delegate = self;
            messageViewController.sender = self.currentUser;
            messageViewController.receiver = self.matchedUser;
            [self.navigationController pushViewController:messageViewController animated:YES];
            break;
        }
        default:
            break;
    }
}

- (void)stateMachine:(BLMatchViewEvent)event {
    switch (self.currentUser.state) {
        case BLMatchStateStop:
            [self matchStateStopWithEvent:event];
            break;
        case BLMatchStateMatching:
            [self matchStateMatchingWithEvent:event];
            break;
        case BLMatchStateMatched:
            [self matchStateMatchedWithEvent:event];
            break;
        default:
            break;
    }
}

- (void)matchStateStopWithEvent:(BLMatchViewEvent)event {
    switch (event) {
        case BLMatchViewEventMatching:
        {
            //start animation
            [UIView animateWithDuration:0.5f animations:^{
                self.pickViewDistance.alpha = 0.0f;
                self.matchingLeft.alpha = 1.0f;
                self.matchingRight.alpha = 1.0f;
            } completion:^(BOOL finished) {
                [self startMatchingAnimation];
                //update location
                [self startStandardUpdates];
            }];
            NSDictionary *dic = [[NSUserDefaults standardUserDefaults] dictionaryRepresentation];
            User *user = [User new];
            user.userId = dic[@"user_id"];
            
            //send http request to update match state
            [[BLHTTPClient sharedBLHTTPClient] match:user event:BLMatchEventStartMatching distance:self.distance matchedUser:self.currentUser success:^(NSURLSessionDataTask *task, id responseObject) {
                NSLog(@"start matching");
                
            } failure:^(NSURLSessionDataTask *task, NSError *error) {
                NSLog(@"start match failed.");
                UIAlertView *av = [[UIAlertView alloc] initWithTitle:nil message:NSLocalizedString(@"Matching failed, please try again later", nil) delegate:self cancelButtonTitle:NSLocalizedString(@"Ok", nil) otherButtonTitles:nil];
                [av show];
                [self stopMatching];
//                self.matchSwith.on = NO;
                [self btnMatchSwitchOff];
            }];

            //change current state
            [self.currentUser updateState:BLMatchStateMatching];
            break;
        }
        case BLMatchViewEventStop:
        case BLMatchViewEventMatched:
        case BLMatchViewEventNone:
        default:
            break;
    }
}

- (void)matchStateMatchingWithEvent:(BLMatchViewEvent)event {
    switch (event) {
        case BLMatchViewEventMatching:
            // Do nothing
            break;
        case BLMatchViewEventMatched:
        {
            // stop animation
            [self stopMatchingAnimationWithCompletion:^(BOOL finished) {
                self.matchingLeft.alpha = 0.0f;
                self.matchingRight.alpha = 0.0f;
                self.matchedImageView.alpha = 1.0f;
                
                // start heartbeat animation
                [self startHeartbeatAnimation];
            }];
            [self stopStandarUpdates];
            
            // add gesture to present matched view
            UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(presentMatchedViewController)];
            [self.matchedImageView addGestureRecognizer:tapGestureRecognizer];
            self.matchedImageView.userInteractionEnabled = YES;
            
            // change current state
            [self.currentUser updateState:BLMatchStateMatched];
            break;
        }
        case BLMatchViewEventStop:
        {
            // stop matching
            [self stopMatching];
            [self.currentUser updateState:BLMatchStateStop];
            [[BLHTTPClient sharedBLHTTPClient] match:self.currentUser event:BLMatchEventStop distance:nil matchedUser:nil success:^(NSURLSessionDataTask *task, id responseObject) {
                NSLog(@"Stop matching success...");
            } failure:^(NSURLSessionDataTask *task, NSError *error) {
                NSLog(@"Stop matching failed...");
            }];
            break;
        }
        case BLMatchViewEventRecjected:
        case BLMatchViewEventNone:
        default:
            break;
    }
}

- (void)matchStateMatchedWithEvent:(BLMatchViewEvent)event {
    switch (event) {
        case BLMatchViewEventMatching:
        {
            //start animation
            [UIView animateWithDuration:0.5f animations:^{
                self.matchedImageView.alpha = 0.0f;
                self.matchingLeft.alpha = 1.0f;
                self.matchingRight.alpha = 1.0f;
            } completion:^(BOOL finished) {
                [self startMatchingAnimation];
                //update location
                [self startStandardUpdates];
            }];
            
            //send http request to update match state
            [[BLHTTPClient sharedBLHTTPClient] match:self.currentUser event:BLMatchEventStartMatching distance:self.distance matchedUser:nil success:^(NSURLSessionDataTask *task, id responseObject) {
                NSLog(@"start matching");
            } failure:^(NSURLSessionDataTask *task, NSError *error) {
                NSLog(@"start match failed.");
                UIAlertView *av = [[UIAlertView alloc] initWithTitle:nil message:NSLocalizedString(@"Matching failed, please try again later", nil) delegate:self cancelButtonTitle:NSLocalizedString(@"Ok", nil) otherButtonTitles:nil];
                [av show];
                [self stopMatching];
            }];
            
            //change current state
            [self.currentUser updateState:BLMatchStateMatching];
            break;
        }
        case BLMatchViewEventStop:
        {
            [self.currentUser updateState:BLMatchStateStop];
            [UIView animateWithDuration:0.5f animations:^{
                self.matchedImageView.alpha = 0.0f;
                self.pickViewDistance.alpha = 1.0f;
            } completion:^(BOOL finished) {
                self.matchSwith.on = NO;
            }];
            break;
        }
        case BLMatchViewEventRecjected:
        {
            [self stopMatchingAnimationWithCompletion:^(BOOL finished) {
                [self startMatchingAnimation];
            }];
            [self.currentUser updateState:BLMatchStateMatching];
            break;
        }
        case BLMatchViewEventMatched:
        case BLMatchViewEventNone:
        default:
            break;
    }
}

- (void)startStandardUpdates {
    if (!_locationManager) {
        _locationManager = [[CLLocationManager alloc] init];
    }
    
    _locationManager.delegate = self;
    _locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters;
    _locationManager.distanceFilter = 200;
    _locationManager.pausesLocationUpdatesAutomatically = NO;
    
    CLAuthorizationStatus authorizationStatus= [CLLocationManager authorizationStatus];
    if (authorizationStatus == kCLAuthorizationStatusAuthorizedAlways ||
        authorizationStatus == kCLAuthorizationStatusAuthorizedWhenInUse) {
        
        [_locationManager startUpdatingLocation];
    } else {
        [self.locationManager requestWhenInUseAuthorization];
    }
   
}

- (void)stopStandarUpdates {
    [_locationManager stopUpdatingLocation];
}

- (void)startSignificantChangeUpdates
{
    // Create the location manager if this object does not
    // already have one.
    if (nil == _locationManager) {
        _locationManager = [[CLLocationManager alloc] init];
    }
    
    _locationManager.delegate = self;
    _locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters;
    _locationManager.distanceFilter = 200;
    _locationManager.pausesLocationUpdatesAutomatically = NO;
    
    [_locationManager requestAlwaysAuthorization];
    [_locationManager startMonitoringSignificantLocationChanges];
    [_locationManager startUpdatingLocation];
    
}

- (void)stopSignificantChangeUpdates {
    if (_locationManager) {
        [_locationManager stopMonitoringSignificantLocationChanges];
    }
}

- (void)stopMatching {
    [self stopStandarUpdates];
    [self stopMatchingAnimationWithCompletion:^(BOOL finished) {
        [UIView animateWithDuration:0.5f animations:^{
            self.pickViewDistance.alpha = 1.0f;
            self.matchingLeft.alpha = 0.0f;
            self.matchingRight.alpha = 0.0f;
        }];
    }];
}

- (void)addHUD {
    _HUD = [[MBProgressHUD alloc] initWithView:self.view];
    _HUD.labelText = @"loading";
    _HUD.delegate = self;
    [self.view addSubview:_HUD];
}

- (void)btnMatchSwitchOn {
    self.isMatchSwitchOpen = YES;
    [self.btnMatchSwitch setBackgroundColor:[UIColor grayColor]];
    [self.btnMatchSwitch setTitle:NSLocalizedString(@"Stop matching", nil) forState:UIControlStateNormal];
}

- (void)btnMatchSwitchOff {
    self.isMatchSwitchOpen = NO;
    [self.btnMatchSwitch setBackgroundColor:[BLColorDefinition greenColor]];
    [self.btnMatchSwitch setTitle:NSLocalizedString(@"Start to love", nil) forState:UIControlStateNormal];
}

#pragma mark Animations
- (void)startMatchingAnimation {
    if (self.isMatchingAnimationRunning) {
        return;
    }
    self.startLeftCenter = self.matchingLeft.center;
    self.startRightCenter = self.matchingRight.center;
    self.isMatchingAnimationRunning = YES;
    [UIView animateWithDuration:2.0f animations:^{
        CGPoint leftCenter = self.matchingLeft.center;
        CGPoint rightCenter = self.matchingRight.center;
        leftCenter.y += 25;
        rightCenter.y -= 25;
        self.matchingLeft.center = leftCenter;
        self.matchingRight.center = rightCenter;
    }];
    
    [UIView animateWithDuration:4.0f delay:2.0f options:UIViewAnimationOptionAutoreverse | UIViewAnimationOptionRepeat animations:^{
        CGPoint leftCenter = self.matchingLeft.center;
        CGPoint rightCenter = self.matchingRight.center;
        leftCenter.y -= 50;
        rightCenter.y += 50;
        self.matchingLeft.center = leftCenter;
        self.matchingRight.center = rightCenter;
    } completion:nil];
}

- (void)stopMatchingAnimationWithCompletion: (void (^)(BOOL finished))completion {
    if (!self.isMatchingAnimationRunning) {
        return;
    }
    self.matchingLeft.frame = [[self.matchingLeft.layer presentationLayer] frame];
    self.matchingRight.frame = [[self.matchingRight.layer presentationLayer] frame];
    [self.matchingLeft.layer removeAllAnimations];
    [self.matchingRight.layer removeAllAnimations];
    [UIView animateWithDuration:1.0f animations:^{
        self.matchingLeft.center = self.startLeftCenter;
        self.matchingRight.center = self.startRightCenter;
    } completion:completion];
    self.isMatchingAnimationRunning = NO;
}

- (void)startHeartbeatAnimation {
    if (self.isHeartbeatAimationRunning) {
        return;
    }
    self.isHeartbeatAimationRunning = YES;
    [UIView animateWithDuration:1.0 delay:0
                        options:UIViewAnimationOptionAutoreverse | UIViewAnimationOptionRepeat | UIViewAnimationOptionAllowUserInteraction
     animations:^{
         self.matchedImageView.transform = CGAffineTransformMakeScale(0.5f, 0.5f);
     } completion:^(BOOL finished) {
         if (!finished) {
             [UIView animateWithDuration:0.2f animations:^{
                 self.matchedImageView.transform = CGAffineTransformMakeScale(1.0f, 1.0f);
             }];
         }
     }];
}

- (void)stopHeartbeatAnimation {
    if (!self.isHeartbeatAimationRunning) {
        return;
    }
    [self.matchedImageView.layer removeAllAnimations];
    self.isHeartbeatAimationRunning = NO;
}

#pragma mark -
#pragma mark Getter
- (UILabel *)lbTitle {
    if (!_lbTitle) {
        _lbTitle = [[UILabel alloc] init];
        _lbTitle.font = [BLFontDefinition normalFont:20.0f];
        _lbTitle.textAlignment = NSTextAlignmentCenter;
        _lbTitle.textColor = [BLColorDefinition fontGrayColor];
        _lbTitle.text = NSLocalizedString(@"Set the distance", nil);
    }
    return _lbTitle;
}

- (NSArray *)arrayDistanceData {
    if (!_arrayDistanceData) {
        _arrayDistanceData = [[NSArray alloc] initWithObjects:@"200", @"400", @"600", @"800", @"1000",
                              @"1200", @"1400", @"1600", @"1800", @"2000", nil];
    }
    return _arrayDistanceData;
}

- (BLPickerView *)pickViewDistance {
    if (!_pickViewDistance) {
        _pickViewDistance = [[BLPickerView alloc] initWithFrame:CGRectMake(0, [BLGenernalDefinition resolutionForDevices:200],
                                                                           self.view.frame.size.width, [BLGenernalDefinition resolutionForDevices:225.0f])];
        _pickViewDistance.delegate = self;
        _pickViewDistance.dataSource = self;
        _pickViewDistance.fisheyeFactor = 0.001;
        [_pickViewDistance selectRow:3 animated:NO];
    }
    return _pickViewDistance;
}

- (BLMatchSwitch *)matchSwith {
    if (!_matchSwith) {
        _matchSwith = [[BLMatchSwitch alloc] init];
        _matchSwith.backgroundColor = [UIColor clearColor];
        [_matchSwith addTarget:self action:@selector(matchToLove:) forControlEvents:UIControlEventValueChanged];
    }
    return _matchSwith;
}

- (UIButton *)btnMenu {
    if (!_btnMenu) {
        _btnMenu = [[UIButton alloc] init];
        [_btnMenu setBackgroundImage:[UIImage imageNamed:@"menu_icon.png"] forState:UIControlStateNormal];
        [_btnMenu addTarget:self action:@selector(showMenu:) forControlEvents:UIControlEventTouchDown];
    }
    return _btnMenu;
}

- (UIImageView *)matchedImageView {
    if (!_matchedImageView) {
        _matchedImageView = [[UIImageView alloc] init];
        _matchedImageView.image = [UIImage imageNamed:@"matched_icon.png"];
    }
    return _matchedImageView;
}

- (UIImageView *)matchingLeft {
    if (!_matchingLeft) {
        _matchingLeft = [[UIImageView alloc] init];
        _matchingLeft.image = [UIImage imageNamed:@"matching_left_icon.png"];
    }
    return _matchingLeft;
}

- (UIImageView *)matchingRight {
    if (!_matchingRight) {
        _matchingRight = [[UIImageView alloc] init];
        _matchingRight.image = [UIImage imageNamed:@"matching_right_icon.png"];
    }
    return _matchingRight;
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

- (UIButton *)btnMatchSwitch {
    if (!_btnMatchSwitch) {
        _btnMatchSwitch = [[UIButton alloc] init];
        [_btnMatchSwitch setBackgroundColor:[BLColorDefinition greenColor]];
        [_btnMatchSwitch setTitle:NSLocalizedString(@"Start to love", nil) forState:UIControlStateNormal];
        [_btnMatchSwitch addTarget:self action:@selector(switchMatchButton) forControlEvents:UIControlEventTouchUpInside];
        [_btnMatchSwitch setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _btnMatchSwitch.titleLabel.font = [BLFontDefinition boldFont:16.0f];
        _btnMatchSwitch.layer.cornerRadius = 10.0f;
        self.isMatchSwitchOpen = NO;
    }
    return _btnMatchSwitch;
}

- (TKStateMachine *)viewControlelrStateMachine {
    if (!_viewControlelrStateMachine) {
        _viewControlelrStateMachine = [TKStateMachine new];
        TKState *idle = [TKState stateWithName:@"idle"];
        TKState *matching = [TKState stateWithName:@"matching"];
        TKState *matched = [TKState stateWithName:@"matched"];
        [_viewControlelrStateMachine addStates:@[idle, matching, matched]];
        _viewControlelrStateMachine.initialState = idle;
        
        TKEvent *openSwitch = [TKEvent eventWithName:@"open" transitioningFromStates:@[idle] toState:matching];
        TKEvent *startMatching = [TKEvent eventWithName:@"start matching" transitioningFromStates:@[idle, matched] toState:matching];
        TKEvent *matchedUser = [TKEvent eventWithName:@"user matched" transitioningFromStates:@[matching] toState:matched];
        TKEvent *beenRejected = [TKEvent eventWithName:@"been rejected" transitioningFromStates:@[matched] toState:matching];
        TKEvent *closeSwitch = [TKEvent eventWithName:@"close" transitioningFromStates:@[matching, matched] toState:idle];
        [_viewControlelrStateMachine addEvents:@[openSwitch, startMatching, matchedUser, beenRejected, closeSwitch]];
        
        [idle setWillEnterStateBlock:^(TKState *state, TKTransition *transition) {
            [UIView animateWithDuration:0.5f animations:^{
                self.pickViewDistance.alpha = 1.0f;
            }];
            if (self.matchSwith.on) {
                self.matchSwith.on = NO;
            }
            if (self.isMatchSwitchOpen) {
                [self btnMatchSwitchOff];
            }
        }];
        
        [idle setDidExitStateBlock:^(TKState *state, TKTransition *transition) {
            [UIView animateWithDuration:0.5f animations:^{
                self.pickViewDistance.alpha = 0;
            }];
        }];
        
        [matching setWillEnterStateBlock:^(TKState *state, TKTransition *transition) {
            [UIView animateWithDuration:0.5 animations:^{
                self.matchingLeft.alpha = 1.0f;
                self.matchingRight.alpha = 1.0f;
            } completion:^(BOOL finished) {
                [self startMatchingAnimation];
                //update location
                [self startStandardUpdates];
            }];
            
            //send http request to update match state
            [[BLHTTPClient sharedBLHTTPClient] match:self.currentUser event:BLMatchEventStartMatching distance:self.distance matchedUser:nil success:^(NSURLSessionDataTask *task, id responseObject) {
                NSLog(@"start matching");
            } failure:^(NSURLSessionDataTask *task, NSError *error) {
                NSLog(@"start match failed.");
                UIAlertView *av = [[UIAlertView alloc] initWithTitle:nil message:NSLocalizedString(@"Matching failed, please try again later", nil) delegate:self cancelButtonTitle:NSLocalizedString(@"Ok", nil) otherButtonTitles:nil];
                [av show];
                [self stopMatching];
            }];
            
            //change current state
            [self.currentUser updateState:BLMatchStateMatching];
        }];
        
        [matching setDidExitStateBlock:^(TKState *state, TKTransition *transition) {
            [self stopMatchingAnimationWithCompletion:^(BOOL finished) {
                self.matchingLeft.alpha = 0;
                self.matchingRight.alpha = 0;
                [self stopStandarUpdates];
            }];
        }];
        
        [matched setWillEnterStateBlock:^(TKState *state, TKTransition *transition) {
            [UIView animateWithDuration:0.5f animations:^{
                self.matchedImageView.alpha = 1.0f;
            } completion:^(BOOL finished) {
                [self startHeartbeatAnimation];
                // add gesture to present matched view
                UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(presentMatchedViewController)];
                [self.matchedImageView addGestureRecognizer:tapGestureRecognizer];
                self.matchedImageView.userInteractionEnabled = YES;
                
                // change current state
                [self.currentUser updateState:BLMatchStateMatched];
            }];
        }];
        
        [matched setDidExitStateBlock:^(TKState *state, TKTransition *transition) {
            [UIView animateWithDuration:0.5f animations:^{
                self.matchedImageView.alpha = 0;
            }];
        }];
        
        [startMatching setDidFireEventBlock:^(TKEvent *event, TKTransition *transition) {
//            self.matchSwith.on = YES;
            [self btnMatchSwitchOn];
        }];
        
        [closeSwitch setDidFireEventBlock:^(TKEvent *event, TKTransition *transition) {
            [[BLHTTPClient sharedBLHTTPClient] match:self.currentUser event:BLMatchEventStop distance:nil matchedUser:nil success:^(NSURLSessionDataTask *task, id responseObject) {
                NSLog(@"Stop matching success...");
            } failure:^(NSURLSessionDataTask *task, NSError *error) {
                NSLog(@"Stop matching failed...");
            }];
        }];
    }
    return _viewControlelrStateMachine;
}

@end
