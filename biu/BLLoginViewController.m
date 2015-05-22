//
//  BLLoginViewController.m
//  biu
//
//  Created by Tony Wu on 5/18/15.
//  Copyright (c) 2015 BiuLove. All rights reserved.
//

#import "BLLoginViewController.h"
#import "BLTextField.h"
#import "BLColorDefinition.h"

#import "Masonry.h"

@interface BLLoginViewController () <UIGestureRecognizerDelegate>

@property (retain, nonatomic) UIImageView *background;

@property (retain, nonatomic) UIButton *btnBack;
@property (retain, nonatomic) UIButton *btnForward;

@property (retain, nonatomic) UIImageView *imageViewLogo;

@property (retain, nonatomic) UILabel *lbLogin;
@property (retain, nonatomic) BLTextField *tfUsername;
@property (retain, nonatomic) BLTextField *tfPassword;
@property (retain, nonatomic) UIButton *btnForgotPw;
@property (retain, nonatomic) UILabel *lbLoginWith;

@property (retain, nonatomic) UIButton *btnLogin;
@property (retain, nonatomic) UIButton *btnLoginWithTwitter;
@property (retain, nonatomic) UIButton *btnLoginWithFacebook;

@property (retain, nonatomic) UISwipeGestureRecognizer *swipeGestureRecognizer;


@end

@implementation BLLoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _background = [[UIImageView alloc] initWithFrame:self.view.frame];
    _background.image = [UIImage imageNamed:@"wel_background.png"];
    [self.view addSubview:_background];
    
//    _btnForward = [[UIButton alloc] init];
//    [_btnForward setBackgroundImage:[UIImage imageNamed:@"forward_icon.png"] forState:UIControlStateNormal];
//    [_btnForward addTarget:self action:@selector(back:) forControlEvents:UIControlEventTouchDown];
//    [self.view addSubview:_btnForward];
    
    _btnBack = [[UIButton alloc] init];
    [_btnBack setBackgroundImage:[UIImage imageNamed:@"back_icon.png"] forState:UIControlStateNormal];
    [_btnBack addTarget:self action:@selector(back:) forControlEvents:UIControlEventTouchDown];
    [self.view addSubview:_btnBack];
    
    _imageViewLogo = [[UIImageView alloc] init];
    _imageViewLogo.image = [UIImage imageNamed:@"logo.png"];
    [self.view addSubview:_imageViewLogo];
    
    _lbLogin = [[UILabel alloc] init];
    _lbLogin.text = NSLocalizedString(@"LOG IN", nil);
    _lbLogin.textColor = [BLColorDefinition grayColor];
    [self.view addSubview:_lbLogin];
    
    _tfUsername = [[BLTextField alloc] init];
    _tfUsername.placeholder = NSLocalizedString(@"Username", nil);
    _tfUsername.backgroundColor = [UIColor clearColor];
    _tfUsername.textAlignment = NSTextAlignmentCenter;
    _tfUsername.layer.borderColor = [[BLColorDefinition grayColor] CGColor];
    _tfUsername.layer.borderWidth = 2.0f;
    _tfUsername.layer.cornerRadius = 5.0f;
    [self.view addSubview:_tfUsername];
    
    _tfPassword = [[BLTextField alloc] init];
    _tfPassword.placeholder = NSLocalizedString(@"Password", nil);
    _tfPassword.backgroundColor = [UIColor clearColor];
    _tfPassword.textAlignment = NSTextAlignmentCenter;
    _tfPassword.layer.borderColor = [[BLColorDefinition grayColor] CGColor];
    _tfPassword.layer.borderWidth = 2.0f;
    _tfPassword.layer.cornerRadius = 5.0f;
    [self.view addSubview:_tfPassword];
    
    _btnForgotPw = [[UIButton alloc] init];
    _btnForgotPw.titleLabel.font = [UIFont fontWithName:@"ArialMT" size:12];
    [_btnForgotPw setTitle:NSLocalizedString(@"Forgot Password?", nil) forState:UIControlStateNormal];
    [_btnForgotPw setTitleColor:[BLColorDefinition grayColor] forState:UIControlStateNormal];
    [_btnForgotPw addTarget:self action:@selector(forgotPassword:) forControlEvents:UIControlEventTouchDown];
    [self.view addSubview:_btnForgotPw];
    
    _btnLogin = [[UIButton alloc] init];
    [_btnLogin addTarget:self action:@selector(login:) forControlEvents:UIControlEventTouchDown];
    _btnLogin.titleLabel.font = [UIFont fontWithName:@"Arial-BoldMT" size:16];
    [_btnLogin setTitle:NSLocalizedString(@"Login", nil) forState:UIControlStateNormal];
    [_btnLogin setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    _btnLogin.backgroundColor = [UIColor colorWithRed:93.0 / 255.0 green:112.0 / 255.0 blue:129.0 / 255.0 alpha:1];
    _btnLogin.layer.cornerRadius = 5.0f;
    [self.view addSubview:_btnLogin];
    
    _lbLoginWith = [[UILabel alloc] init];
    _lbLoginWith.font = [UIFont fontWithName:@"ArialMT" size:12];
    _lbLoginWith.text = NSLocalizedString(@"OR", nil);
    _lbLoginWith.textColor = [BLColorDefinition grayColor];
    _lbLoginWith.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:_lbLoginWith];
    
    _btnLoginWithTwitter = [[UIButton alloc] init];
    [_btnLoginWithTwitter addTarget:self action:@selector(loginWithTwitter:) forControlEvents:UIControlEventTouchDown];
    _btnLoginWithTwitter.titleLabel.font = [UIFont fontWithName:@"Arial-BoldMT" size:16];
    _btnLoginWithTwitter.titleLabel.textColor = [UIColor whiteColor];
    [_btnLoginWithTwitter setTitle:@"Twitter" forState:UIControlStateNormal];
    _btnLoginWithTwitter.backgroundColor = [BLColorDefinition twitterBlueColor];
    _btnLoginWithTwitter.layer.cornerRadius = 5;
    [self.view addSubview:_btnLoginWithTwitter];
    
    _btnLoginWithFacebook = [[UIButton alloc] init];
    [_btnLoginWithFacebook addTarget:self action:@selector(loginWithFacebook:) forControlEvents:UIControlEventTouchDown];
    _btnLoginWithFacebook.titleLabel.font = [UIFont fontWithName:@"Arial-BoldMT" size:16];
    _btnLoginWithFacebook.titleLabel.textColor = [UIColor whiteColor];
    [_btnLoginWithFacebook setTitle:@"Facebook" forState:UIControlStateNormal];
    _btnLoginWithFacebook.backgroundColor = [BLColorDefinition facebookBlueColor];
    _btnLoginWithFacebook.layer.cornerRadius = 5;
    [self.view addSubview:_btnLoginWithFacebook];
    
//    [_btnForward mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.equalTo(self.view).with.offset(31.2);
//        make.right.equalTo(self.view).with.offset(-20.8);
//        make.width.equalTo(@45.3);
//        make.height.equalTo(@45.3);
//    }];
    
    [_btnBack mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view).with.offset(31.2);
        make.left.equalTo(self.view).with.offset(20.8);
        make.width.equalTo(@45.3);
        make.height.equalTo(@45.3);
    }];
    
    [_imageViewLogo mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view).with.offset(75.0);
        make.centerX.equalTo(self.view.mas_centerX);
        make.width.equalTo(@97.7);
        make.height.equalTo(@97.7);
    }];
    
    [_lbLogin mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_imageViewLogo.mas_bottom).with.offset(36.3);
        make.centerX.equalTo(self.view.mas_centerX);
    }];
    
    [_tfUsername mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_lbLogin.mas_bottom).with.offset(36.6);
        make.left.equalTo(self.view).with.offset(21.0);
        make.right.equalTo(self.view).with.offset(-21.0);
        make.height.equalTo(@50.0);
    }];
    
    [_tfPassword mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_tfUsername.mas_bottom).with.offset(14.2);
        make.left.equalTo(self.view).with.offset(21.0);
        make.right.equalTo(self.view).with.offset(-21.0);
        make.height.equalTo(@50.0);
    }];
    
    [_btnForgotPw mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_tfPassword.mas_bottom).with.offset(10.0);
//        make.centerX.equalTo(self.view.mas_centerX);
        make.right.equalTo(self.view).with.offset(-20.0);
    }];
    
    [_btnLoginWithFacebook mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.view).with.offset(-20.7);
        make.left.equalTo(self.view).with.offset(21.0);
        make.right.equalTo(self.view).with.offset(-21.0);
        make.height.equalTo(@50.0);
    }];
    
    [_btnLoginWithTwitter mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(_btnLoginWithFacebook.mas_top).with.offset(-13.0);
        make.left.equalTo(self.view).with.offset(21.0);
        make.right.equalTo(self.view).with.offset(-21.0);
        make.height.equalTo(@50.0);
    }];
    
    [_lbLoginWith mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(_btnLoginWithTwitter.mas_top).with.offset(-10.0);
        make.left.equalTo(self.view).with.offset(21.0);
        make.right.equalTo(self.view).with.offset(-21.0);
    }];
    
    [_btnLogin mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(_lbLoginWith.mas_top).with.offset(-10.0);
        make.left.equalTo(self.view).with.offset(21.0);
        make.right.equalTo(self.view).with.offset(-21.0);
        make.height.equalTo(@50.0);
    }];
    
    _swipeGestureRecognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipeHandler:)];
    _swipeGestureRecognizer.delegate = self;
    [self.view addGestureRecognizer:_swipeGestureRecognizer];
    
    if ([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
        self.navigationController.interactivePopGestureRecognizer.enabled = YES;
        self.navigationController.interactivePopGestureRecognizer.delegate = self;
    }
}


#pragma button action
- (void)back:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)forward:(id)sender {
    
}

- (void)login:(id)sender {
    
}

- (void)forgotPassword:(id)sender {
    
}

- (void)loginWithTwitter:(id)sender {
    
}

- (void)loginWithFacebook:(id)sender {
    
}

#pragma gesture handler
- (void)swipeHandler:(UISwipeGestureRecognizer *)recognizer {
    if (recognizer.direction == UISwipeGestureRecognizerDirectionRight) {
        [self.navigationController popViewControllerAnimated:YES];
    }
    NSLog(@"Swipe received.");
}


@end
