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
#import "BLBlurMenu.h"
#import "UIViewController+BLBlurMenu.h"
#import "Masonry.h"

@interface BLMatchViewController () <BLPickerViewDataSource, BLPickerViewDelegate, CLLocationManagerDelegate>

@property (strong, nonatomic) UIView *background;
@property (strong, nonatomic) UIButton *btnMenu;
@property (strong, nonatomic) UILabel *lbTitle;
@property (strong, nonatomic) BLPickerView *pickViewDistance;
@property (strong, nonatomic) UILabel *pickViewMask;
@property (strong, nonatomic) BLMatchSwitch *matchSwith;
@property (strong, nonatomic) UIPickerView *pickerView;
@property (strong, nonatomic) NSArray *arrayDistanceData;
@property (assign, nonatomic) NSInteger distance;
@property (strong, nonatomic) CLLocationManager *locationManager;

@property (strong, nonatomic) UIImageView *matchingLeft;
@property (strong, nonatomic) UIImageView *matchingRight;
@property (assign, nonatomic) CGPoint startLeftCenter;
@property (assign, nonatomic) CGPoint startRightCenter;

@property (strong, nonatomic) User *currentUser;
@property (strong, nonatomic) NSTimer *timer;
@property (assign, nonatomic) BOOL hasUpdateFirstLoaction;

@end

@implementation BLMatchViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    _background = [[UIView alloc] initWithFrame:self.view.frame];
    _background.backgroundColor = [BLColorDefinition backgroundGrayColor];
    [self.view addSubview:_background];
    [self.view addSubview:self.btnMenu];
    
    self.hasUpdateFirstLoaction = NO;
    
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
    _pickViewDistance = [[BLPickerView alloc] initWithFrame:CGRectMake(0, 200, self.view.frame.size.width, 225.0f)];
    _pickViewDistance.delegate = self;
    _pickViewDistance.dataSource = self;
    _pickViewDistance.fisheyeFactor = 0.001;
    [_pickViewDistance selectRow:3 animated:NO];
    [self.view addSubview:_pickViewDistance];
    self.distance = [[_arrayDistanceData objectAtIndex:3] integerValue];
    
    _matchSwith = [[BLMatchSwitch alloc] init];
    _matchSwith.backgroundColor = [UIColor clearColor];
    [_matchSwith addTarget:self action:@selector(matchToLove:) forControlEvents:UIControlEventValueChanged];
    [self.view addSubview:_matchSwith];
    
    [self.view addSubview:self.matchingLeft];
    [self.view addSubview:self.matchingRight];
    self.matchingLeft.alpha = 0.0f;
    self.matchingRight.alpha = 0.0f;
    
    [_lbTitle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view).with.offset(135.7);
        make.centerX.equalTo(self.view.mas_centerX);
    }];
    
    [_matchSwith mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.view).with.offset(-64.9);
        make.centerX.equalTo(self.view.mas_centerX);
        make.width.equalTo(@250.0f);
        make.height.equalTo(@78.0f);
    }];
    
    [self.btnMenu mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.btnMenu.superview).with.offset(31.2);
        make.right.equalTo(self.btnMenu.superview).with.offset(-20.8);
        make.width.equalTo(@45.3);
        make.height.equalTo(@45.3);
    }];
    
    [self.matchingLeft mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.matchingLeft.superview).with.offset(-40.0f);
        make.centerY.equalTo(self.matchingLeft.superview).with.offset(-20.0f);
        make.width.equalTo(@80.0f);
        make.height.equalTo(@160.0f);
    }];
    [self.matchingRight mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.matchingRight.superview).with.offset(40.0f);
        make.centerY.equalTo(self.matchingRight.superview).with.offset(-20.0f);
        make.width.equalTo(@80.0f);
        make.height.equalTo(@160.0f);
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - 
#pragma mark Picker View Delegate and Data Source
- (NSInteger)numberOfRowsInPickerView:(BLPickerView *)pickerView {
    return _arrayDistanceData.count;
}

- (NSString *)pickerView:(BLPickerView *)pickerView titleForRow:(NSInteger)row {
    return [_arrayDistanceData objectAtIndex:row];
}

- (void)pickerView:(BLPickerView *)pickerView didSelectRow:(NSInteger)row {
    NSLog(@"Select distance: %@", [_arrayDistanceData objectAtIndex:row]);
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
//        [[BLHTTPClient sharedBLHTTPClient] updateLocation:self.currentUser success:^(NSURLSessionDataTask *task, id responseObject) {
//            NSLog(@"Update location successed.");
//            self.hasUpdateFirstLoaction = YES;
//        } failure:^(NSURLSessionDataTask *task, NSError *error) {
//            UIAlertView *av = [[UIAlertView alloc] initWithTitle:nil message:NSLocalizedString(@"Can't connnect to server, please try again later.", nil) delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil];
//            [av show];
//            [self stopMatching];
//        }];
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


#pragma mark - Handle Switch
- (void)matchToLove:(BLMatchSwitch *)sender {
    if (sender.on) {
        NSLog(@"Starting to Match...");
        [UIView animateWithDuration:0.5f animations:^{
            self.pickViewDistance.alpha = 0.0f;
            self.matchingLeft.alpha = 1.0f;
            self.matchingRight.alpha = 1.0f;
        } completion:^(BOOL finished) {
            [self startMatchingAnimation];
            [self startStandardUpdates];
//            self.timer = [NSTimer scheduledTimerWithTimeInterval:30 target:self selector:@selector(timerfired) userInfo:nil repeats:YES];
        }];
    } else {
        NSLog(@"Finish Matching...");
        [self stopMatching];
    }
}

#pragma mark - Actions
- (void)showMenu:(id)sender {
    [self presentMenuViewController:sender];
}

- (void)startMatchingAnimation {
    self.startLeftCenter = self.matchingLeft.center;
    self.startRightCenter = self.matchingRight.center;
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

- (void)timerfired {
    if (self.hasUpdateFirstLoaction) {
        [[BLHTTPClient sharedBLHTTPClient] matching:self.currentUser success:^(NSURLSessionDataTask *task, id responseObject) {
            User *matchedUser = [[User alloc] initWithDictionary:[responseObject objectForKey:@"user"]];
            if (matchedUser) {
                // TODO: go to matched view;
            } else {
                NSLog(@"There no person matched...");
            }
        } failure:^(NSURLSessionDataTask *task, NSError *error) {
            UIAlertView *av = [[UIAlertView alloc] initWithTitle:nil message:NSLocalizedString(@"Matching failed, please try again later", nil) delegate:self cancelButtonTitle:NSLocalizedString(@"Ok", nil) otherButtonTitles:nil];
            [av show];
            [self stopMatching];
        }];
    }
}

#pragma mark -
#pragma mark Private Methods
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
    [self.timer invalidate];
    [self stopMatchingAnimationWithCompletion:^(BOOL finished) {
        [UIView animateWithDuration:0.5f animations:^{
            self.pickViewDistance.alpha = 1.0f;
            self.matchingLeft.alpha = 0.0f;
            self.matchingRight.alpha = 0.0f;
        }];
    }];
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
        BLAppDeleate *delegate = [[UIApplication sharedApplication] delegate];
        _currentUser = delegate.currentUser;
    }
    return _currentUser;
}

@end
