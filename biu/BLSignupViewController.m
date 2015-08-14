//
//  BLSignupViewController.m
//  biu
//
//  Created by Tony Wu on 7/23/15.
//  Copyright (c) 2015 BiuLove. All rights reserved.
//

#import "BLSignupViewController.h"
#import "BLContractViewController.h"
#import "BLTextField.h"
#import "Masonry.h"

@interface BLSignupViewController () <UIGestureRecognizerDelegate, BLContractViewControllerDelegate>

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

@implementation BLSignupViewController

#pragma mark - Life cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.view addSubview:self.backgroundView];
    [self.view addSubview:self.logoImageView];
    [self.view addSubview:self.tfPhoneNumber];
    [self.view addSubview:self.tfPasscode];
    [self.view addSubview:self.tfPassword];
    [self.view addSubview:self.tfUsername];
    [self.view addSubview:self.lbContract];
    [self.view addSubview:self.lbOr];
    [self.view addSubview:self.btnClose];
    [self.view addSubview:self.btnSignup];
    [self.view addSubview:self.btnSignupWithWeChat];
    [self.view addSubview:self.btnSignupWithWeibo];
    [self.view addSubview:self.btnContract];
    [self.view addSubview:self.btnGetCode];
    [self.view addSubview:self.lineView1];
    [self.view addSubview:self.lineView2];
    [self.view addSubview:self.lbSecondLeft];
    [self.view addGestureRecognizer:self.tapGestureRecognizer];
    
    [self layoutSubviews];
}

#pragma mark Layouts
- (void)layoutSubviews {
    [self.backgroundView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.backgroundView.superview);
    }];
    
    [self.logoImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.logoImageView.superview).with.offset([BLGenernalDefinition resolutionForDevices:75.0f]);
        make.centerX.equalTo(_logoImageView.superview.mas_centerX);
        make.width.height.equalTo([NSNumber numberWithDouble:([BLGenernalDefinition resolutionForDevices:95.0f])]);
    }];
    
    [_tfPhoneNumber mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_logoImageView.mas_bottom).with.offset([BLGenernalDefinition resolutionForDevices:87.0f]);
        make.left.equalTo(_tfPhoneNumber.superview).with.offset([BLGenernalDefinition resolutionForDevices:50.0f]);
        make.right.equalTo(_tfPhoneNumber.superview).with.offset([BLGenernalDefinition resolutionForDevices:-50.0f]);
    }];
    
    [_tfPasscode mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_tfPhoneNumber.mas_bottom).with.offset([BLGenernalDefinition resolutionForDevices:20.0f]);
        make.left.equalTo(_tfPasscode.superview).with.offset([BLGenernalDefinition resolutionForDevices:50.0f]);
        make.right.equalTo(_tfPasscode.superview).with.offset([BLGenernalDefinition resolutionForDevices:-50.0f]);
    }];
    
    [_tfUsername mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_tfPasscode.mas_bottom).with.offset([BLGenernalDefinition resolutionForDevices:20.0f]);
        make.left.equalTo(_tfUsername.superview).with.offset([BLGenernalDefinition resolutionForDevices:50.0f]);
        make.right.equalTo(_tfUsername.superview).with.offset([BLGenernalDefinition resolutionForDevices:-50.0f]);
    }];
    
    [_tfPassword mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_tfUsername.mas_bottom).with.offset([BLGenernalDefinition resolutionForDevices:20.0f]);
        make.left.equalTo(_tfPassword.superview).with.offset([BLGenernalDefinition resolutionForDevices:50.0f]);
        make.right.equalTo(_tfPassword.superview).with.offset([BLGenernalDefinition resolutionForDevices:-50.0f]);
    }];
    
    [_btnSignup mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_tfPassword.mas_bottom).with.offset([BLGenernalDefinition resolutionForDevices:66.0f]);
        make.left.equalTo(_btnSignup.superview).with.offset([BLGenernalDefinition resolutionForDevices:127.0f]);
        make.right.equalTo(_btnSignup.superview).with.offset([BLGenernalDefinition resolutionForDevices:-127.0f]);
        make.height.equalTo([NSNumber numberWithDouble:([BLGenernalDefinition resolutionForDevices:30.0f])]);
    }];
    
    [_lbOr mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_btnSignup.mas_bottom).with.offset([BLGenernalDefinition resolutionForDevices:32.0f]);
        make.centerX.equalTo(_lbOr.superview.mas_centerX);
    }];
    
    [_lineView1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(_lbOr.mas_centerX).with.offset([BLGenernalDefinition resolutionForDevices:-30.0f]);
        make.centerY.equalTo(_lbOr.mas_centerY);
        make.width.equalTo([NSNumber numberWithDouble:([BLGenernalDefinition resolutionForDevices:20.0f])]);
        make.height.equalTo(@2.0f);
    }];
    
    [_lineView2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(_lbOr.mas_centerX).with.offset([BLGenernalDefinition resolutionForDevices:30.0f]);
        make.centerY.equalTo(_lbOr.mas_centerY);
        make.width.equalTo([NSNumber numberWithDouble:([BLGenernalDefinition resolutionForDevices:20.0f])]);
        make.height.equalTo(@2.0f);
    }];
    
    [_btnClose mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_btnClose.superview).with.offset([BLGenernalDefinition resolutionForDevices:32.0f]);
        make.left.equalTo(_btnClose.superview).with.offset([BLGenernalDefinition resolutionForDevices:20.0f]);
        make.width.height.equalTo([NSNumber numberWithDouble:([BLGenernalDefinition resolutionForDevices:20.0f])]);
    }];
    
    [_btnSignupWithWeChat mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_lbOr.mas_bottom).with.offset([BLGenernalDefinition resolutionForDevices:20.0f]);
        make.centerX.equalTo(_btnSignupWithWeChat.superview.mas_centerX).with.offset([BLGenernalDefinition resolutionForDevices:-50.0f]);
        make.width.height.equalTo([NSNumber numberWithDouble:([BLGenernalDefinition resolutionForDevices:40.0f])]);
    }];
    
    [_btnSignupWithWeibo mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_lbOr.mas_bottom).with.offset([BLGenernalDefinition resolutionForDevices:20.0f]);
        make.centerX.equalTo(_btnSignupWithWeibo.superview.mas_centerX).with.offset([BLGenernalDefinition resolutionForDevices:50.0f]);
        make.width.height.equalTo([NSNumber numberWithDouble:([BLGenernalDefinition resolutionForDevices:40.0f])]);
    }];
    
    [_btnGetCode mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(_tfPhoneNumber).with.offset([BLGenernalDefinition resolutionForDevices:5.0f]);
        make.right.equalTo(_btnGetCode.superview).with.offset([BLGenernalDefinition resolutionForDevices:-50.0f]);
    }];
    
    [_lbSecondLeft mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(_btnGetCode.mas_centerY);
        make.right.equalTo(_lbSecondLeft.superview).with.offset([BLGenernalDefinition resolutionForDevices:-50.0f]);
    }];
    
    [_lbContract mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_tfPassword.mas_bottom).with.offset([BLGenernalDefinition resolutionForDevices:10.0f]);
        make.left.equalTo(_tfPassword).with.offset(2.0f);
    }];
    
    [_btnContract mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(_lbContract.mas_centerY);
        make.left.equalTo(_lbContract.mas_right);
    }];
}

#pragma mark - Actions
- (void)close:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)signup:(id)sender {
    NSString *errMsg = @"";
    errMsg = [User validatePhoneNumber:_tfPhoneNumber.text];
    if (errMsg) {
        UIAlertView *av = [[UIAlertView alloc] initWithTitle:nil message:errMsg delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil];
        [av show];
        return;
    }
    
    if (![_code isEqualToString:_tfPasscode.text]) {
        UIAlertView *av = [[UIAlertView alloc] initWithTitle:nil message:@"Invalid passcode" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil];
        [av show];
        return;
    }
    
    errMsg = [User validateUsername:_tfUsername.text];
    if (errMsg) {
        UIAlertView *av = [[UIAlertView alloc] initWithTitle:nil message:errMsg delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil];
        [av show];
        return;
    }
    
    errMsg = [User validatePassword:_tfPassword.text];
    if (errMsg) {
        UIAlertView *av = [[UIAlertView alloc] initWithTitle:nil message:errMsg delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil];
        [av show];
        return;
    }
    
    User *user = [User new];
    user.phone = _tfPhoneNumber.text;
    user.username = _tfUsername.text;
    user.password = _tfPassword.text;
    user.avatar_url = nil;
    user.open_id = nil;
    
    [[BLHTTPClient sharedBLHTTPClient] signup:user success:^(NSURLSessionDataTask *task, id responseObject) {
        NSLog(@"Sign up success!!! user id: %@", [responseObject objectForKey:@"user"][@"user_id"]);
        user.userId = [responseObject objectForKey:@"user"][@"user_id"];
        [[NSUserDefaults standardUserDefaults] setObject:user.userId forKey:@"user_id"];
        [user save];
        BLAppDelegate *blDelegate = (BLAppDelegate *)[[UIApplication sharedApplication] delegate];
        if (blDelegate.deviceToken && user.userId) {
            [[BLHTTPClient sharedBLHTTPClient] registToken:blDelegate.deviceToken user:user success:^(NSURLSessionDataTask *task, id responseObject) {
                NSLog(@"Regist device token successed.");
            } failure:^(NSURLSessionDataTask *task, NSError *error) {
                NSLog(@"Regist device token failed.");
            }];
        }
        
        if (self.delegate) {
            _code = @"";
            [self.delegate viewController:self didSignupWithNewUser:user];
        }
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        NSLog(@"Signup failed%@",error.localizedDescription);
        
        UIAlertView *alertV = [[UIAlertView alloc] initWithTitle:@"注册失败" message:@"请重新注册" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alertV show];
    }];
    
}

- (void)getCode:(id)sender {
    NSString *errMsg = [User validatePhoneNumber:_tfPhoneNumber.text];
    if (errMsg) {
        UIAlertView *av = [[UIAlertView alloc] initWithTitle:nil message:errMsg delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil];
        [av show];
        return;
    }
    
    int code = arc4random() % 900000 + 100000;
    _code = [NSString stringWithFormat:@"%d", code];
    
    //For debug
    NSLog(@"code: %@", _code);
    _secondLeftToResend = 60;
    _lbSecondLeft.text = [NSString stringWithFormat:@"%ld", (long)_secondLeftToResend];
    _btnGetCode.enabled = NO;
    [self showSecondToResend];
    
//    [[BLHTTPClient sharedBLHTTPClient] passcode:_code phoneNumber:_tfPhoneNumber.text success:^(NSURLSessionDataTask *task, id responseObject) {
//        _secondLeftToResend = 60;
//        _lbSecondLeft.text = [NSString stringWithFormat:@"%ld", (long)_secondLeftToResend];
//        _btnGetCode.enabled = NO;
//        [self showSecondToResend];
//        _timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(timerfired) userInfo:nil repeats:YES];
//    } failure:^(NSURLSessionDataTask *task, NSError *error) {
//        NSLog(@"Sending passcode failed, error: %@", error.description);
//        UIAlertView *av = [[UIAlertView alloc] initWithTitle:nil message:error.localizedDescription delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil];
//        [av show];
//    }];
}

- (void)showContract:(id)sender {
    BLContractViewController *contractViewController = [[BLContractViewController alloc] init];
    contractViewController.delegate = self;
    [self presentViewController:contractViewController animated:YES completion:nil];
}

- (void)weiboLogin:(id)sender {
    WBSendMessageToWeiboRequest *request = [WBSendMessageToWeiboRequest requestWithMessage:[self messageToShare]];
    request.userInfo = @{@"ShareMessageFrom" : @"SendMessageToWeiboViewController",
                         @"Other_Info_1" : [NSNumber numberWithInt:123]};
    [WeiboSDK sendRequest:request];
    
    WBAuthorizeRequest *req = [WBAuthorizeRequest request];
    req.redirectURI = kWeiBoRedirectURL;
    req.scope = @"all";
    req.userInfo = @{@"SSO_From" : @"SendMessageToWeiboViewController",
                     @"myKey" : @"myValue"};
    [WeiboSDK sendRequest:req];

}
- (WBMessageObject *)messageToShare {
    WBMessageObject *message = [WBMessageObject message];
    
    message.text = @"测试使用";
    return message;
}

- (void)wechatLogin:(id)sender {
    if ([WXApi isWXAppInstalled] == NO) {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"尚未安装微信客户端" message:@"是否安装" delegate:self cancelButtonTitle:@"YES" otherButtonTitles:@"NO", nil];
        [alertView show];
    }else {
        SendAuthReq *req = [[SendAuthReq alloc] init];
        req.scope = @"snsapi_userinfo";//snsapi_base只能获取到openid，意义不大，所以使用snsapi_userinfo
        req.state = kAppDescription;//随便数字
        [WXApi sendReq:req];
    }
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 0) {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[WXApi getWXAppInstallUrl]]];
    }
}

#pragma mark - handle tab gesture
- (void)tapHandler:(UITapGestureRecognizer *)gesture {
    [_tfPhoneNumber resignFirstResponder];
    [_tfPasscode resignFirstResponder];
    [_tfUsername resignFirstResponder];
    [_tfPassword resignFirstResponder];
}

#pragma mark - handle timer
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
#pragma mark BLContractViewController delegate
- (void)didDismissBLContractViewController:(BLContractViewController *)vc {
    [vc dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - Private methods
- (void)showSecondToResend {
    [self showSecondToResendLayout];
    [UIView animateWithDuration:0.5f animations:^{
        [self.view layoutIfNeeded];
    } completion:^(BOOL finished) {
        _lbSecondLeft.alpha = 1.0f;
    }];
}

- (void)hideSecondToRsend {
    [self hideSecondToResendLayout];
    [UIView animateWithDuration:0.5f animations:^{
        _lbSecondLeft.alpha = 0.0f;
        [self.view layoutIfNeeded];
    } completion:^(BOOL finished) {
        _btnGetCode.enabled = YES;
    }];
}

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

#pragma mark -
#pragma mark Getter
- (UIImageView *)backgroundView {
    if (!_backgroundView) {
        _backgroundView = [[UIImageView alloc] init];
        _backgroundView.image = [UIImage imageNamed:@"login_signup_background.png"];
    }
    return _backgroundView;
}

- (UIImageView *)logoImageView {
    if (!_logoImageView) {
        _logoImageView = [[UIImageView alloc] init];
        _logoImageView.backgroundColor = [UIColor clearColor];
        _logoImageView.image = [UIImage imageNamed:@"logo.png"];
    }
    return _logoImageView;
}

- (BLTextField *)tfPhoneNumber {
    if (!_tfPhoneNumber) {
        _tfPhoneNumber = [[BLTextField alloc] init];
        _tfPhoneNumber.placeholder = NSLocalizedString(@"Phone", nil);
//        _tfPhoneNumber.keyboardType = UIKeyboardTypePhonePad;
//        [_tfPhoneNumber showClearButton];
    }
    return _tfPhoneNumber;
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

- (BLTextField *)tfUsername {
    if (!_tfUsername) {
        _tfUsername = [[BLTextField alloc] init];
        _tfUsername.placeholder = NSLocalizedString(@"Username", nil);
        _tfUsername.clearButtonMode = UITextFieldViewModeWhileEditing;
        [_tfUsername showClearButton];
    }
    return _tfUsername;
}

- (BLTextField *)tfPassword {
    if (!_tfPassword) {
        _tfPassword = [[BLTextField alloc] init];
        _tfPassword.placeholder = NSLocalizedString(@"Password", nil);
        _tfPassword.secureTextEntry = YES;
        [_tfPassword showClearButton];
    }
    return _tfPassword;
}

- (UILabel *)lbContract {
    if (!_lbContract) {
        _lbContract = [[UILabel alloc] init];
        _lbContract.textColor = [UIColor whiteColor];
        _lbContract.font = [BLFontDefinition lightFont:13.0f];
        _lbContract.text = NSLocalizedString(@"Accept:", nil);
    }
    return _lbContract;
}

- (UIButton *)btnContract {
    if (!_btnContract) {
        _btnContract = [[UIButton alloc] init];
        [_btnContract addTarget:self action:@selector(showContract:) forControlEvents:UIControlEventTouchDown];
        [_btnContract setTitleColor:[BLColorDefinition fontGreenColor] forState:UIControlStateNormal];
        _btnContract.titleLabel.font = [BLFontDefinition lightFont:13.0f];
        [_btnContract setTitle:NSLocalizedString(@"Agreement of BIU", nil) forState:UIControlStateNormal];
    }
    return _btnContract;
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

- (UIButton *)btnSignup {
    if (!_btnSignup) {
        _btnSignup = [[UIButton alloc] init];
        [_btnSignup addTarget:self action:@selector(signup:) forControlEvents:UIControlEventTouchDown];
        [_btnSignup setBackgroundColor:[BLColorDefinition greenColor]];
        [_btnSignup setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _btnSignup.titleLabel.font = [BLFontDefinition normalFont:15.0f];
        [_btnSignup setTitle:NSLocalizedString(@"Sign up", nil) forState:UIControlStateNormal];
        _btnSignup.layer.cornerRadius = 5.0f;
    }
    return _btnSignup;
}

- (UILabel *)lbOr {
    if (!_lbOr) {
        _lbOr = [[UILabel alloc] init];
        _lbOr.font = [BLFontDefinition normalFont:16.0f];
        _lbOr.textColor = [UIColor whiteColor];
        _lbOr.textAlignment = NSTextAlignmentCenter;
        _lbOr.text = NSLocalizedString(@"Or", nil);
    }
    return _lbOr;
}

- (UIView *)lineView1 {
    if (!_lineView1) {
        _lineView1 = [[UIView alloc] init];
        _lineView1.backgroundColor = [UIColor colorWithRed:112.0 / 255.0 green:115.0 / 255.0 blue:122.0 / 255.0 alpha:1.0f];
    }
    return _lineView1;
}

- (UIView *)lineView2 {
    if (!_lineView2) {
        _lineView2 = [[UIView alloc] init];
        _lineView2.backgroundColor = [UIColor colorWithRed:112.0 / 255.0 green:115.0 / 255.0 blue:122.0 / 255.0 alpha:1.0f];
    }
    return _lineView2;
}

//微信登录
- (UIButton *)btnSignupWithWeChat {
    if (!_btnSignupWithWeChat) {
        _btnSignupWithWeChat = [[UIButton alloc] init];
        _btnSignupWithWeChat.backgroundColor = [UIColor clearColor];
        [_btnSignupWithWeChat setImage:[UIImage imageNamed:@"login_with_wechat_icon.png"] forState:UIControlStateNormal];
        
        [_btnSignupWithWeChat addTarget:self action:@selector(wechatLogin:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _btnSignupWithWeChat;
}

//微博登录
- (UIButton *)btnSignupWithWeibo {
    if (!_btnSignupWithWeibo) {
        _btnSignupWithWeibo = [[UIButton alloc] init];
        _btnSignupWithWeibo.backgroundColor = [UIColor clearColor];
        [_btnSignupWithWeibo setImage:[UIImage imageNamed:@"login_with_weibo_icon.png"] forState:UIControlStateNormal];
        
        [_btnSignupWithWeibo addTarget:self action:@selector(weiboLogin:) forControlEvents:UIControlEventTouchUpInside];

    }
    return _btnSignupWithWeibo;
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

- (UITapGestureRecognizer *)tapGestureRecognizer {
    if (!_tapGestureRecognizer) {
        _tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapHandler:)];
        _tapGestureRecognizer.delegate = self;
    }
    return _tapGestureRecognizer;
}

@end
