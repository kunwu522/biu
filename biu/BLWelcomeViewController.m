//
//  ViewController.m
//  biu
//
//  Created by Tony Wu on 5/5/15.
//  Copyright (c) 2015 BiuLove. All rights reserved.
//

#import "BLWelcomeViewController.h"
#import "AppDelegate.h"
#import "BLLoginViewController.h"
#import "BLSignupViewController.h"
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
@property (retain, nonatomic) UIButton *btnLogin;
@property (retain, nonatomic) UIButton *btnSignup;
@property (retain, nonatomic) UILabel *lbSlogan;

@property (retain, nonatomic) UIView *background;
@property (retain, nonatomic) UIImageView *imageView;
@property (retain, nonatomic) BlurView *blurView;

@property (nonatomic) BOOL isLaunchLayout;


@end

@implementation BLWelcomeViewController

static double ICON_INITIAL_SIZE = 147.5;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    _isLaunchLayout = NO;
    
    self.view.backgroundColor = [UIColor clearColor];
    
    NSLog(@"ViewController size: %f--%f", self.view.frame.size.width, self.view.frame.size.height);
    
    _background = [[UIView alloc] initWithFrame:self.view.frame];
    _imageView = [[UIImageView alloc] initWithFrame:_background.frame];
    _imageView.image = [UIImage imageNamed:@"wel_background.png"];
    _imageView.contentMode = UIViewContentModeScaleAspectFill;
    [_background addSubview:_imageView];
    [self.view addSubview:_background];
    
    //Initial View
    _logo = [[UIImageView alloc] init];
    _logo.image = [UIImage imageNamed:@"logo.png"];
//    _logo.layer.cornerRadius = ICON_INITIAL_SIZE / 2;
//    _logo.layer.masksToBounds = YES;
//    _logo.contentMode = UIViewContentModeScaleAspectFill;
    [self.view addSubview:_logo];
    
    
    _biuTitle = [[UILabel alloc] init];
    _biuTitle.text = @"BIU";
    _biuTitle.font = [UIFont fontWithName:@"Arial-BoldMT" size:45];
    _biuTitle.textColor = [UIColor whiteColor];
    _biuTitle.textAlignment = NSTextAlignmentCenter;
    _biuTitle.adjustsFontSizeToFitWidth = YES;
    [self.view addSubview:_biuTitle];
    
    _biuSubtitle = [[UILabel alloc] init];
    _biuSubtitle.text = @"I ' M   C L O S E";
    _biuSubtitle.font = [UIFont fontWithName:@"Arial-BoldMT" size:15];
    _biuSubtitle.textColor = [UIColor colorWithRed:89.0 / 255.0 green:96.0 / 255.0 blue:104.0 / 255.0 alpha:1];
    _biuSubtitle.textAlignment = NSTextAlignmentCenter;
    _biuSubtitle.adjustsFontSizeToFitWidth = YES;
    [self.view addSubview:_biuSubtitle];
    
    // Create constraints
    [_logo mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view.mas_centerX);
        make.top.equalTo(self.view).with.offset(191.8);
        make.height.equalTo([NSNumber numberWithDouble:ICON_INITIAL_SIZE]);
        make.width.equalTo([NSNumber numberWithDouble:ICON_INITIAL_SIZE]);
    }];
    
    [_biuTitle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(_logo.mas_centerX);
        make.top.equalTo(_logo.mas_bottom).with.offset(79.7);
    }];
    
    [_biuSubtitle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(_logo.mas_centerX);
        make.top.equalTo(_biuTitle.mas_bottom).with.offset(40);
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidAppear:(BOOL)animated {
    sleep(2);
    if (!_isLaunchLayout) {
        if ([self checkUserLogin]) {
            //TODO: go to major view
        } else {
            [self loginViewLayout];
            [UIView animateWithDuration:0.5 animations:^{
                [self.view layoutIfNeeded];
                _biuTitle.transform = CGAffineTransformScale(_biuTitle.transform, 0.67, 0.67);
                _biuSubtitle.alpha = 0;
            } completion:^(BOOL finished) {
                // TODO: show login input and button
                [UIView animateWithDuration:0.5 animations:^{
                    //                _txtUsername.alpha = 1;
                    //                _txtPassword.alpha = 1;
                    //                _lbLoginWith.alpha = 1;
                    _lbSlogan.alpha = 1;
                    _btnLogin.alpha = 1;
                    _btnSignup.alpha = 1;
                }];
            }];
        }
        _isLaunchLayout = YES;
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
        make.top.equalTo(self.view).with.offset(91.7);
        make.height.equalTo(@97.7);
        make.width.equalTo(@97.7);
    }];
    
    [_biuTitle mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_logo.mas_bottom).with.offset(29.5);
    }];
    
//    _txtUsername = [[BLTextField alloc] init];
//    _txtUsername.font = [UIFont fontWithName:@"ArialMT" size:14];
//    _txtUsername.placeholder = @"Email";
//    _txtUsername.alpha = 0;
//    _txtUsername.autocorrectionType = UITextAutocorrectionTypeNo;
//    _txtUsername.textColor = [UIColor grayColor];
//    [self.view addSubview:_txtUsername];
//    
//    _txtPassword = [[BLTextField alloc] init];
//    _txtPassword.font = [UIFont fontWithName:@"ArialMt" size:14];
//    _txtPassword.placeholder = @"Password";
//    _txtPassword.alpha = 0;
//    _txtPassword.autocorrectionType = UITextAutocorrectionTypeNo;
//    _txtPassword.textColor = [UIColor grayColor];
//    _txtPassword.secureTextEntry = YES;
//    [self.view addSubview:_txtPassword];
//    
//    _lbLoginWith = [[UILabel alloc] init];
//    _lbLoginWith.text = @"LOGIN WITH:";
//    _lbLoginWith.font = [UIFont fontWithName:@"ArialMT" size:14];
//    _lbLoginWith.textColor = [UIColor grayColor];
//    _lbLoginWith.textAlignment = NSTextAlignmentCenter;
//    _lbLoginWith.adjustsFontSizeToFitWidth = YES;
//    [self.view addSubview:_lbLoginWith];
//    _lbLoginWith.alpha = 0;
    
    _lbSlogan = [[UILabel alloc] init];
//    _lbSlogan.text = @"We help you to find your perfect one in close distance, and notify you from your new watch";
    _lbSlogan.font = [UIFont fontWithName:@"ArialMT" size:16];
    _lbSlogan.textColor = [UIColor whiteColor];
    _lbSlogan.textAlignment = NSTextAlignmentCenter;
    _lbSlogan.numberOfLines = 0;
//    _lbSlogan.backgroundColor = [UIColor grayColor];
    
    //Set line space
//    NSString *labelText = @"We help you to find your perfect one in close distance, and notify you from your new watch";
    NSString *labelText = NSLocalizedString(@"Slogan", nil);
    NSMutableAttributedString *attrString = [[NSMutableAttributedString alloc] initWithString:labelText];
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    [paragraphStyle setLineSpacing:15];
    [paragraphStyle setAlignment:NSTextAlignmentCenter];
    [attrString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [labelText length])];
    _lbSlogan.attributedText = attrString;
    _lbSlogan.alpha = 0;
    [self.view addSubview:_lbSlogan];
    
    _btnLogin = [[UIButton alloc] init];
    [_btnLogin addTarget:self action:@selector(login:) forControlEvents:UIControlEventTouchDown];
    [_btnLogin setTitle:NSLocalizedString(@"Login", nil) forState:UIControlStateNormal];
    _btnLogin.titleLabel.font = [UIFont fontWithName:@"Arial-BoldMT" size:16];
    _btnLogin.titleLabel.textColor = [UIColor whiteColor];
    _btnLogin.backgroundColor = [UIColor colorWithRed:93.0 / 255.0 green:112.0 / 255.0 blue:129.0 / 255.0 alpha:1];
    _btnLogin.layer.cornerRadius = 5;
    [self.view addSubview:_btnLogin];
    _btnLogin.alpha = 0;
    
    _btnSignup = [[UIButton alloc] init];
    [_btnSignup addTarget:self action:@selector(signup:) forControlEvents:UIControlEventTouchDown];
    [_btnSignup setTitle:NSLocalizedString(@"Sign up", nil) forState:UIControlStateNormal];
    _btnSignup.titleLabel.font = [UIFont fontWithName:@"Arial-BoldMT" size:16];
    _btnSignup.titleLabel.textColor = [UIColor whiteColor];
    _btnSignup.backgroundColor = [UIColor colorWithRed:19.0 / 255.0 green:183.0 / 255.0 blue:120.0 / 255.0 alpha:1];
    _btnSignup.layer.cornerRadius = 5;
    [self.view addSubview:_btnSignup];
    _btnSignup.alpha = 0;
    
//    [_txtUsername mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.equalTo(_biuTitle.mas_bottom).with.offset(30);
//        make.left.equalTo(_txtUsername.superview).with.offset(50);
//        make.right.equalTo(_txtUsername.superview).with.offset(-50);
//    }];
//    
//    [_txtPassword mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.equalTo(_txtUsername.mas_bottom).with.offset(20);
//        make.left.equalTo(_txtPassword.superview).with.offset(50);
//        make.right.equalTo(_txtPassword.superview).with.offset(-50);
//    }];

    [_lbSlogan mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_biuTitle.mas_bottom).with.offset(25.0);
        make.left.equalTo(self.view).with.offset(47.2);
        make.right.equalTo(self.view).with.offset(-47.2);
        make.height.equalTo(@100);
    }];
    
    [_btnSignup mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.view).with.offset(-21.1);
        make.left.equalTo(self.view).with.offset(20.7);
        make.right.equalTo(self.view).with.offset(-20.7);
        make.height.equalTo(@59);
    }];
    
    [_btnLogin mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(_btnSignup.mas_top).with.offset(-13.6);
        make.left.equalTo(self.view).with.offset(20.7);
        make.right.equalTo(self.view).with.offset(-20.7);
        make.height.equalTo(@59);
    }];
    
//    [_lbLoginWith mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.bottom.equalTo(_btnLogin.mas_top).with.offset(-20);
//        make.left.equalTo(self.view).with.offset(50);
//        make.right.equalTo(self.view).with.offset(-50);
//    }];
}

- (void)login:(id)sender {
    BLLoginViewController *loginViewController = [[BLLoginViewController alloc] initWithNibName:nil bundle:nil];
    [self.navigationController pushViewController:loginViewController animated:YES];
}

- (void)signup:(id)sender {
    BLSignupViewController *signupViewController = [[BLSignupViewController alloc] initWithNibName:nil bundle:nil];
    [self.navigationController pushViewController:signupViewController animated:YES];
}

@end
