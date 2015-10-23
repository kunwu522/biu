//
//  BLLoginViewController.m
//  biu
//
//  Created by Tony Wu on 7/23/15.
//  Copyright (c) 2015 BiuLove. All rights reserved.
//

#import "BLLoginViewController.h"
#import "BLForgotPasswordViewController.h"
#import "BLTextField.h"
#import "Masonry.h"
#import "WeiboSDK.h"
#import "BLHTTPClient.h"
#import "BLProfileViewController.h"
#import "BLPartnerViewController.h"
#import "BLWelcomeViewController.h"
#import "BLMatchViewController.h"
#import "BLMenuViewController.h"
#import "BLMenuNavController.h"
#import "UINavigationController+BLPresentViewController.h"
#import <MBProgressHUD/MBProgressHUD.h>

@interface BLLoginViewController () <UIGestureRecognizerDelegate, MBProgressHUDDelegate, UIAlertViewDelegate, UITextFieldDelegate, WXApiDelegate> {
    MBProgressHUD *_HUD;
}

@property (strong, nonatomic) UIImageView *backgroundView;
@property (strong, nonatomic) UIImageView *logoImageView;
@property (strong, nonatomic) BLTextField *tfPhoneNumber;
@property (strong, nonatomic) BLTextField *tfPassword;
@property (strong, nonatomic) UIView *lineView1;
@property (strong, nonatomic) UIView *lineView2;
@property (strong, nonatomic) UILabel *lbOr;
@property (strong, nonatomic) UIButton *btnClose;
@property (strong, nonatomic) UIButton *btnLogin;
@property (strong, nonatomic) UIButton *btnLoginWithWeChat;
@property (strong, nonatomic) UIButton *btnLoginWithWeibo;
@property (strong, nonatomic) UIButton *btnForgotPassword;
@property (strong, nonatomic) UITapGestureRecognizer *tapGestureRecognizer;
@property (strong, nonatomic) UINavigationController *fillingInfoNavController;
@property (strong, nonatomic) NSString *alertViewWhere;

@property (strong, nonatomic) NSString *HUDState;//判断指示器状态
@end

@implementation BLLoginViewController

#pragma mark - Life cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.view addSubview:self.backgroundView];
    [self.view addSubview:self.logoImageView];
    [self.view addSubview:self.tfPhoneNumber];
    [self.view addSubview:self.tfPassword];
    [self.view addSubview:self.lineView1];
    [self.view addSubview:self.lineView2];
    [self.view addSubview:self.lbOr];
    [self.view addSubview:self.btnClose];
    [self.view addSubview:self.btnLogin];
    [self.view addSubview:self.btnLoginWithWeChat];
    [self.view addSubview:self.btnLoginWithWeibo];
    [self.view addSubview:self.btnForgotPassword];
    [self.view addGestureRecognizer:self.tapGestureRecognizer];
    
    [self addHUD];
    
    [self loadLayout];
    self.alertViewWhere = nil;
    self.HUDState = nil;
}

- (void)viewDidDisappear:(BOOL)animated{
    
//    BLAppDelegate *blDelegate = (BLAppDelegate *)[[UIApplication sharedApplication] delegate];
//    //    BLAppDelegate *blDelegate = [[BLAppDelegate alloc] init];
//    NSLog(@"deviceTokenLogin==%@", blDelegate.deviceToken);
//    
//    NSDictionary *dic = [[NSDictionary alloc] init];
//    dic = [[NSUserDefaults standardUserDefaults] dictionaryRepresentation];
//    User *user = [User new];
//    user.userId = dic[@"user_id"];
//    user.token = dic[@"device_token"];
//    if (user.token && dic[@"device_token"]) {
//        [[BLHTTPClient sharedBLHTTPClient] registToken:dic[@"device_token"] user:user success:^(NSURLSessionDataTask *task, id responseObject) {
//            NSLog(@"Regist device token successed.");
//        } failure:^(NSURLSessionDataTask *task, NSError *error) {
//            NSLog(@"Regist device token failed.");
//        }];
//    }
}

#pragma mark Layout
- (void)loadLayout {
    [self.backgroundView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.backgroundView.superview);
    }];
    
    [self.logoImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.logoImageView.superview).with.offset([BLGenernalDefinition resolutionForDevices:75.0f]);
        make.centerX.equalTo(self.logoImageView.superview.mas_centerX);
        make.width.height.equalTo([NSNumber numberWithDouble:[BLGenernalDefinition resolutionForDevices:95.0f]]);
    }];
    
    [self.tfPhoneNumber mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.logoImageView.mas_bottom).with.offset([BLGenernalDefinition resolutionForDevices:87.0f]);
        make.left.equalTo(self.tfPhoneNumber.superview).with.offset([BLGenernalDefinition resolutionForDevices:50.0f]);
        make.right.equalTo(self.tfPhoneNumber.superview).with.offset([BLGenernalDefinition resolutionForDevices:-50.0f]);
    }];
    
    [self.tfPassword mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.tfPhoneNumber.mas_bottom).with.offset([BLGenernalDefinition resolutionForDevices:20.0f]);
        make.left.equalTo(self.tfPassword.superview).with.offset([BLGenernalDefinition resolutionForDevices:50.0f]);
        make.right.equalTo(self.tfPassword.superview).with.offset([BLGenernalDefinition resolutionForDevices:-50.0f]);
    }];
    
    [self.btnLogin mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.tfPassword.mas_bottom).with.offset([BLGenernalDefinition resolutionForDevices:66.0f]);
        make.left.equalTo(self.btnLogin.superview).with.offset([BLGenernalDefinition resolutionForDevices:127.0f]);
        make.right.equalTo(self.btnLogin.superview).with.offset([BLGenernalDefinition resolutionForDevices:-127.0f]);
        make.height.equalTo([NSNumber numberWithDouble:[BLGenernalDefinition resolutionForDevices:30.0f]]);
    }];
    
    [self.lbOr mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.btnLogin.mas_bottom).with.offset([BLGenernalDefinition resolutionForDevices:32.0f]);
        make.centerX.equalTo(self.lbOr.superview.mas_centerX);
    }];
    
    [self.lineView1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.lbOr.mas_centerX).with.offset([BLGenernalDefinition resolutionForDevices:-30.0f]);
        make.centerY.equalTo(self.lbOr.mas_centerY);
        make.width.equalTo([NSNumber numberWithDouble:[BLGenernalDefinition resolutionForDevices:20.0f]]);
        make.height.equalTo([NSNumber numberWithDouble:[BLGenernalDefinition resolutionForDevices:2.0f]]);
    }];
    
    [self.lineView2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.lbOr.mas_centerX).with.offset([BLGenernalDefinition resolutionForDevices:30.0f]);
        make.centerY.equalTo(self.lbOr.mas_centerY);
        make.width.equalTo([NSNumber numberWithDouble:[BLGenernalDefinition resolutionForDevices:20.0f]]);
        make.height.equalTo([NSNumber numberWithDouble:[BLGenernalDefinition resolutionForDevices:2.0f]]);
    }];
    
    [self.btnClose mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.btnClose.superview).with.offset([BLGenernalDefinition resolutionForDevices:32.0f]);
        make.left.equalTo(self.btnClose.superview).with.offset([BLGenernalDefinition resolutionForDevices:20.0f]);
        make.width.height.equalTo([NSNumber numberWithDouble:[BLGenernalDefinition resolutionForDevices:20.0f]]);
    }];
    
    [_btnLoginWithWeChat mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.lbOr.mas_bottom).with.offset([BLGenernalDefinition resolutionForDevices:20.0f]);
        make.centerX.equalTo(self.btnLoginWithWeChat.superview.mas_centerX).with.offset([BLGenernalDefinition resolutionForDevices:-50.0f]);
        make.width.height.equalTo([NSNumber numberWithDouble:[BLGenernalDefinition resolutionForDevices:40.0f]]);
    }];
    
    [self.btnLoginWithWeibo mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.lbOr.mas_bottom).with.offset([BLGenernalDefinition resolutionForDevices:20.0f]);
        make.centerX.equalTo(self.btnLoginWithWeibo.superview.mas_centerX).with.offset([BLGenernalDefinition resolutionForDevices:50.0f]);
        make.width.height.equalTo([NSNumber numberWithDouble:[BLGenernalDefinition resolutionForDevices:40.0f]]);
    }];
    
    [self.btnForgotPassword mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.tfPassword.mas_bottom).with.offset([BLGenernalDefinition resolutionForDevices:5.0f]);
        make.right.equalTo(self.tfPassword.mas_right);
    }];
}

#pragma mark - Actions
- (void)close:(id)sender {
    [self.navigationController dismissViewController];
}

- (void)login:(id)sender {
    if ([self.tfPhoneNumber.text isEqualToString:@""]) {
        UIAlertView *av = [[UIAlertView alloc] initWithTitle:nil message:NSLocalizedString(@"Please input phone number.", nil) delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil];
        [av show];
        return;
    }
    if ([self.tfPassword.text isEqualToString:@""]) {
        UIAlertView *av = [[UIAlertView alloc] initWithTitle:nil message:NSLocalizedString(@"Please input password.", nil) delegate:self cancelButtonTitle:NSLocalizedString(@"Ok", nil) otherButtonTitles:nil];
        [av show];
        return;
    }
    
    NSString *errMsg = [User validatePhoneNumber:self.tfPhoneNumber.text];
    if (errMsg) {
        UIAlertView *av = [[UIAlertView alloc] initWithTitle:nil message:errMsg delegate:self cancelButtonTitle:NSLocalizedString(@"Ok", nil) otherButtonTitles:nil];
        [av show];
        return;
    }
    
    User *user = [User new];
    user.phone = self.tfPhoneNumber.text;
    user.password = self.tfPassword.text;
    [user save];
    [_HUD show:YES];
    self.HUDState = @"YES";
    if (user.phone && user.password) {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(15.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            if ([_HUDState isEqualToString:@"YES"]) {
                UIAlertView *alertV = [[UIAlertView alloc] initWithTitle:@"网络不稳定" message:@"稍后重试" delegate:self cancelButtonTitle:NSLocalizedString(@"OK", nil) otherButtonTitles:nil, nil];
//                alertV.tag = 100;
                [alertV show];
                [_HUD hide:YES];
            }
        });
        [[BLHTTPClient sharedBLHTTPClient] login:user success:^(NSURLSessionDataTask *task, id responseObject) {
            [_HUD hide:YES];
            self.HUDState = @"NO";
            User *loginUser = [[User alloc] initWithDictionary:[responseObject objectForKey:@"user"]];
            [loginUser save];
            if ((responseObject[@"user"][@"profile"] &&
                 responseObject[@"user"][@"partner"]) &&
                (!([responseObject[@"user"][@"profile"] isKindOfClass:[NSNull class]]) &&
                 !([responseObject[@"user"][@"partner"] isKindOfClass:[NSNull class]]))) {
                //进入menuView
                if (self.delegate) {
                    [self.delegate viewController:self didLoginWithCurrentUser:loginUser];
                }
            }else {
                //进入profile
                [self dismissViewControllerAnimated:NO completion:nil];
                [self presentViewController:self.fillingInfoNavController animated:YES completion:nil];
            }
        } failure:^(NSURLSessionDataTask *task, NSError *error) {
            [_HUD hide:YES];
            self.HUDState = @"NO";
            if ([task.response isKindOfClass:[NSHTTPURLResponse class]]) {
                NSHTTPURLResponse *response = (NSHTTPURLResponse *)task.response;
                NSLog(@"Status code: %ld", (long)response.statusCode);
            }
            NSString *message = [BLHTTPClient responseMessage:task error:error];
            if (!message) {
                message = NSLocalizedString(@"Log in failed. Please try again later", nil);
            }
            UIAlertView *av = [[UIAlertView alloc] initWithTitle:nil message:NSLocalizedString(message, nil) delegate:self cancelButtonTitle:NSLocalizedString(@"Ok", nil) otherButtonTitles:nil];
            [av show];
        }];

    }
}


- (void)forgotPassword:(id)sender {
    BLForgotPasswordViewController *forgotPwViewController = [[BLForgotPasswordViewController alloc] init];
    [self presentViewController:forgotPwViewController animated:YES completion:nil];
}

#pragma mark - handle tab gesture
- (void)tapHandler:(UITapGestureRecognizer *)gesture {
    [self.tfPhoneNumber resignFirstResponder];
    [self.tfPassword resignFirstResponder];
}

#pragma mark - Private method
- (void)addHUD {
    _HUD = [[MBProgressHUD alloc] initWithView:self.view];
    [self.view addSubview:_HUD];
    _HUD.delegate = self;
    _HUD.labelText = NSLocalizedString(@"Loading", nil);
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
        _tfPhoneNumber.keyboardType = UIKeyboardTypePhonePad;
        _tfPhoneNumber.delegate = self;
        [_tfPhoneNumber showClearButton];
    }
    return _tfPhoneNumber;
}

- (BLTextField *)tfPassword {
    if (!_tfPassword) {
        _tfPassword = [[BLTextField alloc] init];
        _tfPassword.placeholder = NSLocalizedString(@"Password", nil);
        _tfPassword.secureTextEntry = YES;
        _tfPassword.delegate = self;
        _tfPassword.returnKeyType = UIReturnKeyDone;
        [_tfPassword showClearButton];
    }
    return _tfPassword;
}

- (UIButton *)btnForgotPassword {
    if (!_btnForgotPassword) {
        _btnForgotPassword = [[UIButton alloc] init];
        [_btnForgotPassword setTitle:NSLocalizedString(@"Forgot Password?", nil) forState:UIControlStateNormal];
        _btnForgotPassword.titleLabel.font = [BLFontDefinition lightItalicFont:13.0f];
        [_btnForgotPassword setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _btnForgotPassword.backgroundColor = [UIColor clearColor];
        [_btnForgotPassword addTarget:self action:@selector(forgotPassword:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _btnForgotPassword;
}

- (UIButton *)btnClose {
    if (!_btnClose) {
        _btnClose = [[UIButton alloc] init];
        [_btnClose addTarget:self action:@selector(close:) forControlEvents:UIControlEventTouchDown];
        [_btnClose setBackgroundImage:[UIImage imageNamed:@"close_icon.png"] forState:UIControlStateNormal];
    }
    return _btnClose;
}

- (UIButton *)btnLogin {
    if (!_btnLogin) {
        _btnLogin = [[UIButton alloc] init];
        [_btnLogin addTarget:self action:@selector(login:) forControlEvents:UIControlEventTouchDown];
        [_btnLogin setBackgroundColor:[BLColorDefinition greenColor]];
        [_btnLogin setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _btnLogin.titleLabel.font = [BLFontDefinition normalFont:15.0f];
        [_btnLogin setTitle:NSLocalizedString(@"Login", nil) forState:UIControlStateNormal];
        _btnLogin.layer.cornerRadius = 5.0f;
    }
    return _btnLogin;
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

- (UINavigationController *)fillingInfoNavController {
    if (!_fillingInfoNavController) {
        // Create filling information navigation controller
        BLProfileViewController *profileViewController = [[BLProfileViewController alloc] initWithNibName:nil bundle:nil];
        profileViewController.profileViewType = BLProfileViewTypeCreate;
        _fillingInfoNavController = [[UINavigationController alloc] initWithRootViewController:profileViewController];
        _fillingInfoNavController.navigationBarHidden = YES;
        
    }
    return _fillingInfoNavController;
}

#pragma mark  微信登录
- (UIButton *)btnLoginWithWeChat {
    if (!_btnLoginWithWeChat) {
        _btnLoginWithWeChat = [[UIButton alloc] init];
        _btnLoginWithWeChat.backgroundColor = [UIColor clearColor];
        [_btnLoginWithWeChat setImage:[UIImage imageNamed:@"login_with_wechat_icon.png"] forState:UIControlStateNormal];
        
        [_btnLoginWithWeChat addTarget:self action:@selector(wechatLogin:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _btnLoginWithWeChat;
}

- (void)wechatLogin:(id)sender {
    SendAuthReq* req = [[SendAuthReq alloc] init];
    if ([WXApi isWXAppInstalled] == NO) {
        req.scope = @"snsapi_userinfo";//snsapi_base只能获取到openid，意义不大，所以使用snsapi_userinfo
        req.state = kAppDescription;//随便数字
        [WXApi sendAuthReq:req viewController:self delegate:self];
        [WXApi sendReq:req];
    } else {
        req.scope = @"snsapi_userinfo";//snsapi_base只能获取到openid，意义不大，所以使用snsapi_userinfo
        req.state = kAppDescription;//随便数字
        [WXApi sendReq:req];
    }
}

#pragma mark  微博登录
- (UIButton *)btnLoginWithWeibo {
    if (!_btnLoginWithWeibo) {
        _btnLoginWithWeibo = [[UIButton alloc] init];
        _btnLoginWithWeibo.backgroundColor = [UIColor clearColor];
        [_btnLoginWithWeibo setImage:[UIImage imageNamed:@"login_with_weibo_icon.png"] forState:UIControlStateNormal];
        
        [_btnLoginWithWeibo addTarget:self action:@selector(weiboLogin:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _btnLoginWithWeibo;
}

- (void)weiboLogin:(id)sender {
    WBAuthorizeRequest *request = [WBAuthorizeRequest request];
    if ([WeiboSDK isWeiboAppInstalled] == NO) {
        request.shouldShowWebViewForAuthIfCannotSSO = YES;
        request.redirectURI = kWeiBoRedirectURL;
        request.scope = @"all";
        request.userInfo = @{@"SSO_From": @"SendMessageToWeiboViewController",
                             @"Other_Info_1": [NSNumber numberWithInt:123],
                             @"Other_Info_2": @[@"obj1", @"obj2"],
                             @"Other_Info_3": @{@"key1": @"obj1", @"key2": @"obj2"}};
        [WeiboSDK sendRequest:request];
    } else {
        request.redirectURI = kWeiBoRedirectURL;
        request.scope = @"all";
        request.userInfo = @{@"SSO_From": @"SendMessageToWeiboViewController",
                             @"Other_Info_1": [NSNumber numberWithInt:123],
                             @"Other_Info_2": @[@"obj1", @"obj2"],
                             @"Other_Info_3": @{@"key1": @"obj1", @"key2": @"obj2"}};
        [WeiboSDK sendRequest:request];
    }
}

- (UITapGestureRecognizer *)tapGestureRecognizer {
    if (!_tapGestureRecognizer) {
        _tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapHandler:)];
        _tapGestureRecognizer.delegate = self;
    }
    return _tapGestureRecognizer;
}

#pragma mark --alertViewDelegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
        switch (alertView.tag) {
            case 100:
                if (buttonIndex == 1) {

                    [BLHTTPClient cancelOperations];
                    [_HUD hide:YES];
                }
                break;
            default:
                break;
        }
}

#pragma mark --textFieldDelegate
//return方法
- (BOOL) textFieldShouldReturn:(UITextField *)textField {
    if (textField == _tfPhoneNumber) {
        [self.tfPassword becomeFirstResponder];
    } else {
        [self login:_btnLogin];
    }
    return YES;
}
//限制textField输入个数
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    
    NSString *toBeString = [textField.text stringByReplacingCharactersInRange:range withString:string];

    if (textField == _tfPhoneNumber) {
        if (toBeString.length > 11) {
            return NO;
        }
        
    } else if (textField == _tfPassword) {
        if (toBeString.length > 16) {
            return NO;
        }
    }
    return YES;
}

@end
