//
//  ViewController.m
//  biu
//
//  Created by Tony Wu on 5/5/15.
//  Copyright (c) 2015 BiuLove. All rights reserved.
//

#import "BLWelcomeViewController.h"
#import "AppDelegate.h"
#import "KeychainItemWrapper.h"
#import "Masonry.h"

#import "BLTextField.h"
#import "BlurView.h"


@interface BLWelcomeViewController ()

@property (retain, nonatomic) KeychainItemWrapper *passwordItem;

@property (retain, nonatomic) UIImageView * logo;
@property (retain, nonatomic) UILabel * biuTitle;
@property (retain, nonatomic) UILabel * biuSubtitle;

//For login view
@property (retain, nonatomic) BLTextField * txtUsername;
@property (retain, nonatomic) BLTextField * txtPassword;
@property (retain, nonatomic) UILabel *lbLoginWith;
@property (retain, nonatomic) UIButton *btnLoginWithWeChat;
@property (retain, nonatomic) UIButton *btnLoginWithSina;

@property (retain, nonatomic) UIView *background;
@property (retain, nonatomic) UIImageView *imageView;
@property (retain, nonatomic) BlurView *blurView;

@end

@implementation BLWelcomeViewController

static double ICON_INITIAL_SIZE = 150;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    self.view.backgroundColor = [UIColor clearColor];
    
    _background = [[UIView alloc] initWithFrame:self.view.frame];
    _imageView = [[UIImageView alloc] initWithFrame:_background.frame];
    _imageView.image = [UIImage imageNamed:@"wel_background.png"];
    _imageView.contentMode = UIViewContentModeScaleAspectFill;
    [_background addSubview:_imageView];
    [self.view addSubview:_background];
    
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
    sleep(2);
    
    if ([self checkUserLogin]) {
        //TODO: go to major view
    } else {
        [self loginViewLayout];
        [UIView animateWithDuration:0.5 animations:^{
            [self.view layoutIfNeeded];
            _biuSubtitle.alpha = 0;
        } completion:^(BOOL finished) {
            // TODO: show login input and button
            [UIView animateWithDuration:0.5 animations:^{
                _txtUsername.alpha = 1;
                _txtPassword.alpha = 1;
                _lbLoginWith.alpha = 1;
                _btnLoginWithWeChat.alpha = 1;
                _btnLoginWithSina.alpha = 1;
            }];
        }];
    }
}

- (BOOL)checkUserLogin {
    AppDelegate *delegate = [[UIApplication sharedApplication] delegate];
    _passwordItem = delegate.passwordItem;
    
    NSString *username = [_passwordItem objectForKey:(__bridge id)kSecAttrAccount];
    NSString *password = [_passwordItem objectForKey:(__bridge id)kSecValueData];
    
    if ([username isEqualToString:@""] || [password isEqualToString:@""]) {
        return NO;
    }
    
    //TODO: validate username&password by connection with server
    
    
    return YES;
}

- (void)login {
    
}

- (void)signup {
    
}

- (void)loginViewLayout {
    [_logo mas_updateConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.view.mas_centerY).with.offset(-150);
        make.height.equalTo(@100);
        make.width.equalTo(@100);
    }];
    
    [_biuTitle mas_updateConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(_logo.mas_bottom).with.offset(40);
    }];
    
    _txtUsername = [[BLTextField alloc] init];
    _txtUsername.font = [UIFont fontWithName:@"ArialMT" size:14];
    _txtUsername.placeholder = @"Email";
    _txtUsername.alpha = 0;
    _txtUsername.autocorrectionType = UITextAutocorrectionTypeNo;
    _txtUsername.textColor = [UIColor grayColor];
    [self.view addSubview:_txtUsername];
    
    _txtPassword = [[BLTextField alloc] init];
    _txtPassword.font = [UIFont fontWithName:@"ArialMt" size:14];
    _txtPassword.placeholder = @"Password";
    _txtPassword.alpha = 0;
    _txtPassword.autocorrectionType = UITextAutocorrectionTypeNo;
    _txtPassword.textColor = [UIColor grayColor];
    _txtPassword.secureTextEntry = YES;
    [self.view addSubview:_txtPassword];
    
    _lbLoginWith = [[UILabel alloc] init];
    _lbLoginWith.text = @"LOGIN WITH:";
    _lbLoginWith.font = [UIFont fontWithName:@"ArialMT" size:14];
    _lbLoginWith.textColor = [UIColor grayColor];
    _lbLoginWith.textAlignment = NSTextAlignmentCenter;
    _lbLoginWith.adjustsFontSizeToFitWidth = YES;
    [self.view addSubview:_lbLoginWith];
    _lbLoginWith.alpha = 0;
    
    _btnLoginWithWeChat = [[UIButton alloc] init];
    [_btnLoginWithWeChat addTarget:self action:@selector(loginWithWeChat:) forControlEvents:UIControlEventTouchDown];
    [_btnLoginWithWeChat setTitle:@"WeChat" forState:UIControlStateNormal];
    _btnLoginWithWeChat.titleLabel.font = [UIFont fontWithName:@"Arial-BoldMT" size:18];
    _btnLoginWithWeChat.titleLabel.textColor = [UIColor whiteColor];
    _btnLoginWithWeChat.backgroundColor = [UIColor colorWithRed:112.0 / 255.0 green:194.0 / 255.0 blue:114.0 / 255.0 alpha:1];
    _btnLoginWithWeChat.layer.cornerRadius = 5;
    [self.view addSubview:_btnLoginWithWeChat];
    _btnLoginWithWeChat.alpha = 0;
    
    _btnLoginWithSina = [[UIButton alloc] init];
    [_btnLoginWithSina addTarget:self action:@selector(loginWithSina:) forControlEvents:UIControlEventTouchDown];
    [_btnLoginWithSina setTitle:@"Sina Webo" forState:UIControlStateNormal];
    _btnLoginWithSina.titleLabel.font = [UIFont fontWithName:@"Arial-BoldMT" size:18];
    _btnLoginWithSina.titleLabel.textColor = [UIColor whiteColor];
    _btnLoginWithSina.backgroundColor = [UIColor colorWithRed:241.0 / 255.0 green:109.0 / 255.0 blue:111.0 / 255.0 alpha:1];
    _btnLoginWithSina.layer.cornerRadius = 5;
    [self.view addSubview:_btnLoginWithSina];
    _btnLoginWithSina.alpha = 0;
    
    [_txtUsername mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_biuTitle.mas_bottom).with.offset(30);
        make.left.equalTo(_txtUsername.superview).with.offset(50);
        make.right.equalTo(_txtUsername.superview).with.offset(-50);
    }];
    
    [_txtPassword mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_txtUsername.mas_bottom).with.offset(20);
        make.left.equalTo(_txtPassword.superview).with.offset(50);
        make.right.equalTo(_txtPassword.superview).with.offset(-50);
    }];
    
    [_btnLoginWithSina mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.view).with.offset(-30);
        make.left.equalTo(self.view).with.offset(20);
        make.right.equalTo(self.view).with.offset(-20);
        make.height.equalTo(@50);
    }];
    
    [_btnLoginWithWeChat mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(_btnLoginWithSina.mas_top).with.offset(-20);
        make.left.equalTo(self.view).with.offset(20);
        make.right.equalTo(self.view).with.offset(-20);
        make.height.equalTo(@50);
    }];
    
    [_lbLoginWith mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(_btnLoginWithWeChat.mas_top).with.offset(-20);
        make.left.equalTo(self.view).with.offset(50);
        make.right.equalTo(self.view).with.offset(-50);
    }];
}

- (void)loginWithWeChat:(id)sender {
    
}

- (void)loginWithSina:(id)sender {
    
}

@end
