//
//  BLSignupView.m
//  biu
//
//  Created by Tony Wu on 6/9/15.
//  Copyright (c) 2015 BiuLove. All rights reserved.
//

#import "BLSignupView.h"
#import "BLTextField.h"

@interface BLSignupView ()

@property (strong, nonatomic) UIImageView *backgroundView;
@property (strong, nonatomic) UIImageView *logoImageView;

@property (strong, nonatomic) BLTextField *tfPhoneNumber;
@property (strong, nonatomic) BLTextField *tfCode;
@property (strong, nonatomic) BLTextField *tfPassword;

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

@end

@implementation BLSignupView

- (void)setup {
    self.backgroundColor = [UIColor clearColor];
    
    _backgroundView = [[UIImageView alloc] init];
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
    
    _tfCode = [[BLTextField alloc] init];
    _tfCode.placeholder = NSLocalizedString(@"Code", nil);
    _tfCode.keyboardType = UIKeyboardTypePhonePad;
    [self addSubview:_tfCode];
    
    _tfPassword = [[BLTextField alloc] init];
    _tfPassword.placeholder = NSLocalizedString(@"Password", nil);
    _tfPassword.secureTextEntry = YES;
    [self addSubview:_tfPassword];
    
    _btnClose = [[UIButton alloc] init];
    [_btnClose addTarget:self action:@selector(close:) forControlEvents:UIControlEventTouchDown];
    [_btnClose setBackgroundImage:[UIImage imageNamed:@"close_icon.png"] forState:UIControlStateNormal];
    [self addSubview:_btnClose];
    
    _btnSignup = [[UIButton alloc] init];
    [_btnSignup addTarget:self action:@selector(signup:) forControlEvents:UIControlEventTouchDown];
    [_btnSignup setBackgroundColor:[BLColorDefinition greenColor]];
    [_btnSignup setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    _btnSignup.titleLabel.font = [BLFontDefinition normalFont:15.0f];
    [_btnSignup setTitle:NSLocalizedString(@"Sign Up", nil) forState:UIControlStateNormal];
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
}

- (void)layoutSubviews {
    
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
