//
//  BLMatchViewController.m
//  biu
//
//  Created by Tony Wu on 5/27/15.
//  Copyright (c) 2015 BiuLove. All rights reserved.
//

#import "BLMatchViewController.h"
#import "BLMatchSwitch.h"
#import "Masonry.h"

@interface BLMatchViewController () <UIPickerViewDataSource, UIPickerViewDelegate>

@property (retain, nonatomic) UIView *background;
@property (retain, nonatomic) UIButton *btnBack;
@property (retain, nonatomic) UIButton *btnMenu;
@property (retain, nonatomic) UILabel *lbTitle;
@property (retain, nonatomic) UIPickerView *pickViewDistance;
@property (retain, nonatomic) BLMatchSwitch *matchSwitch;

@property (retain, nonatomic) NSArray *arrayDistanceData;

@end

@implementation BLMatchViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    _background = [[UIView alloc] initWithFrame:self.view.frame];
    _background.backgroundColor = [BLColorDefinition backgroundGrayColor];
    [self.view addSubview:_background];
    
    _btnBack = [[UIButton alloc] init];
    [_btnBack setBackgroundImage:[UIImage imageNamed:@"back_icon2.png"] forState:UIControlStateNormal];
    [self.view addSubview:_btnBack];
    
    _btnMenu = [[UIButton alloc] init];
    [_btnMenu setBackgroundImage:[UIImage imageNamed:@"menu_icon.png"] forState:UIControlStateNormal];
    [self.view addSubview:_btnMenu];
    
    _lbTitle = [[UILabel alloc] init];
    _lbTitle.font = [UIFont fontWithName:@"ArialMT" size:20.0f];
    _lbTitle.textAlignment = NSTextAlignmentCenter;
    _lbTitle.textColor = [BLColorDefinition fontGrayColor];
    _lbTitle.text = NSLocalizedString(@"Set the distance", nil);
    [self.view addSubview:_lbTitle];
    
    _pickViewDistance = [[UIPickerView alloc] init];
    _arrayDistanceData = [[NSArray alloc] initWithObjects:@"0.5", @"1.0", @"1.5", @"2.0", @"2.5", @"3.0", @"3.5", @"4.0", @"4.5", @"5.0", nil];
    _pickViewDistance.delegate = self;
    _pickViewDistance.showsSelectionIndicator = NO;
    [self.view addSubview:_pickViewDistance];
    
//    _matchSwitch = [[BLMatchSwitch alloc] init];
//    [_matchSwitch addTarget:self action:@selector(matchToLove:) forControlEvents:UIControlEventValueChanged];
//    [self.view addSubview:_matchSwitch];
    
    [_btnBack mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view).with.offset(31.2);
        make.left.equalTo(self.view).with.offset(20.8);
        make.width.equalTo(@45.3);
        make.height.equalTo(@45.3);
    }];
    
    [_btnMenu mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view).with.offset(31.2);
        make.right.equalTo(self.view).with.offset(-20.8);
        make.width.equalTo(@45.3);
        make.height.equalTo(@45.3);
    }];
    
    [_lbTitle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view).with.offset(135.7);
        make.centerX.equalTo(self.view.mas_centerX);
    }];
    
    [_pickViewDistance mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view.mas_centerX);
        make.centerY.equalTo(self.view.mas_centerY);
    }];
    
//    [_matchSwitch mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.bottom.equalTo(self.view).with.offset(64.9);
//    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Picker View Delegate and Data Source
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    return _arrayDistanceData.count;
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    return [_arrayDistanceData objectAtIndex:row];
}

- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view {
    UILabel *newLabel = (UILabel *)view;
    if (!newLabel) {
        newLabel = [[UILabel alloc] init];
        newLabel.font = [UIFont fontWithName:@"ArialMT" size:20.0f];
        newLabel.textColor = [BLColorDefinition greenColor];
        newLabel.textAlignment = NSTextAlignmentCenter;
    }
    newLabel.text = [_arrayDistanceData objectAtIndex:row];
    return newLabel;
}

#pragma mark - Handle Switch
- (void)matchToLove:(BLMatchSwitch *)sender {
    if (sender.on) {
        NSLog(@"Starting to Match...");
    } else {
        NSLog(@"Finish Matching...");
    }
}

@end
