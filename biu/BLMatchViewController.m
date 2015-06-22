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

@end

@implementation BLMatchViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
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
    _pickViewDistance = [[BLPickerView alloc] initWithFrame:CGRectMake(0, 200, self.view.frame.size.width, 225.0f)];
    _pickViewDistance.delegate = self;
    _pickViewDistance.dataSource = self;
    _pickViewDistance.fisheyeFactor = 0.001;
    [_pickViewDistance selectRow:3 animated:NO];
    [self.view addSubview:_pickViewDistance];
    self.distance = [[_arrayDistanceData objectAtIndex:3] integerValue];
//    _pickerView = [[UIPickerView alloc] initWithFrame:CGRectMake(0, 200, self.view.frame.size.width, 300.0f)];
//    _pickerView.delegate = self;
//    _pickerView.dataSource = self;
//    [self.view addSubview:_pickerView];
    
    _matchSwith = [[BLMatchSwitch alloc] init];
    _matchSwith.backgroundColor = [UIColor clearColor];
    [_matchSwith addTarget:self action:@selector(matchToLove:) forControlEvents:UIControlEventValueChanged];
    [self.view addSubview:_matchSwith];
    
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
    if (abs(howRecent) < 15.0) {
        // If the event is recent, do something with it.
        NSLog(@"latitude %+.6f, longitude %+.6f\n",
              location.coordinate.latitude,
              location.coordinate.longitude);
    }
}

#pragma mark - Handle Switch
- (void)matchToLove:(BLMatchSwitch *)sender {
    if (sender.on) {
        NSLog(@"Starting to Match...");
        [self startStandardUpdates];
    } else {
        NSLog(@"Finish Matching...");
        [self stopStandarUpdates];
    }
}

#pragma mark - Actions
- (void)showMenu:(id)sender {
    [self presentMenuViewController:sender];
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
    
    [_locationManager startUpdatingLocation];
}

- (void)stopStandarUpdates {
    [_locationManager stopUpdatingLocation];
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

@end
