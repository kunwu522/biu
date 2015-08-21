//
//  BLForgotPasswordView.m
//  biu
//
//  Created by Tony Wu on 7/23/15.
//  Copyright (c) 2015 BiuLove. All rights reserved.
//

#import "BLForgotPasswordView.h"
#import "BLTextField.h"
#import "Masonry.h"

@interface BLForgotPasswordView ()

@property (strong, nonatomic) UIImageView *background;
@property (strong, nonatomic) UILabel *lbTitle;
@property (strong, nonatomic) BLTextField *tfPhone;
@property (strong, nonatomic) BLTextField *tfPasscode;
@property (strong, nonatomic) BLTextField *tfPassword;
@property (strong, nonatomic) UIButton *btnDone;
@property (strong, nonatomic) UIButton *btnClose;
@property (strong, nonatomic) UIButton *btnGetCode;

@end

@implementation BLForgotPasswordView

#pragma mark -
#pragma mark Initialization
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
    [self addSubview:self.background];
    [self addSubview:self.lbTitle];
    [self addSubview:self.tfPhone];
    [self addSubview:self.tfPasscode];
    [self addSubview:self.tfPassword];
    [self addSubview:self.btnDone];
    [self addSubview:self.btnClose];
    [self addSubview:self.btnGetCode];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    [self.lbTitle sizeToFit];
    [self.lbTitle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.lbTitle.superview);
        make.top.equalTo(self.lbTitle.superview).with.offset([BLGenernalDefinition resolutionForDevices:75.0f]);
    }];
    
    [self.tfPhone mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.lbTitle.mas_bottom).with.offset([BLGenernalDefinition resolutionForDevices:90.0f]);
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
    
    [self.btnDone mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.tfPassword.mas_bottom).with.offset([BLGenernalDefinition resolutionForDevices:66.0f]);
        make.left.equalTo(self.btnDone.superview).with.offset([BLGenernalDefinition resolutionForDevices:127.0f]);
        make.right.equalTo(self.btnDone.superview).with.offset([BLGenernalDefinition resolutionForDevices:-127.0f]);
        make.height.equalTo([NSNumber numberWithDouble:([BLGenernalDefinition resolutionForDevices:30.0f])]);
    }];
}

#pragma mark - Actions
- (void)close:(id)sender {
    
}

- (void)getCode:(id)sender {
    
}

- (void)done:(id)sender {
    
    
    
    
}

#pragma mark -
#pragma mark Getter
- (UIImageView *)background {
    if (!_background) {
        _background = [[UIImageView alloc] init];
        _background.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        _background.image = [UIImage imageNamed:@"login_signup_background.png"];
    }
    return _background;
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
        _tfPhone.clearButtonMode = UITextFieldViewModeWhileEditing;
        [_tfPhone showClearButton];
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
        _tfPassword.placeholder = NSLocalizedString(@"New", nil);
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

@end
