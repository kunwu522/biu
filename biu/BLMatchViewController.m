//
//  BLMatchViewController.m
//  biu
//
//  Created by Tony Wu on 5/27/15.
//  Copyright (c) 2015 BiuLove. All rights reserved.
//

#import <CoreLocation/CoreLocation.h>
#import "BLMatchViewController.h"
#import "BLPickerView.h"
#import "BLMatchSwitch.h"
#import "BLMenuNavController.h"
#import "BLMatchedViewController.h"
#import "BLMessagesViewController.h"
#import "UIViewController+BLMenuNavController.h"
#import "Masonry.h"

@interface BLMatchViewController () <BLPickerViewDataSource, BLPickerViewDelegate, CLLocationManagerDelegate, BLMatchedViewControllerDelegate, BLMatchNotificationDelegate>

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

@property (strong, nonatomic) UIImageView *matchingLeft;
@property (strong, nonatomic) UIImageView *matchingRight;
@property (strong, nonatomic) UIImageView *matchedImageView;
@property (assign, nonatomic) CGPoint startLeftCenter;
@property (assign, nonatomic) CGPoint startRightCenter;

@property (strong, nonatomic) User *currentUser;
@property (strong, nonatomic) User *matchedUser;
@property (assign, nonatomic) BOOL hasUpdateFirstLoaction;

@end

@implementation BLMatchViewController


#pragma mark -
#pragma mark Life cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.hasUpdateFirstLoaction = NO;
    [self.currentUser updateState:BLMatchStateStop];
    
    _background = [[UIView alloc] initWithFrame:self.view.frame];
    _background.backgroundColor = [BLColorDefinition backgroundGrayColor];
    [self.view addSubview:_background];
    [self.view addSubview:self.btnMenu];
    
    _lbTitle = [[UILabel alloc] init];
    _lbTitle.font = [BLFontDefinition normalFont:20.0f];
    _lbTitle.textAlignment = NSTextAlignmentCenter;
    _lbTitle.textColor = [BLColorDefinition fontGrayColor];
    _lbTitle.text = NSLocalizedString(@"Set the distance", nil);
    [self.view addSubview:_lbTitle];
    
    _arrayDistanceData = [[NSArray alloc] initWithObjects:@"500",
                                                          @"1000",
                                                          @"1500",
                                                          @"2000",
                                                          @"2500",
                                                          @"3000",
                                                          @"3500",
                                                          @"4000",
                                                          @"4500",
                                                          @"5000", nil];
    _pickViewDistance = [[BLPickerView alloc] initWithFrame:CGRectMake(0, [BLGenernalDefinition resolutionForDevices:200],
                                                                       self.view.frame.size.width, [BLGenernalDefinition resolutionForDevices:225.0f])];
    _pickViewDistance.delegate = self;
    _pickViewDistance.dataSource = self;
    _pickViewDistance.fisheyeFactor = 0.001;
    [_pickViewDistance selectRow:3 animated:NO];
    [self.view addSubview:_pickViewDistance];
    self.distance = [_arrayDistanceData objectAtIndex:3];
    
    _matchSwith = [[BLMatchSwitch alloc] init];
    _matchSwith.backgroundColor = [UIColor clearColor];
    [_matchSwith addTarget:self action:@selector(matchToLove:) forControlEvents:UIControlEventValueChanged];
    [self.view addSubview:_matchSwith];
    
    [self.view addSubview:self.matchingLeft];
    [self.view addSubview:self.matchingRight];
    [self.view addSubview:self.matchedImageView];
    self.matchedImageView.alpha = 0.0f;
    self.matchingLeft.alpha = 0.0f;
    self.matchingRight.alpha = 0.0f;
    
    [_lbTitle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view).with.offset([BLGenernalDefinition resolutionForDevices:135.7f]);
        make.centerX.equalTo(self.view.mas_centerX);
    }];
    
    [_matchSwith mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.view).with.offset([BLGenernalDefinition resolutionForDevices:-64.9f]);
        make.centerX.equalTo(self.view.mas_centerX);
        make.width.equalTo([NSNumber numberWithDouble:[BLGenernalDefinition resolutionForDevices:250.0f]]);
        make.height.equalTo([NSNumber numberWithDouble:[BLGenernalDefinition resolutionForDevices:78.0f]]);
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
}

- (void)viewDidAppear:(BOOL)animated {
    if (self.currentUser.state == BLMatchStateMatching) {
        self.matchSwith.on = YES;
        [self startMatchingAnimation];
    }
    [self blAppDelegate].notificationDelegate = self;
}

- (void)viewDidDisappear:(BOOL)animated {
    if (self.currentUser.state == BLMatchStateMatching) {
        [self stopMatchingAnimationWithCompletion:^(BOOL finished) {
            self.matchSwith.on = NO;
        }];
    }
}

- (void)viewWillDisappear:(BOOL)animated {
    [self blAppDelegate].notificationDelegate = nil;
}

#pragma mark -
#pragma mark Public Method
- (void)matched:(User *)matchedUser {
    if (!matchedUser) {
        return;
    }
    self.matchedUser = matchedUser;
    [self stateMachine:BLMatchViewEventMatched];
}

- (void)closeMatching {
    [self stateMachine:BLMatchViewEventStop];
}

#pragma mark - Delegates
#pragma mark Picker View Delegate and Data Source
- (NSInteger)numberOfRowsInPickerView:(BLPickerView *)pickerView {
    return _arrayDistanceData.count;
}

- (NSString *)pickerView:(BLPickerView *)pickerView titleForRow:(NSInteger)row {
    return [_arrayDistanceData objectAtIndex:row];
}

- (void)pickerView:(BLPickerView *)pickerView didSelectRow:(NSInteger)row {
    NSLog(@"Select distance: %@", [_arrayDistanceData objectAtIndex:row]);
    self.distance = [_arrayDistanceData objectAtIndex:row];
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
        self.currentUser.latitude = [NSNumber numberWithDouble:location.coordinate.latitude];
        self.currentUser.longitude = [NSNumber numberWithDouble:location.coordinate.longitude];
        [[BLHTTPClient sharedBLHTTPClient] updateLocation:self.currentUser success:^(NSURLSessionDataTask *task, id responseObject) {
            NSLog(@"Update location successed.");
            self.hasUpdateFirstLoaction = YES;
        } failure:^(NSURLSessionDataTask *task, NSError *error) {
            UIAlertView *av = [[UIAlertView alloc] initWithTitle:nil message:NSLocalizedString(@"Can't connnect to server, please try again later.", nil) delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil];
            [av show];
            [self stopMatching];
        }];
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
        case kCLAuthorizationStatusNotDetermined:
        case kCLAuthorizationStatusDenied:
        case kCLAuthorizationStatusRestricted:
        default:
            break;
    }
}

#pragma mark BLMatchedViewController Delegate
- (void)didRejectedMatchedUser {
    [self stateMachine:BLMatchViewEventMatching];
}

- (void)didCloseConversation {
    [self stateMachine:BLMatchViewEventStop];
    [self.navigationController popToRootViewControllerAnimated:YES];
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
        [self stateMachine:BLMatchViewEventMatching];
    } else {
        NSLog(@"Finish Matching...");
        [self stateMachine:BLMatchViewEventStop];
    }
}

#pragma mark - Actions
- (void)showMenu:(id)sender {
    [self presentMenuViewController:sender];
}

- (void)presentMatchedViewController {
    BLMatchedViewController *matchedViewController = [[BLMatchedViewController alloc] init];
    matchedViewController.matchedUser = self.matchedUser;
    matchedViewController.delegate = self;
    [self.navigationController pushViewController:matchedViewController animated:YES];
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

#pragma mark -
#pragma mark Private Methods
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
            
            //send http request to update match state
            [[BLHTTPClient sharedBLHTTPClient] match:self.currentUser event:BLMatchEventStartMatching distance:self.distance matchedUser:nil success:^(NSURLSessionDataTask *task, id responseObject) {
                NSLog(@"start matching");
            } failure:^(NSURLSessionDataTask *task, NSError *error) {
                NSLog(@"start match failed.");
                UIAlertView *av = [[UIAlertView alloc] initWithTitle:nil message:NSLocalizedString(@"Matching failed, please try again later", nil) delegate:self cancelButtonTitle:NSLocalizedString(@"Ok", nil) otherButtonTitles:nil];
                [av show];
                [self stopMatching];
                self.matchSwith.on = NO;
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
    _locationManager.distanceFilter = 500;
    
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

#pragma mark Animations
- (void)startMatchingAnimation {
    self.startLeftCenter = self.matchingLeft.center;
    NSLog(@"Start left center %f--%f", self.startLeftCenter.x, self.startLeftCenter.y);
    self.startRightCenter = self.matchingRight.center;
    NSLog(@"Start right center %f--%f", self.startRightCenter.x, self.startRightCenter.y);
    [UIView animateWithDuration:2.0f animations:^{
        CGPoint leftCenter = self.matchingLeft.center;
        CGPoint rightCenter = self.matchingRight.center;
        leftCenter.y += 25;
        rightCenter.y -= 25;
        self.matchingLeft.center = leftCenter;
        self.matchingRight.center = rightCenter;
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:4.0f delay:0.0f options:UIViewAnimationOptionAutoreverse | UIViewAnimationOptionRepeat animations:^{
            CGPoint leftCenter = self.matchingLeft.center;
            CGPoint rightCenter = self.matchingRight.center;
            leftCenter.y -= 50;
            rightCenter.y += 50;
            self.matchingLeft.center = leftCenter;
            self.matchingRight.center = rightCenter;
        } completion:nil];
    }];
}

- (void)stopMatchingAnimationWithCompletion: (void (^)(BOOL finished))completion {
    self.matchingLeft.frame = [[self.matchingLeft.layer presentationLayer] frame];
    self.matchingRight.frame = [[self.matchingRight.layer presentationLayer] frame];
    [self.matchingLeft.layer removeAllAnimations];
    [self.matchingRight.layer removeAllAnimations];
    [UIView animateWithDuration:1.0f animations:^{
        self.matchingLeft.center = self.startLeftCenter;
        self.matchingRight.center = self.startRightCenter;
    } completion:completion];
}

- (void)startHeartbeatAnimation {
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
    [self.matchedImageView.layer removeAllAnimations];
}


#pragma mark -
#pragma mark Getter
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
        BLAppDelegate *delegate = (BLAppDelegate *)[[UIApplication sharedApplication] delegate];
        _currentUser = delegate.currentUser;
    }
    return _currentUser;
}

- (BLAppDelegate *)blAppDelegate {
    return (BLAppDelegate *)[[UIApplication sharedApplication] delegate];
}

@end
