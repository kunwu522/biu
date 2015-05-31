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
#import "Masonry.h"

@interface BLMatchViewController () <BLPickerViewDataSource, BLPickerViewDelegate>

@property (retain, nonatomic) UIView *background;
@property (retain, nonatomic) UIButton *btnBack;
@property (retain, nonatomic) UIButton *btnMenu;
@property (retain, nonatomic) UILabel *lbTitle;
@property (retain, nonatomic) BLPickerView *pickViewDistance;
@property (retain, nonatomic) UILabel *pickViewMask;
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
    
    _pickViewDistance = [[BLPickerView alloc] initWithFrame:CGRectMake(0, 200, self.view.frame.size.width, 225.0f)];
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
    _pickViewDistance.delegate = self;
    _pickViewDistance.dataSource = self;
    _pickViewDistance.fisheyeFactor = 0.001;
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
    
//    [_pickViewDistance mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.centerX.equalTo(self.view.mas_centerX);
//        make.centerY.equalTo(self.view.mas_centerY);
//    }];
    
//    [_matchSwitch mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.bottom.equalTo(self.view).with.offset(64.9);
//    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Picker View Delegate and Data Source
- (NSInteger)numberOfRowsInPickerView:(BLPickerView *)pickerView {
    return _arrayDistanceData.count;
}

- (NSString *)pickerView:(BLPickerView *)pickerView titleForRow:(NSInteger)row {
    return [_arrayDistanceData objectAtIndex:row];
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