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

@interface BLSignupViewController () <UIGestureRecognizerDelegate, UITextFieldDelegate>

@property (retain, nonatomic) UIImageView *background;

@property (retain, nonatomic) UIButton *btnBack;
@property (retain, nonatomic) UIButton *btnForward;

@property (retain, nonatomic) UIImageView *imageViewLogo;

@property (retain, nonatomic) UILabel *lbSignup;
@property (retain, nonatomic) BLTextField *tfEmail;
@property (retain, nonatomic) BLTextField *tfPassword;
@property (retain, nonatomic) BLTextField *tfUsername;
@property (retain, nonatomic) UIButton *btnSignup;

@property (retain, nonatomic) UILabel *lbErrorMsg;

@property (retain, nonatomic) UISwipeGestureRecognizer *swipeGestureRecognizer;
@property (retain, nonatomic) UITapGestureRecognizer *tapGestureRecognizer;

@end

@implementation BLSignupViewController

static const NSInteger INDEX_USERNAME = 0;
static const NSInteger INDEX_EMAIL = 1;
static const NSInteger INDEX_PASSWORD = 2;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    _background = [[UIImageView alloc] initWithFrame:self.view.frame];
    _background.image = [UIImage imageNamed:@"wel_background.png"];
    [self.view addSubview:_background];
    
//    _btnForward = [[UIButton alloc] init];
//    [_btnForward setBackgroundImage:[UIImage imageNamed:@"forward_icon.png"] forState:UIControlStateNormal];
//    [_btnForward addTarget:self action:@selector(forward:) forControlEvents:UIControlEventTouchDown];
//    [self.view addSubview:_btnForward];
    
    _btnBack = [[UIButton alloc] init];
    [_btnBack setBackgroundImage:[UIImage imageNamed:@"back_icon.png"] forState:UIControlStateNormal];
    [_btnBack addTarget:self action:@selector(back:) forControlEvents:UIControlEventTouchDown];
    [self.view addSubview:_btnBack];
    
    _imageViewLogo = [[UIImageView alloc] init];
    _imageViewLogo.image = [UIImage imageNamed:@"logo.png"];
    [self.view addSubview:_imageViewLogo];
    
    _lbSignup = [[UILabel alloc] init];
    _lbSignup.text = NSLocalizedString(@"SIGN UP", nil);
    _lbSignup.textColor = [BLColorDefinition grayColor];
    [self.view addSubview:_lbSignup];
    
    _tfEmail = [[BLTextField alloc] init];
    _tfEmail.textColor = [UIColor whiteColor];
    _tfEmail.font = [UIFont fontWithName:@"ArialMT" size:15];
    _tfEmail.placeholder = NSLocalizedString(@"Email", nil);
    _tfEmail.backgroundColor = [UIColor clearColor];
    _tfEmail.textAlignment = NSTextAlignmentCenter;
    _tfEmail.layer.borderColor = [[BLColorDefinition grayColor] CGColor];
    _tfEmail.layer.borderWidth = 1.5f;
    _tfEmail.layer.cornerRadius = 5.0f;
    _tfEmail.keyboardType = UIKeyboardTypeEmailAddress;
    _tfEmail.tag = INDEX_EMAIL;
    _tfEmail.delegate = self;
    [self.view addSubview:_tfEmail];
    
    _tfPassword = [[BLTextField alloc] init];
    _tfPassword.textColor = [UIColor whiteColor];
    _tfPassword.font = [UIFont fontWithName:@"ArialMT" size:15];
    _tfPassword.placeholder = NSLocalizedString(@"Password", nil);
    _tfPassword.backgroundColor = [UIColor clearColor];
    _tfPassword.textAlignment = NSTextAlignmentCenter;
    _tfPassword.layer.borderColor = [[BLColorDefinition grayColor] CGColor];
    _tfPassword.layer.borderWidth = 1.5f;
    _tfPassword.layer.cornerRadius = 5.0f;
    _tfPassword.tag = INDEX_PASSWORD;
    _tfPassword.delegate = self;
    [self.view addSubview:_tfPassword];
    
    _tfUsername = [[BLTextField alloc] init];
    _tfUsername.textColor = [UIColor whiteColor];
    _tfUsername.font = [UIFont fontWithName:@"ArialMT" size:15];
    _tfUsername.placeholder = NSLocalizedString(@"Username", nil);
    _tfUsername.backgroundColor = [UIColor clearColor];
    _tfUsername.textAlignment = NSTextAlignmentCenter;
    _tfUsername.layer.borderColor = [[BLColorDefinition grayColor] CGColor];
    _tfUsername.layer.borderWidth = 1.5f;
    _tfUsername.layer.cornerRadius = 5.0f;
    _tfUsername.tag = INDEX_USERNAME;
    _tfUsername.delegate = self;
    [self.view addSubview:_tfUsername];
    
    _btnSignup = [[UIButton alloc] init];
    [_btnSignup addTarget:self action:@selector(signup:) forControlEvents:UIControlEventTouchDown];
    [_btnSignup setTitle:NSLocalizedString(@"Sign up", nil) forState:UIControlStateNormal];
    [_btnSignup setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    _btnSignup.titleLabel.font = [UIFont fontWithName:@"Arial-BoldMT" size:16];
    _btnSignup.backgroundColor = [UIColor colorWithRed:93.0 / 255.0 green:112.0 / 255.0 blue:129.0 / 255.0 alpha:1];
    _btnSignup.layer.cornerRadius = 5;
    [self.view addSubview:_btnSignup];
    
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
    
    [self normalLayout];
    
    // Add Gesture
    _swipeGestureRecognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipeHandler:)];
    _swipeGestureRecognizer.delegate = self;
    [self.view addGestureRecognizer:_swipeGestureRecognizer];
    
    _tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapHandler:)];
    _tapGestureRecognizer.delegate = self;
    [self.view addGestureRecognizer:_tapGestureRecognizer];
    
    // Add Keyboard Notification
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillShow:)
                                                 name:UIKeyboardWillShowNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillBeHidden:)
                                                 name:UIKeyboardWillHideNotification object:nil];
}

- (void)normalLayout {
    
    //    [_btnForward mas_makeConstraints:^(MASConstraintMaker *make) {
    //        make.top.equalTo(self.view).with.offset(31.2);
    //        make.right.equalTo(self.view).with.offset(-20.8);
    //        make.width.equalTo(@45.3);
    //        make.height.equalTo(@45.3);
    //    }];
    
    [_btnBack mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view).with.offset(31.2);
        make.leading.equalTo(self.view).with.offset(20.8);
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
    
    [_btnSignup mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.view).with.offset(-20.7);
        make.left.equalTo(self.view).with.offset(21.0);
        make.right.equalTo(self.view).with.offset(-21.0);
        make.height.equalTo(@60.0);
    }];
    
    [_lbErrorMsg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view.mas_centerX);
        make.centerY.equalTo(self.view.mas_centerY);
        make.width.equalTo(@200);
        make.height.equalTo(@100);
    }];
}

- (void)keyboardShownLayout {
    [_imageViewLogo mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view).with.offset(25.0);
    }];
    
    [_lbSignup mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_imageViewLogo.mas_bottom).with.offset(16.3);
    }];
    
    [_tfEmail mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_lbSignup.mas_bottom).with.offset(16.3);
    }];
}

- (void)keyboardHiddenLayout {
    [_imageViewLogo mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view).with.offset(75.0);
    }];
    
    [_lbSignup mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_imageViewLogo.mas_bottom).with.offset(36.3);
    }];
    
    [_tfEmail mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_lbSignup.mas_bottom).with.offset(36.6);
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - action
- (void)forward:(id)sender {
    
}

- (void)back:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)signup:(id)sender {
    NSString *errMsg = @"";
    errMsg = [self validateInput:_tfEmail];
    if (errMsg) {
        _lbErrorMsg.text = errMsg;
        [self showErrorMessage];
        return;
    }
    
    errMsg = [self validateInput:_tfUsername];
    if (errMsg) {
        _lbErrorMsg.text = errMsg;
        [self showErrorMessage];
        return;
    }
    
    errMsg = [self validateInput:_tfPassword];
    if (errMsg) {
        _lbErrorMsg.text = errMsg;
        [self showErrorMessage];
        return;
    }
    
    User *user = [User new];
    user.email = _tfEmail.text;
    user.username = _tfUsername.text;
    user.password = _tfPassword.text;
    
    BLHTTPClient *httpClient = [BLHTTPClient sharedBLHTTPClient];
    [httpClient signup:user success:^(NSURLSessionDataTask *task, id responseObject) {
        User *user = responseObject;
        NSLog(@"Sign up success!!! user id: %@", user.id);
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        _lbErrorMsg.text = @"Sorry we failed to set up your account. Please try again.";
        [self showErrorMessage];
    }];
}

#pragma mark - Text field delegate
//- (void)textFieldDidEndEditing:(UITextField *)textField {
//    NSString *errMsg = [self validateInput:textField];
//    if (errMsg) {
//        _lbErrorMsg.text = errMsg;
//        _lbErrorMsg.alpha = 1.0f;
//    } else {
//        _lbErrorMsg.text = nil;
//        _lbErrorMsg.alpha = 0.0f;
//    }
//}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return YES;
}

#pragma mark - gesture handler
- (void)swipeHandler:(UISwipeGestureRecognizer *)gesture {
    if (gesture.direction == UISwipeGestureRecognizerDirectionRight) {
        [self.navigationController popViewControllerAnimated:YES];
    }
}

- (void)tapHandler:(UITapGestureRecognizer *)gesture {
    [_tfEmail resignFirstResponder];
    [_tfUsername resignFirstResponder];
    [_tfPassword resignFirstResponder];
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

#pragma make - private
- (NSString *)validateInput:(UITextField *)textField {
    switch (textField.tag) {
        case INDEX_USERNAME:
            return [User validateUsername:textField.text];
            break;
        case INDEX_PASSWORD:
            return [User validatePassword:textField.text];
            break;
        case INDEX_EMAIL:
            if (![User isEmailValid:textField.text]) {
                return @"Email is not valid.";
            }
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


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
