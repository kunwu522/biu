//
//  BLSignupView.m
//  biu
//
//  Created by Tony Wu on 6/9/15.
//  Copyright (c) 2015 BiuLove. All rights reserved.
//

#import "BLSignupView.h"
#import "BLTextField.h"
#import "BLProfileViewController.h"

#import "Masonry.h"

@interface BLSignupView () <UIGestureRecognizerDelegate>

@property (strong, nonatomic) UIImageView *backgroundView;
@property (strong, nonatomic) UIImageView *logoImageView;
@property (strong, nonatomic) BLTextField *tfPhoneNumber;
@property (strong, nonatomic) BLTextField *tfPasscode;
@property (strong, nonatomic) BLTextField *tfPassword;
@property (strong, nonatomic) BLTextField *tfUsername;
@property (strong, nonatomic) UILabel *lbContract;
@property (strong, nonatomic) UILabel *lbOr;
@property (strong, nonatomic) UIButton *btnClose;
@property (strong, nonatomic) UIButton *btnSignup;
@property (strong, nonatomic) UIButton *btnSignupWithWeChat;
@property (strong, nonatomic) UIButton *btnSignupWithWeibo;
@property (strong, nonatomic) UIButton *btnContract;
@property (strong, nonatomic) UIButton *btnGetCode;
@property (strong, nonatomic) UIView *lineView1;
@property (strong, nonatomic) UIView *lineView2;
@property (strong, nonatomic) UITapGestureRecognizer *tapGestureRecognizer;
@property (strong, nonatomic) NSTimer *timer;
@property (strong, nonatomic) UILabel *lbSecondLeft;
@property (assign, nonatomic) NSInteger secondLeftToResend;
@property (strong, nonatomic) NSString *code;

@end

@implementation BLSignupView

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setup];
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self setup];
    }
    return self;
}

- (void)setup {
    self.backgroundColor = [UIColor clearColor];
    
    _backgroundView = [[UIImageView alloc] initWithFrame:self.bounds];
    _backgroundView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    _backgroundView.image = [UIImage imageNamed:@"login_signup_background.png"];
    [self addSubview:_backgroundView];
    
    _logoImageView = [[UIImageView alloc] init];
    _logoImageView.backgroundColor = [UIColor clearColor];
    _logoImageView.image = [UIImage imageNamed:@"logo.png"];
    [self addSubview:_logoImageView];
    
    _tfPhoneNumber = [[BLTextField alloc] init];
    _tfPhoneNumber.placeholder = NSLocalizedString(@"Phone", nil);
    _tfPhoneNumber.keyboardType = UIKeyboardTypePhonePad;
    [self addSubview:_tfPhoneNumber];
    
    _tfPasscode = [[BLTextField alloc] init];
    _tfPasscode.placeholder = NSLocalizedString(@"Code", nil);
    _tfPasscode.keyboardType = UIKeyboardTypePhonePad;
    [self addSubview:_tfPasscode];
    
    _tfUsername = [[BLTextField alloc] init];
    _tfUsername.placeholder = NSLocalizedString(@"Username", nil);
    [self addSubview:_tfUsername];
    
    _tfPassword = [[BLTextField alloc] init];
    _tfPassword.placeholder = NSLocalizedString(@"Password", nil);
    _tfPassword.secureTextEntry = YES;
    [self addSubview:_tfPassword];
    
    _lbContract = [[UILabel alloc] init];
    _lbContract.textColor = [UIColor whiteColor];
    _lbContract.font = [BLFontDefinition lightFont:10.0f];
    _lbContract.text = NSLocalizedString(@"Accept:", nil);
    [self addSubview:_lbContract];
    
    _btnContract = [[UIButton alloc] init];
    [_btnContract addTarget:self action:@selector(showContract:) forControlEvents:UIControlEventTouchDown];
    [_btnContract setTitleColor:[BLColorDefinition fontGreenColor] forState:UIControlStateNormal];
    _btnContract.titleLabel.font = [BLFontDefinition lightFont:10.0f];
    [_btnContract setTitle:NSLocalizedString(@"Agreement of BIU", nil) forState:UIControlStateNormal];
    [self addSubview:_btnContract];
    
    _btnClose = [[UIButton alloc] init];
    [_btnClose addTarget:self action:@selector(close:) forControlEvents:UIControlEventTouchDown];
    [_btnClose setBackgroundImage:[UIImage imageNamed:@"close_icon.png"] forState:UIControlStateNormal];
    [self addSubview:_btnClose];
    
    _btnGetCode = [[UIButton alloc] init];
    [_btnGetCode addTarget:self action:@selector(getCode:) forControlEvents:UIControlEventTouchDown];
    [_btnGetCode setTitleColor:[BLColorDefinition fontGreenColor] forState:UIControlStateNormal];
    [_btnGetCode setTitleColor:[BLColorDefinition fontGrayColor] forState:UIControlStateDisabled];
    _btnGetCode.titleLabel.font = [BLFontDefinition lightFont:13.0f];
    [_btnGetCode setTitle:NSLocalizedString(@"GETTING CODE", nil) forState:UIControlStateNormal];
    [_btnGetCode setTitle:NSLocalizedString(@"RESEND AFTER:", nil) forState:UIControlStateDisabled];
    [self addSubview:_btnGetCode];
    
    _btnSignup = [[UIButton alloc] init];
    [_btnSignup addTarget:self action:@selector(signup:) forControlEvents:UIControlEventTouchDown];
    [_btnSignup setBackgroundColor:[BLColorDefinition greenColor]];
    [_btnSignup setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    _btnSignup.titleLabel.font = [BLFontDefinition normalFont:15.0f];
    [_btnSignup setTitle:NSLocalizedString(@"Sign up", nil) forState:UIControlStateNormal];
    _btnSignup.layer.cornerRadius = 5.0f;
    [self addSubview:_btnSignup];
    
    _lbOr = [[UILabel alloc] init];
    _lbOr.font = [BLFontDefinition normalFont:16.0f];
    _lbOr.textColor = [UIColor whiteColor];
    _lbOr.textAlignment = NSTextAlignmentCenter;
    _lbOr.text = NSLocalizedString(@"Or", nil);
    [self addSubview:_lbOr];
    
    _lineView1 = [[UIView alloc] init];
    _lineView1.backgroundColor = [UIColor colorWithRed:112.0 / 255.0 green:115.0 / 255.0 blue:122.0 / 255.0 alpha:1.0f];
    _lineView2 = [[UIView alloc] init];
    _lineView2.backgroundColor = [UIColor colorWithRed:112.0 / 255.0 green:115.0 / 255.0 blue:122.0 / 255.0 alpha:1.0f];
    [self addSubview:_lineView1];
    [self addSubview:_lineView2];
    
    _btnSignupWithWeChat = [[UIButton alloc] init];
    _btnSignupWithWeChat.backgroundColor = [UIColor clearColor];
    [_btnSignupWithWeChat setImage:[UIImage imageNamed:@"login_with_wechat_icon.png"] forState:UIControlStateNormal];
    [self addSubview:_btnSignupWithWeChat];
    
    _btnSignupWithWeibo = [[UIButton alloc] init];
    _btnSignupWithWeibo.backgroundColor = [UIColor clearColor];
    [_btnSignupWithWeibo setImage:[UIImage imageNamed:@"login_with_weibo_icon.png"] forState:UIControlStateNormal];
    [self addSubview:_btnSignupWithWeibo];
    
    _lbSecondLeft = [[UILabel alloc] init];
    _lbSecondLeft.font = [BLFontDefinition lightFont:13.0f];
    _lbSecondLeft.textColor = [BLColorDefinition fontGrayColor];
    _lbSecondLeft.text = @"60";
    _lbSecondLeft.alpha = 0.0f;
    [self addSubview:_lbSecondLeft];
    
    _tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapHandler:)];
    _tapGestureRecognizer.delegate = self;
    [self addGestureRecognizer:_tapGestureRecognizer];
    
    [_logoImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_logoImageView.superview).with.offset(75.0f);
        make.centerX.equalTo(_logoImageView.superview.mas_centerX);
        make.width.equalTo(@95.0f);
        make.height.equalTo(@95.0f);
    }];
    
    [_tfPhoneNumber mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_logoImageView.mas_bottom).with.offset(87.0f);
        make.left.equalTo(_tfPhoneNumber.superview).with.offset(50.0f);
        make.right.equalTo(_tfPhoneNumber.superview).with.offset(-50.0f);
    }];
    
    [_tfPasscode mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_tfPhoneNumber.mas_bottom).with.offset(20.0f);
        make.left.equalTo(_tfPasscode.superview).with.offset(50.0f);
        make.right.equalTo(_tfPasscode.superview).with.offset(-50.0f);
    }];
    
    [_tfUsername mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_tfPasscode.mas_bottom).with.offset(20.0f);
        make.left.equalTo(_tfUsername.superview).with.offset(50.0f);
        make.right.equalTo(_tfUsername.superview).with.offset(-50.0f);
    }];
    
    [_tfPassword mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_tfUsername.mas_bottom).with.offset(20.0f);
        make.left.equalTo(_tfPassword.superview).with.offset(50.0f);
        make.right.equalTo(_tfPassword.superview).with.offset(-50.0f);
    }];
    
    [_btnSignup mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_tfPassword.mas_bottom).with.offset(66.0f);
        make.left.equalTo(_btnSignup.superview).with.offset(127.0f);
        make.right.equalTo(_btnSignup.superview).with.offset(-127.0f);
        make.height.equalTo(@30.0f);
    }];
    
    [_lbOr mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_btnSignup.mas_bottom).with.offset(32.0f);
        make.centerX.equalTo(_lbOr.superview.mas_centerX);
    }];
    
    [_lineView1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(_lbOr.mas_centerX).with.offset(-30.0f);
        make.centerY.equalTo(_lbOr.mas_centerY);
        make.width.equalTo(@20.0f);
        make.height.equalTo(@2.0f);
    }];
    
    [_lineView2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(_lbOr.mas_centerX).with.offset(30.0f);
        make.centerY.equalTo(_lbOr.mas_centerY);
        make.width.equalTo(@20.0f);
        make.height.equalTo(@2.0f);
    }];
    
    [_btnClose mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_btnClose.superview).with.offset(32.0f);
        make.left.equalTo(_btnClose.superview).with.offset(20.0f);
        make.width.equalTo(@20.0f);
        make.height.equalTo(@20.0f);
    }];
    
    [_btnSignupWithWeChat mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_lbOr.mas_bottom).with.offset(20.0f);
        make.centerX.equalTo(_btnSignupWithWeChat.superview.mas_centerX).with.offset(-50.0f);
        make.width.equalTo(@40.0f);
        make.height.equalTo(@40.0f);
    }];
    
    [_btnSignupWithWeibo mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_lbOr.mas_bottom).with.offset(20.0f);
        make.centerX.equalTo(_btnSignupWithWeibo.superview.mas_centerX).with.offset(50.0f);
        make.width.equalTo(@40.0f);
        make.height.equalTo(@40.0f);
    }];
    
    [_btnGetCode mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(_tfPhoneNumber).with.offset(5.0f);
        make.right.equalTo(_btnGetCode.superview).with.offset(-50.0f);
    }];
    
    [_lbSecondLeft mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(_btnGetCode.mas_centerY);
        make.right.equalTo(_lbSecondLeft.superview).with.offset(-50.0f);
    }];
    
    [_lbContract mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_tfPassword.mas_bottom).with.offset(10.0f);
        make.left.equalTo(_tfPassword).with.offset(2.0f);
    }];
    
    [_btnContract mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(_lbContract.mas_centerY);
        make.left.equalTo(_lbContract.mas_right);
    }];
}

//- (void)layoutSubviews {
//    
//}

- (void)showSecondToResendLayout {
    [_btnGetCode mas_updateConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(_btnGetCode.superview).with.offset(-64.0f);
    }];
}

- (void)hideSecondToResendLayout {
    [_btnGetCode mas_updateConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(_btnGetCode.superview).with.offset(-50.0f);
    }];
}

#pragma mark - handle action
- (void)close:(id)sender {
    [UIView animateWithDuration:0.3f animations:^{
        CGPoint center = self.center;
        center.y += self.bounds.size.height;
        self.center = center;
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}

- (void)signup:(id)sender {
    NSString *errMsg = @"";
    errMsg = [User validatePhoneNumber:_tfPhoneNumber.text];
    if (errMsg) {
        [self showErrorMessage:errMsg];
        return;
    }
    
    if (![_code isEqualToString:_tfPasscode.text]) {
        [self showErrorMessage:@"Invalid passcode"];
        return;
    }
    
    errMsg = [User validateUsername:_tfUsername.text];
    if (errMsg) {
        [self showErrorMessage:errMsg];
        return;
    }
    
    errMsg = [User validatePassword:_tfPassword.text];
    if (errMsg) {
        [self showErrorMessage:errMsg];
        return;
    }
    
    User *user = [User new];
    user.phone = _tfPhoneNumber.text;
    user.username = _tfUsername.text;
    user.password = _tfPassword.text;
    
    UIActivityIndicatorView *ai = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
    ai.hidesWhenStopped = YES;
    [ai startAnimating];
    [[BLHTTPClient sharedBLHTTPClient] signup:user success:^(NSURLSessionDataTask *task, id responseObject) {
        NSNumber *userId = [NSNumber numberWithInt:[[responseObject objectForKey:@"user_id"] intValue]];
        NSLog(@"Sign up success!!! user id: %@", userId);
        user.userId = userId;
        [ai stopAnimating];
        if (self.delegate) {
            _code = @"";
            [self.delegate didSignupWithNewUser:user];
        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        [ai stopAnimating];
        NSLog(@"Sign up failed, error: %@", error.description);
        [self showErrorMessage:@"Sorry, failed to set up your account. Please try again."];
    }];
}

- (void)getCode:(id)sender {
    NSString *errMsg = [User validatePhoneNumber:_tfPhoneNumber.text];
    if (errMsg) {
        [self showErrorMessage:errMsg];
        return;
    }
    
    int code = arc4random() % 900000 + 100000;
    _code = [NSString stringWithFormat:@"%d", code];
    [[BLHTTPClient sharedBLHTTPClient] passcode:_code phoneNumber:_tfPhoneNumber.text success:^(NSURLSessionDataTask *task, id responseObject) {
        _secondLeftToResend = 60;
        _lbSecondLeft.text = [NSString stringWithFormat:@"%ld", _secondLeftToResend];
        _btnGetCode.enabled = NO;
        [self showSecondToResend];
        _timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(timerfired) userInfo:nil repeats:YES];
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        NSLog(@"Sending passcode failed, error: %@", error.description);
        [self showErrorMessage:@"Sorry, getting passcode failed. Please try again later."];
    }];
}

- (void)showContract:(id)sender {
    
}

#pragma mark - handle tab gesture
- (void)tapHandler:(UITapGestureRecognizer *)gesture {
    [_tfPhoneNumber resignFirstResponder];
    [_tfPasscode resignFirstResponder];
    [_tfPassword resignFirstResponder];
}

#pragma mark - handle timer
- (void)timerfired {
    if (_secondLeftToResend > 0) {
        _secondLeftToResend -= 1;
        _lbSecondLeft.text = [NSString stringWithFormat:@"%ld", _secondLeftToResend];
    } else {
        [_timer invalidate];
        [self hideSecondToRsend];
    }
}

#pragma mark - 
- (void)showSecondToResend {
    [self showSecondToResendLayout];
    [UIView animateWithDuration:0.5f animations:^{
        [self layoutIfNeeded];
    } completion:^(BOOL finished) {
        _lbSecondLeft.alpha = 1.0f;
    }];
}

- (void)hideSecondToRsend {
    [self hideSecondToResendLayout];
    [UIView animateWithDuration:0.5f animations:^{
        _lbSecondLeft.alpha = 0.0f;
        [self layoutIfNeeded];
    } completion:^(BOOL finished) {
        _btnGetCode.enabled = YES;
    }];
}

- (void)showErrorMessage:(NSString *)message {
    UIAlertView *av = [[UIAlertView alloc] initWithTitle:nil message:message delegate:self cancelButtonTitle:@"Ok" otherButtonTitles: nil];
    [av show];
//    [UIView animateWithDuration:0.2f animations:^{
//        _lbErrorMsg.alpha = 0.8f;
//    } completion:^(BOOL finished) {
//        [UIView animateWithDuration:0.2f delay:2.0f options:UIViewAnimationOptionLayoutSubviews animations:^{
//            _lbErrorMsg.alpha = 0.0f;
//        } completion:^(BOOL finished) {
//            ;
//        }];
//    }];
}
@end
