//
//  BLLoginView.m
//  biu
//
//  Created by Tony Wu on 6/9/15.
//  Copyright (c) 2015 BiuLove. All rights reserved.
//

#import "BLLoginView.h"
#import "BLBlurView.h"
#import "BLTextField.h"

#import "Masonry.h"

@interface BLLoginView () <UIGestureRecognizerDelegate>

@property (strong, nonatomic) UIImageView *backgroundView;
@property (strong, nonatomic) UIImageView *logoImageView;
@property (strong, nonatomic) BLTextField *tfPhoneNumber;
@property (strong, nonatomic) BLTextField *tfPassword;
@property (strong, nonatomic) UIView *orView;
@property (strong, nonatomic) UIView *lineView1;
@property (strong, nonatomic) UIView *lineView2;
@property (strong, nonatomic) UILabel *lbOr;
@property (strong, nonatomic) UIButton *btnClose;
@property (strong, nonatomic) UIButton *btnLogin;
@property (strong, nonatomic) UIButton *btnLoginWithWeChat;
@property (strong, nonatomic) UIButton *btnLoginWithWeibo;
@property (retain, nonatomic) UITapGestureRecognizer *tapGestureRecognizer;
@end

@implementation BLLoginView

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        
        _backgroundView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)];
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
        
        _tfPassword = [[BLTextField alloc] init];
        _tfPassword.placeholder = NSLocalizedString(@"Password", nil);
        _tfPassword.secureTextEntry = YES;
        [self addSubview:_tfPassword];
        
        _btnClose = [[UIButton alloc] init];
        [_btnClose addTarget:self action:@selector(close:) forControlEvents:UIControlEventTouchDown];
        [_btnClose setBackgroundImage:[UIImage imageNamed:@"close_icon.png"] forState:UIControlStateNormal];
        [self addSubview:_btnClose];
        
        _btnLogin = [[UIButton alloc] init];
        [_btnLogin addTarget:self action:@selector(login:) forControlEvents:UIControlEventTouchDown];
        [_btnLogin setBackgroundColor:[BLColorDefinition greenColor]];
        [_btnLogin setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _btnLogin.titleLabel.font = [BLFontDefinition normalFont:15.0f];
        [_btnLogin setTitle:NSLocalizedString(@"Login", nil) forState:UIControlStateNormal];
        _btnLogin.layer.cornerRadius = 5.0f;
        [self addSubview:_btnLogin];
        
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
        
        _btnLoginWithWeChat = [[UIButton alloc] init];
        _btnLoginWithWeChat.backgroundColor = [UIColor clearColor];
        [_btnLoginWithWeChat setImage:[UIImage imageNamed:@"login_with_wechat_icon.png"] forState:UIControlStateNormal];
        [self addSubview:_btnLoginWithWeChat];
        
        _btnLoginWithWeibo = [[UIButton alloc] init];
        _btnLoginWithWeibo.backgroundColor = [UIColor clearColor];
        [_btnLoginWithWeibo setImage:[UIImage imageNamed:@"login_with_weibo_icon.png"] forState:UIControlStateNormal];
        [self addSubview:_btnLoginWithWeibo];
        
        _tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapHandler:)];
        _tapGestureRecognizer.delegate = self;
        [self addGestureRecognizer:_tapGestureRecognizer];
    }
    return self;
}

- (void)layoutSubviews {
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
    
    [_tfPassword mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_tfPhoneNumber.mas_bottom).with.offset(20.0f);
        make.left.equalTo(_tfPassword.superview).with.offset(50.0f);
        make.right.equalTo(_tfPassword.superview).with.offset(-50.0f);
    }];
    
    [_btnLogin mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_tfPassword.mas_bottom).with.offset(66.0f);
        make.left.equalTo(_btnLogin.superview).with.offset(127.0f);
        make.right.equalTo(_btnLogin.superview).with.offset(-127.0f);
        make.height.equalTo(@30.0f);
    }];
    
    [_lbOr mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_btnLogin.mas_bottom).with.offset(32.0f);
        make.centerX.equalTo(_btnLogin.superview.mas_centerX);
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
    
    [_btnLoginWithWeChat mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(_btnLoginWithWeChat.superview).with.offset(-150.0f);
        make.centerX.equalTo(_btnLoginWithWeChat.superview.mas_centerX).with.offset(-50.0f);
        make.width.equalTo(@40.0f);
        make.height.equalTo(@40.0f);
    }];
    
    [_btnLoginWithWeibo mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(_btnLoginWithWeChat.superview).with.offset(-150.0f);
        make.centerX.equalTo(_btnLoginWithWeChat.superview.mas_centerX).with.offset(50.0f);
        make.width.equalTo(@40.0f);
        make.height.equalTo(@40.0f);
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

- (void)login:(id)sender {
    NSString *errMsg = [User validatePhoneNumber:_tfPhoneNumber.text];
    if (errMsg) {
        UIAlertView *av = [[UIAlertView alloc] initWithTitle:nil message:errMsg delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil];
        [av show];
        return;
    }
    
    User *user = [User new];
    user.phone = _tfPhoneNumber.text;
    user.password = _tfPassword.text;
    
    BLHTTPClient *httpClient = [BLHTTPClient sharedBLHTTPClient];
    [httpClient login:user success:^(NSURLSessionDataTask *task, id responseObject) {
//        NSLog(@"Response: %@", responseObject);
        User *loginUser = [[User alloc] initWithDictionary:[responseObject objectForKey:@"user"]];
        loginUser.phone = _tfPhoneNumber.text;
        loginUser.password = _tfPassword.text;
        if (self.delegate) {
            [self.delegate didLoginWithCurrentUser:loginUser];
        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        if ([task.response isKindOfClass:[NSHTTPURLResponse class]]) {
            NSHTTPURLResponse *response = (NSHTTPURLResponse *)task.response;
            NSLog(@"Status code: %ld", response.statusCode);
        }
        NSString *message = [BLHTTPClient responseMessage:task error:error];
        if (!message) {
            message = @"Log in failed. Please try again later";
        }
        UIAlertView *av = [[UIAlertView alloc] initWithTitle:nil message:message delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil];
        [av show];
    }];
}

#pragma mark - handle tab gesture
- (void)tapHandler:(UITapGestureRecognizer *)gesture {
    [_tfPhoneNumber resignFirstResponder];
    [_tfPassword resignFirstResponder];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
