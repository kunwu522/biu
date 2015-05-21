//
//  BLSignupViewController.m
//  biu
//
//  Created by WuTony on 5/20/15.
//  Copyright (c) 2015 BiuLove. All rights reserved.
//

#import "BLSignupViewController.h"
#import "BLColorDefinition.h"

#import "BLTextField.h"

#import "Masonry.h"

@interface BLSignupViewController () <UIGestureRecognizerDelegate>

@property (retain, nonatomic) UIImageView *background;

@property (retain, nonatomic) UIButton *btnBack;
@property (retain, nonatomic) UIButton *btnForward;

@property (retain, nonatomic) UIImageView *imageViewLogo;

@property (retain, nonatomic) UILabel *lbSignup;
@property (retain, nonatomic) BLTextField *tfEmail;
@property (retain, nonatomic) BLTextField *tfPassword;
@property (retain, nonatomic) BLTextField *tfUsername;

@property (retain, nonatomic) UISwipeGestureRecognizer *swipeGestureRecognizer;

@end

@implementation BLSignupViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    _background = [[UIImageView alloc] initWithFrame:self.view.frame];
    _background.image = [UIImage imageNamed:@"wel_background.png"];
    [self.view addSubview:_background];
    
    _btnForward = [[UIButton alloc] init];
    [_btnForward setBackgroundImage:[UIImage imageNamed:@"forward_icon.png"] forState:UIControlStateNormal];
    [_btnForward addTarget:self action:@selector(forward:) forControlEvents:UIControlEventTouchDown];
    [self.view addSubview:_btnForward];
    
    _imageViewLogo = [[UIImageView alloc] init];
    _imageViewLogo.image = [UIImage imageNamed:@"logo.png"];
    [self.view addSubview:_imageViewLogo];
    
    _lbSignup = [[UILabel alloc] init];
    _lbSignup.text = NSLocalizedString(@"SIGN UP", nil);
    _lbSignup.textColor = [BLColorDefinition grayColor];
    [self.view addSubview:_lbSignup];
    
    _tfEmail = [[BLTextField alloc] init];
    _tfEmail.placeholder = NSLocalizedString(@"Email", nil);
    _tfEmail.backgroundColor = [UIColor clearColor];
    _tfEmail.textAlignment = NSTextAlignmentCenter;
    _tfEmail.layer.borderColor = [[BLColorDefinition grayColor] CGColor];
    _tfEmail.layer.borderWidth = 1.5f;
    _tfEmail.layer.cornerRadius = 5.0f;
    [self.view addSubview:_tfEmail];
    
    _tfPassword = [[BLTextField alloc] init];
    _tfPassword.placeholder = NSLocalizedString(@"Password", nil);
    _tfPassword.backgroundColor = [UIColor clearColor];
    _tfPassword.textAlignment = NSTextAlignmentCenter;
    _tfPassword.layer.borderColor = [[BLColorDefinition grayColor] CGColor];
    _tfPassword.layer.borderWidth = 1.5f;
    _tfPassword.layer.cornerRadius = 5.0f;
    [self.view addSubview:_tfPassword];
    
    _tfUsername = [[BLTextField alloc] init];
    _tfUsername.placeholder = NSLocalizedString(@"Username", nil);
    _tfUsername.backgroundColor = [UIColor clearColor];
    _tfUsername.textAlignment = NSTextAlignmentCenter;
    _tfUsername.layer.borderColor = [[BLColorDefinition grayColor] CGColor];
    _tfUsername.layer.borderWidth = 1.5f;
    _tfUsername.layer.cornerRadius = 5.0f;
    [self.view addSubview:_tfUsername];
    
    [_btnForward mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view).with.offset(31.2);
        make.right.equalTo(self.view).with.offset(-20.8);
        make.width.equalTo(@45.3);
        make.height.equalTo(@45.3);
    }];
    
    [_imageViewLogo mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view).with.offset(75.0);
        make.centerX.equalTo(self.view.mas_centerX);
        make.width.equalTo(@97.7);
        make.height.equalTo(@97.7);
    }];
    
    [_lbSignup mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_imageViewLogo.mas_bottom).with.offset(36.3);
        make.centerX.equalTo(self.view.mas_centerX);
    }];
    
    [_tfEmail mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_lbSignup.mas_bottom).with.offset(36.6);
        make.left.equalTo(self.view).with.offset(21.0);
        make.right.equalTo(self.view).with.offset(-21.0);
        make.height.equalTo(@60.0);
    }];
    
    [_tfPassword mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_tfEmail.mas_bottom).with.offset(14.2);
        make.left.equalTo(self.view).with.offset(21.0);
        make.right.equalTo(self.view).with.offset(-21.0);
        make.height.equalTo(@60.0);
    }];
    
    [_tfUsername mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_tfPassword.mas_bottom).with.offset(14.2);
        make.left.equalTo(self.view).with.offset(21.0);
        make.right.equalTo(self.view).with.offset(-21.0);
        make.height.equalTo(@60.0);
    }];
    
    _swipeGestureRecognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipeHandler:)];
    _swipeGestureRecognizer.delegate = self;
    [self.view addGestureRecognizer:_swipeGestureRecognizer];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - action
- (void)forward:(id)sender {
    
}

#pragma mark - gesture handler
- (void)swipeHandler:(UISwipeGestureRecognizer *)gesture {
    if (gesture.direction == UISwipeGestureRecognizerDirectionRight) {
        [self.navigationController popViewControllerAnimated:YES];
    }
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
