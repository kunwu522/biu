//
//  BLLoginViewController.m
//  biu
//
//  Created by Tony Wu on 5/18/15.
//  Copyright (c) 2015 BiuLove. All rights reserved.
//

#import "BLLoginViewController.h"
#import "BLWelcomeViewController.h"
#import "AppDelegate.h"
#import "BLTextField.h"
#import "BLColorDefinition.h"

#import "Masonry.h"

@interface BLLoginViewController () <UIGestureRecognizerDelegate>

@property (retain, nonatomic) UIImageView *background;

@property (retain, nonatomic) UIButton *btnBack;
@property (retain, nonatomic) UIButton *btnForward;

@property (retain, nonatomic) UIImageView *imageViewLogo;

@property (retain, nonatomic) UILabel *lbLogin;
@property (retain, nonatomic) BLTextField *tfEmail;
@property (retain, nonatomic) BLTextField *tfPassword;
@property (retain, nonatomic) UIButton *btnForgotPw;
@property (retain, nonatomic) UILabel *lbLoginWith;

@property (retain, nonatomic) UIButton *btnLogin;
@property (retain, nonatomic) UIButton *btnLoginWithTwitter;
@property (retain, nonatomic) UIButton *btnLoginWithFacebook;

@property (retain, nonatomic) UILabel *lbErrorMsg;

@property (retain, nonatomic) UISwipeGestureRecognizer *swipeGestureRecognizer;
@property (retain, nonatomic) UITapGestureRecognizer *tapGestureRecognizer;

@end

@implementation BLLoginViewController

static const NSInteger TAG_EMAIL = 0;
static const NSInteger TAG_PASSWORD = 1;

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
    
    _tfEmail = [[BLTextField alloc] init];
    _tfEmail.placeholder = NSLocalizedString(@"Email", nil);
    _tfEmail.backgroundColor = [UIColor clearColor];
    _tfEmail.textAlignment = NSTextAlignmentCenter;
    _tfEmail.textColor = [UIColor whiteColor];
    _tfEmail.layer.borderColor = [[BLColorDefinition grayColor] CGColor];
    _tfEmail.layer.borderWidth = 2.0f;
    _tfEmail.layer.cornerRadius = 5.0f;
    _tfEmail.tag = TAG_EMAIL;
    [self.view addSubview:_tfEmail];
    
    _tfPassword = [[BLTextField alloc] init];
    _tfPassword.placeholder = NSLocalizedString(@"Password", nil);
    _tfPassword.backgroundColor = [UIColor clearColor];
    _tfPassword.textAlignment = NSTextAlignmentCenter;
    _tfPassword.textColor = [UIColor whiteColor];
    _tfPassword.layer.borderColor = [[BLColorDefinition grayColor] CGColor];
    _tfPassword.layer.borderWidth = 2.0f;
    _tfPassword.layer.cornerRadius = 5.0f;
    _tfPassword.tag = TAG_PASSWORD;
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
    
    _lbErrorMsg = [[UILabel alloc] init];
    _lbErrorMsg.backgroundColor = [UIColor blackColor];
    _lbErrorMsg.textColor = [UIColor whiteColor];
    _lbErrorMsg.font = [UIFont fontWithName:@"Arial-BoldMT" size:14];
    _lbErrorMsg.alpha = 0.0f;
    _lbErrorMsg.textAlignment = NSTextAlignmentCenter;
    _lbErrorMsg.numberOfLines = 0;
    _lbErrorMsg.layer.cornerRadius = 8.0f;
    _lbErrorMsg.clipsToBounds = YES;
    [self.view addSubview:_lbErrorMsg];
    
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
    
    [_tfEmail mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_lbLogin.mas_bottom).with.offset(36.6);
        make.left.equalTo(self.view).with.offset(21.0);
        make.right.equalTo(self.view).with.offset(-21.0);
        make.height.equalTo(@50.0);
    }];
    
    [_tfPassword mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_tfEmail.mas_bottom).with.offset(14.2);
        make.left.equalTo(self.view).with.offset(21.0);
        make.right.equalTo(self.view).with.offset(-21.0);
        make.height.equalTo(@50.0);
    }];
    
    [_btnForgotPw mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_tfPassword.mas_bottom).with.offset(10.0);
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
    
    [_lbErrorMsg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view.mas_centerX);
        make.centerY.equalTo(self.view.mas_centerY);
        make.width.equalTo(@200);
        make.height.equalTo(@100);
    }];
    
    _swipeGestureRecognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipeHandler:)];
    _swipeGestureRecognizer.delegate = self;
    [self.view addGestureRecognizer:_swipeGestureRecognizer];
    
    _tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapHandler:)];
    _tapGestureRecognizer.delegate = self;
    [self.view addGestureRecognizer:_tapGestureRecognizer];
    
    if ([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
        self.navigationController.interactivePopGestureRecognizer.enabled = YES;
        self.navigationController.interactivePopGestureRecognizer.delegate = self;
    }
    
    // Add Keyboard Notification
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillShow:)
                                                 name:UIKeyboardWillShowNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillBeHidden:)
                                                 name:UIKeyboardWillHideNotification object:nil];
}

- (void)keyboardShownLayout {
    [_lbLogin mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_imageViewLogo.mas_bottom).with.offset(26.3);
    }];
    
    [_tfEmail mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_lbLogin.mas_bottom).with.offset(26.3);
    }];
}

- (void)keyboardHiddenLayout {
    [_lbLogin mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_imageViewLogo.mas_bottom).with.offset(36.3);
    }];
    
    [_tfEmail mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_lbLogin.mas_bottom).with.offset(36.6);
    }];
}


#pragma button action
- (void)back:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)forward:(id)sender {
    
}

- (void)login:(id)sender {
    NSString *errMsg = [self validateInput:_tfEmail];
    if (errMsg) {
        _lbErrorMsg.text = errMsg;
        [self showErrorMessage];
        return;
    }
    
    User *user = [User new];
    user.email = _tfEmail.text;
    user.password = _tfPassword.text;
    
    BLHTTPClient *httpClient = [BLHTTPClient sharedBLHTTPClient];
    [httpClient login:user success:^(NSURLSessionDataTask *task, id responseObject) {
        NSLog(@"Response: %@", responseObject);
        User *user = responseObject;
        [self renderToMasterViewController];
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        _lbErrorMsg.text = @"Email or Password is not match.";
        [self showErrorMessage];
    }];
}

- (void)forgotPassword:(id)sender {
    
}

- (void)loginWithTwitter:(id)sender {
    
}

- (void)loginWithFacebook:(id)sender {
    
}

#pragma mark - handle notifaction
- (void)keyboardWillShow:(NSNotification *)aNotifcation {
    [self keyboardShownLayout];
    [UIView animateWithDuration:0.2f animations:^{
        [self.view layoutIfNeeded];
    }];
}

- (void)keyboardWillBeHidden:(NSNotification *)aNotifcaion {
    [self keyboardHiddenLayout];
    [UIView animateWithDuration:0.2f animations:^{
        [self.view layoutIfNeeded];
    }];
}

#pragma mark - gesture handler
- (void)swipeHandler:(UISwipeGestureRecognizer *)recognizer {
    if (recognizer.direction == UISwipeGestureRecognizerDirectionRight) {
        [self.navigationController popViewControllerAnimated:YES];
    }
    NSLog(@"Swipe received.");
}

- (void)tapHandler:(UITapGestureRecognizer *)gesture {
    [_tfEmail resignFirstResponder];
    [_tfPassword resignFirstResponder];
}

#pragma mark - private
- (NSString *)validateInput:(UITextField *)textField {
    if (!textField) {
        return @"Some error, please try later.";
    }
    
    switch (textField.tag) {
        case TAG_EMAIL:
            if (![User isEmailValid:textField.text]) {
                return @"Please input valid email.";
            }
            break;
            
        case TAG_PASSWORD:
            // TODO
            break;
        default:
            break;
    }
    
    return nil;
}

- (void)showErrorMessage {
    [UIView animateWithDuration:0.2f animations:^{
        _lbErrorMsg.alpha = 0.8f;
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:0.2f delay:2.0f options:UIViewAnimationOptionLayoutSubviews animations:^{
            _lbErrorMsg.alpha = 0.0f;
        } completion:^(BOOL finished) {
            ;
        }];
    }];
}

- (void)renderToMasterViewController {
    AppDelegate *delegate = [[UIApplication sharedApplication] delegate];
    [self presentViewController:delegate.masterNavController animated:YES completion:nil];
}


@end
