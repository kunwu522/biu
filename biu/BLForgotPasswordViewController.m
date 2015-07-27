//
//  BLForgotPasswordViewController.m
//  biu
//
//  Created by Tony Wu on 7/23/15.
//  Copyright (c) 2015 BiuLove. All rights reserved.
//

#import "BLForgotPasswordViewController.h"
#import "BLTextField.h"
#import "Masonry.h"

@interface BLForgotPasswordViewController () <UIGestureRecognizerDelegate, UIAlertViewDelegate>

@property (strong, nonatomic) UIImageView *background;
@property (strong, nonatomic) UIImageView *logoImageView;
@property (strong, nonatomic) UILabel *lbTitle;
@property (strong, nonatomic) BLTextField *tfPhone;
@property (strong, nonatomic) BLTextField *tfPasscode;
@property (strong, nonatomic) BLTextField *tfPassword;
@property (strong, nonatomic) UIButton *btnDone;
@property (strong, nonatomic) UIButton *btnClose;
@property (strong, nonatomic) UIButton *btnGetCode;
@property (strong, nonatomic) UITapGestureRecognizer *tapGestureRecognizer;

@property (strong, nonatomic) NSString *code;
@property (strong, nonatomic) NSTimer *timer;
@property (strong, nonatomic) UILabel *lbSecondLeft;
@property (assign, nonatomic) NSInteger secondLeftToResend;

@end

@implementation BLForgotPasswordViewController

static NSInteger const BL_RESET_SUCCESS_ALERTVIEW = 1;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self.view addSubview:self.background];
    [self.view addSubview:self.logoImageView];
    [self.view addSubview:self.tfPhone];
    [self.view addSubview:self.tfPasscode];
    [self.view addSubview:self.tfPassword];
    [self.view addSubview:self.btnDone];
    [self.view addSubview:self.btnClose];
    [self.view addSubview:self.btnGetCode];
    [self.view addSubview:self.lbSecondLeft];
    [self.view addGestureRecognizer:self.tapGestureRecognizer];
    
    [self loadLayout];
    
    self.code = @"";
}

- (void)loadLayout {
    [self.background mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.background.superview);
    }];
    
    [self.logoImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.logoImageView.superview).with.offset([BLGenernalDefinition resolutionForDevices:75.0f]);
        make.centerX.equalTo(self.logoImageView.superview.mas_centerX);
        make.width.height.equalTo([NSNumber numberWithDouble:[BLGenernalDefinition resolutionForDevices:95.0f]]);
    }];
    
    [self.tfPhone mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.logoImageView.mas_bottom).with.offset([BLGenernalDefinition resolutionForDevices:90.0f]);
        make.left.equalTo(self.tfPhone.superview).with.offset([BLGenernalDefinition resolutionForDevices:50.0f]);
        make.right.equalTo(self.tfPhone.superview).with.offset([BLGenernalDefinition resolutionForDevices:-50.0f]);
    }];
    
    [self.tfPasscode mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.tfPhone.mas_bottom).with.offset([BLGenernalDefinition resolutionForDevices:20.0f]);
        make.left.equalTo(self.tfPasscode.superview).with.offset([BLGenernalDefinition resolutionForDevices:50.0f]);
        make.right.equalTo(self.tfPasscode.superview).with.offset([BLGenernalDefinition resolutionForDevices:-50.0f]);
    }];
    
    [self.tfPassword mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.tfPasscode.mas_bottom).with.offset([BLGenernalDefinition resolutionForDevices:20.0f]);
        make.left.equalTo(self.tfPassword.superview).with.offset([BLGenernalDefinition resolutionForDevices:50.0f]);
        make.right.equalTo(self.tfPassword.superview).with.offset([BLGenernalDefinition resolutionForDevices:-50.0f]);
    }];
    
    [self.btnClose mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.btnClose.superview).with.offset([BLGenernalDefinition resolutionForDevices:32.0f]);
        make.left.equalTo(self.btnClose.superview).with.offset([BLGenernalDefinition resolutionForDevices:20.0f]);
        make.width.height.equalTo([NSNumber numberWithDouble:([BLGenernalDefinition resolutionForDevices:20.0f])]);
    }];
    
    [self.btnGetCode mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.tfPhone).with.offset([BLGenernalDefinition resolutionForDevices:5.0f]);
        make.right.equalTo(self.btnGetCode.superview).with.offset([BLGenernalDefinition resolutionForDevices:-50.0f]);
    }];
    
    [self.lbSecondLeft mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.btnGetCode.mas_centerY);
        make.right.equalTo(self.lbSecondLeft.superview).with.offset([BLGenernalDefinition resolutionForDevices:-50.0f]);
    }];
    
    [self.btnDone mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.tfPassword.mas_bottom).with.offset([BLGenernalDefinition resolutionForDevices:66.0f]);
        make.left.equalTo(self.btnDone.superview).with.offset([BLGenernalDefinition resolutionForDevices:127.0f]);
        make.right.equalTo(self.btnDone.superview).with.offset([BLGenernalDefinition resolutionForDevices:-127.0f]);
        make.height.equalTo([NSNumber numberWithDouble:([BLGenernalDefinition resolutionForDevices:30.0f])]);
    }];
}

#pragma mark - Actions
- (void)close:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)getCode:(id)sender {
    NSString *errMsg = [User validatePhoneNumber:self.tfPhone.text];
    if (errMsg) {
        UIAlertView *av = [[UIAlertView alloc] initWithTitle:nil message:errMsg delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil];
        [av show];
        return;
    }
    
    int code = arc4random() % 900000 + 100000;
    self.code = [NSString stringWithFormat:@"%d", code];
    
    //For debug
    NSLog(@"code: %@", _code);
    _secondLeftToResend = 60;
    _lbSecondLeft.text = [NSString stringWithFormat:@"%ld", _secondLeftToResend];
    _btnGetCode.enabled = NO;
    [self showSecondToResend];
    _timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(timerfired) userInfo:nil repeats:YES];
    
//    [[BLHTTPClient sharedBLHTTPClient] passcode:_code phoneNumber:_tfPhone.text success:^(NSURLSessionDataTask *task, id responseObject) {
//        _secondLeftToResend = 60;
//        _lbSecondLeft.text = [NSString stringWithFormat:@"%ld", _secondLeftToResend];
//        _btnGetCode.enabled = NO;
//        [self showSecondToResend];
//        _timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(timerfired) userInfo:nil repeats:YES];
//    } failure:^(NSURLSessionDataTask *task, NSError *error) {
//        NSLog(@"Sending passcode failed, error: %@", error.description);
//        UIAlertView *av = [[UIAlertView alloc] initWithTitle:nil message:error.localizedDescription delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil];
//        [av show];
//    }];
}

- (void)done:(id)sender {
    NSString *errMsg = @"";
    errMsg = [User validatePhoneNumber:self.tfPhone.text];
    if (errMsg) {
        UIAlertView *av = [[UIAlertView alloc] initWithTitle:nil message:errMsg delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil];
        [av show];
        return;
    }
    
    if (![self.code isEqualToString:self.tfPasscode.text]) {
        UIAlertView *av = [[UIAlertView alloc] initWithTitle:nil message:@"Invalid passcode" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil];
        [av show];
        return;
    }
    
    errMsg = [User validateUsername:self.tfPassword.text];
    if (errMsg) {
        UIAlertView *av = [[UIAlertView alloc] initWithTitle:nil message:errMsg delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil];
        [av show];
        return;
    }
    
    User *user = [User new];
    user.phone = self.tfPhone.text;
    user.password = self.tfPassword.text;
    [[BLHTTPClient sharedBLHTTPClient] forgotPassword:user success:^(NSURLSessionDataTask *task, id responseObject) {
        NSLog(@"reset password successed.");
        UIAlertView *av = [[UIAlertView alloc] initWithTitle:nil
                                                     message:NSLocalizedString(@"Reset password successed, please login.", nil)
                                                    delegate:self
                                           cancelButtonTitle:@"Ok"
                                           otherButtonTitles:nil];
        av.tag = BL_RESET_SUCCESS_ALERTVIEW;
        [av show];
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        NSLog(@"Reset password failed.");
    }];
}

#pragma mark - handle tab gesture
- (void)tapHandler:(UITapGestureRecognizer *)gesture {
    [self.tfPhone resignFirstResponder];
    [self.tfPasscode resignFirstResponder];
    [self.tfPassword resignFirstResponder];
}

- (void)timerfired {
    if (_secondLeftToResend > 0) {
        _secondLeftToResend -= 1;
        _lbSecondLeft.text = [NSString stringWithFormat:@"%ld", (long)_secondLeftToResend];
    } else {
        [_timer invalidate];
        [self hideSecondToRsend];
    }
}

#pragma mark - Delegates
#pragma mark UIAlertView Delegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    switch (alertView.tag) {
        case BL_RESET_SUCCESS_ALERTVIEW:
            if (buttonIndex == 0) {
                [self dismissViewControllerAnimated:YES completion:nil];
            }
            break;
            
        default:
            break;
    }
}

#pragma mark - Private methods
- (void)showSecondToResend {
    [self showSecondToResendLayout];
    [UIView animateWithDuration:0.5f animations:^{
        [self.view layoutIfNeeded];
    } completion:^(BOOL finished) {
        self.lbSecondLeft.alpha = 1.0f;
    }];
}

- (void)hideSecondToRsend {
    [self hideSecondToResendLayout];
    [UIView animateWithDuration:0.5f animations:^{
        self.lbSecondLeft.alpha = 0.0f;
        [self.view layoutIfNeeded];
    } completion:^(BOOL finished) {
        self.btnGetCode.enabled = YES;
    }];
}

- (void)showSecondToResendLayout {
    [self.btnGetCode mas_updateConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.btnGetCode.superview).with.offset([BLGenernalDefinition resolutionForDevices:-64.0f]);
    }];
}

- (void)hideSecondToResendLayout {
    [self.btnGetCode mas_updateConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.btnGetCode.superview).with.offset([BLGenernalDefinition resolutionForDevices:-50.0f]);
    }];
}

#pragma mark -
#pragma mark Getter
- (UIImageView *)background {
    if (!_background) {
        _background = [[UIImageView alloc] init];
        _background.image = [UIImage imageNamed:@"login_signup_background.png"];
    }
    return _background;
}

- (UIImageView *)logoImageView {
    if (!_logoImageView) {
        _logoImageView = [[UIImageView alloc] init];
        _logoImageView.backgroundColor = [UIColor clearColor];
        _logoImageView.image = [UIImage imageNamed:@"logo.png"];
    }
    return _logoImageView;
}

- (UILabel *)lbTitle {
    if (!_lbTitle) {
        _lbTitle = [[UILabel alloc] init];
        _lbTitle.text = NSLocalizedString(@"Forgot Password", nil);
        _lbTitle.textAlignment = NSTextAlignmentCenter;
        _lbTitle.textColor = [UIColor whiteColor];
        _lbTitle.font = [BLFontDefinition normalFont:18.0f];
    }
    return _lbTitle;
}

- (BLTextField *)tfPhone {
    if (!_tfPhone) {
        _tfPhone = [[BLTextField alloc] init];
        _tfPhone.placeholder = NSLocalizedString(@"Phone", nil);
        _tfPhone.keyboardType = UIKeyboardTypePhonePad;
//        _tfPhone.clearButtonMode = UITextFieldViewModeWhileEditing;
//        [_tfPhone showClearButton];
    }
    return _tfPhone;
}

- (BLTextField *)tfPasscode {
    if (!_tfPasscode) {
        _tfPasscode = [[BLTextField alloc] init];
        _tfPasscode.placeholder = NSLocalizedString(@"Code", nil);
        _tfPasscode.keyboardType = UIKeyboardTypeNumberPad;
        _tfPasscode.clearButtonMode = UITextFieldViewModeWhileEditing;
        [_tfPasscode showClearButton];
    }
    return _tfPasscode;
}

- (BLTextField *)tfPassword {
    if (!_tfPassword) {
        _tfPassword = [[BLTextField alloc] init];
        _tfPassword.placeholder = NSLocalizedString(@"New Password", nil);
        _tfPassword.secureTextEntry = YES;
        _tfPassword.clearButtonMode = UITextFieldViewModeWhileEditing;
        [_tfPassword showClearButton];
    }
    return _tfPassword;
}

- (UIButton *)btnClose {
    if (!_btnClose) {
        _btnClose = [[UIButton alloc] init];
        [_btnClose addTarget:self action:@selector(close:) forControlEvents:UIControlEventTouchDown];
        [_btnClose setBackgroundImage:[UIImage imageNamed:@"close_icon.png"] forState:UIControlStateNormal];
    }
    return _btnClose;
}

- (UIButton *)btnGetCode {
    if (!_btnGetCode) {
        _btnGetCode = [[UIButton alloc] init];
        [_btnGetCode addTarget:self action:@selector(getCode:) forControlEvents:UIControlEventTouchDown];
        [_btnGetCode setTitleColor:[BLColorDefinition fontGreenColor] forState:UIControlStateNormal];
        [_btnGetCode setTitleColor:[BLColorDefinition fontGrayColor] forState:UIControlStateDisabled];
        _btnGetCode.titleLabel.font = [BLFontDefinition lightFont:13.0f];
        [_btnGetCode setTitle:NSLocalizedString(@"GETTING CODE", nil) forState:UIControlStateNormal];
        [_btnGetCode setTitle:NSLocalizedString(@"RESEND AFTER:", nil) forState:UIControlStateDisabled];
    }
    return _btnGetCode;
}

- (UIButton *)btnDone {
    if (!_btnDone) {
        _btnDone = [[UIButton alloc] init];
        [_btnDone addTarget:self action:@selector(done:) forControlEvents:UIControlEventTouchDown];
        [_btnDone setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_btnDone setBackgroundColor:[BLColorDefinition greenColor]];
        _btnDone.titleLabel.font = [BLFontDefinition normalFont:15.0f];
        [_btnDone setTitle:NSLocalizedString(@"Done", nil) forState:UIControlStateNormal];
        _btnDone.layer.cornerRadius = 5.0f;
    }
    return _btnDone;
}

- (UITapGestureRecognizer *)tapGestureRecognizer {
    if (!_tapGestureRecognizer) {
        _tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapHandler:)];
        _tapGestureRecognizer.delegate = self;
    }
    return _tapGestureRecognizer;
}

- (UILabel *)lbSecondLeft {
    if (!_lbSecondLeft) {
        _lbSecondLeft = [[UILabel alloc] init];
        _lbSecondLeft.font = [BLFontDefinition lightFont:15.0f];
        _lbSecondLeft.textColor = [BLColorDefinition fontGrayColor];
        _lbSecondLeft.text = @"60";
        _lbSecondLeft.alpha = 0.0f;
    }
    return _lbSecondLeft;
}

@end
