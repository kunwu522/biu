//
//  ViewController.m
//  biu
//
//  Created by Tony Wu on 5/5/15.
//  Copyright (c) 2015 BiuLove. All rights reserved.
//

#import "ViewController.h"

#import "Masonry.h"

@interface ViewController ()

@property (retain, nonatomic) UIImageView * logo;
@property (retain, nonatomic) UILabel * biuTitle;
@property (retain, nonatomic) UILabel * biuSubtitle;

@end

@implementation ViewController

static double ICON_INITIAL_SIZE = 150;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    self.view.backgroundColor = [UIColor blackColor];
    
    //Initial View
    _logo = [[UIImageView alloc] init];
    [self.view addSubview:_logo];
    _logo.image = [UIImage imageNamed:@"logo.png"];
    
    _biuTitle = [[UILabel alloc] init];
    _biuTitle.text = @"BIU";
    _biuTitle.font = [UIFont fontWithName:@"Arial-BoldMT" size:40];
    _biuTitle.textColor = [UIColor whiteColor];
    _biuTitle.textAlignment = NSTextAlignmentCenter;
    _biuTitle.adjustsFontSizeToFitWidth = YES;
    [self.view addSubview:_biuTitle];
    
    _biuSubtitle = [[UILabel alloc] init];
    _biuSubtitle.text = @"I AM CLOSE";
    _biuSubtitle.font = [UIFont fontWithName:@"ArialMT" size:18];
    _biuSubtitle.textColor = [UIColor grayColor];
    _biuSubtitle.textAlignment = NSTextAlignmentCenter;
    _biuSubtitle.adjustsFontSizeToFitWidth = YES;
    [self.view addSubview:_biuSubtitle];
    
    // Create constraints
    [_logo mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view.mas_centerX);
        make.centerY.equalTo(self.view.mas_centerY).with.offset(-50);
        make.height.equalTo([NSNumber numberWithDouble:ICON_INITIAL_SIZE]);
        make.width.equalTo([NSNumber numberWithDouble:ICON_INITIAL_SIZE]);
    }];
    
    [_biuTitle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(_logo.mas_centerX);
        make.centerY.equalTo(_logo.mas_bottom).with.offset(80);
    }];
    
    [_biuSubtitle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(_logo.mas_centerX);
        make.centerY.equalTo(_biuTitle.mas_bottom).with.offset(40);
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidAppear:(BOOL)animated {
//    sleep(2);
//    
//    [self loginViewLayout];
//    [UIView animateWithDuration:0.5 animations:^{
//        [self.view layoutIfNeeded];
//    } completion:^(BOOL finished) {
//        // TODO: show login input and button
//    }];
}

- (void)loginViewLayout {
    [_logo mas_updateConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.view.mas_centerY).with.offset(-150);
        make.height.equalTo(@100);
        make.width.equalTo(@100);
    }];
}

@end
