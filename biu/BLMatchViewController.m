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

@interface BLMatchViewController () <BLPickerViewDataSource, BLPickerViewDelegate, UIPickerViewDataSource, UIPickerViewDelegate>

@property (retain, nonatomic) UIView *background;
@property (retain, nonatomic) UIImageView *test;
@property (retain, nonatomic) UIButton *btnBack;
@property (retain, nonatomic) UIButton *btnMenu;
@property (retain, nonatomic) UILabel *lbTitle;
@property (retain, nonatomic) BLPickerView *pickViewDistance;
@property (retain, nonatomic) UILabel *pickViewMask;
@property (retain, nonatomic) BLMatchSwitch *matchSwith;

@property (retain, nonatomic) UIPickerView *pickerView;
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
//    _pickerView = [[UIPickerView alloc] initWithFrame:CGRectMake(0, 200, self.view.frame.size.width, 300.0f)];
//    _pickerView.delegate = self;
//    _pickerView.dataSource = self;
//    [self.view addSubview:_pickerView];
    
    _matchSwith = [[BLMatchSwitch alloc] init];
    _matchSwith.backgroundColor = [UIColor clearColor];
    [_matchSwith addTarget:self action:@selector(matchToLove:) forControlEvents:UIControlEventValueChanged];
    [self.view addSubview:_matchSwith];
    
    [_btnBack mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view).with.offset(31.2);
        make.left.equalTo(self.view).with.offset(20.8);
        make.width.equalTo(@45.3);
        make.height.equalTo(@45.3);
    }];
    
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

- (void)pickerView:(BLPickerView *)pickerView didSelectRow:(NSInteger)row {
    NSLog(@"Select distance: %@", [_arrayDistanceData objectAtIndex:row]);
}

//- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
//    return 1;
//}
//
//- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
//    return _arrayDistanceData.count;
//}
//
//- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
//    return [_arrayDistanceData objectAtIndex:row];
//}
//
//- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component {
//    return 50;
//}
//
//- (NSAttributedString *)pickerView:(UIPickerView *)pickerView attributedTitleForRow:(NSInteger)row forComponent:(NSInteger)component {
//    NSString *title = [_arrayDistanceData objectAtIndex:row];
//    UIColor *color = [UIColor colorWithRed:28.0 / 255.0 green:184.0 / 255.0 blue:134.0 / 255.0 alpha:1.0f];
//    UIFont *font = nil;
//    if (row == 1) {
//        font = [BLFontDefinition italicFont:40];
//    } else {
//        font = [BLFontDefinition boldFont:40.0f];
//    }
//    
//    NSDictionary *attributes = @{NSForegroundColorAttributeName : color,
//                                            NSFontAttributeName : font};
//    return [[NSAttributedString alloc] initWithString:title attributes:attributes];
//}

#pragma mark - Handle Switch
- (void)matchToLove:(BLMatchSwitch *)sender {
    if (sender.on) {
        NSLog(@"Starting to Match...");
    } else {
        NSLog(@"Finish Matching...");
    }
}

@end
