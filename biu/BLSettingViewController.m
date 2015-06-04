//
//  BLSettingViewController.m
//  biu
//
//  Created by Tony Wu on 6/2/15.
//  Copyright (c) 2015 BiuLove. All rights reserved.
//

#import "BLSettingViewController.h"
#import "Masonry.h"

@interface BLSettingViewController ()

@property (strong, nonatomic) UIButton *btnLogout;

@end

@implementation BLSettingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    _btnLogout = [[UIButton alloc] init];
    [_btnLogout addTarget:self action:@selector(logout:) forControlEvents:UIControlEventTouchDown];
    [_btnLogout setBackgroundColor:[UIColor redColor]];
    _btnLogout.titleLabel.font = [BLFontDefinition boldFont:20.0f];
    [_btnLogout setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_btnLogout setTitle:@"LOG OUT" forState:UIControlStateNormal];
    [self.view addSubview:_btnLogout];
    
    [_btnLogout mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(_btnLogout.superview);
        make.centerY.equalTo(_btnLogout.superview).with.offset(100.0f);
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - handle action
- (void)logout:(id)sender {
    
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end