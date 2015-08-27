//
//  BLPasswordViewController.m
//  biu
//
//  Created by Tony Wu on 6/2/15.
//  Copyright (c) 2015 BiuLove. All rights reserved.
//

#import "BLPasswordViewController.h"
#import "BLTextField.h"
#import "Masonry.h"
#import "UIViewController+BLMenuNavController.h"
#import <MBProgressHUD/MBProgressHUD.h>

@interface BLPasswordViewController () <UIGestureRecognizerDelegate, MBProgressHUDDelegate, UITextFieldDelegate> {
    MBProgressHUD *_HUD;
}

@property (strong, nonatomic) UIImageView *background;
@property (strong, nonatomic) UILabel *lbTitle;
@property (strong, nonatomic) UIButton *btnClose;
@property (strong, nonatomic) BLTextField *tfOldPassword;
@property (strong, nonatomic) BLTextField *tfNewPassword;
@property (strong, nonatomic) BLTextField *tfNewPasswordConfirmation;
@property (strong, nonatomic) UIButton *btnDone;
@property (strong, nonatomic) User *currentUser;
@property (strong, nonatomic) UITapGestureRecognizer *tapGestureRecognizer;

@end

@implementation BLPasswordViewController

#pragma mark -
#pragma mark View life cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.view addSubview:self.background];
    [self.view addSubview:self.lbTitle];
    [self.view addSubview:self.btnClose];
    [self.view addSubview:self.tfOldPassword];
    [self.view addSubview:self.tfNewPassword];
    [self.view addSubview:self.tfNewPasswordConfirmation];
    [self.view addSubview:self.btnDone];
    [self.view addGestureRecognizer:self.tapGestureRecognizer];
    [self addHUD];
    
    [self loadLayouts];
}

#pragma mark Layout
- (void)loadLayouts {
    [self.background mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.background.superview);
    }];
    
    [self.btnClose mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.btnClose.superview).with.offset([BLGenernalDefinition resolutionForDevices:32.0f]);
        make.left.equalTo(self.btnClose.superview).with.offset([BLGenernalDefinition resolutionForDevices:20.0f]);
        make.width.height.equalTo([NSNumber numberWithDouble:[BLGenernalDefinition resolutionForDevices:20.0f]]);
    }];
    
    [self.lbTitle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.lbTitle.superview);
        make.top.equalTo(self.lbTitle.superview).with.offset([BLGenernalDefinition resolutionForDevices:80.0f]);
    }];
    
    [self.tfOldPassword mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.lbTitle.mas_bottom).with.offset([BLGenernalDefinition resolutionForDevices:80.0f]);
        make.left.equalTo(self.tfOldPassword.superview).with.offset([BLGenernalDefinition resolutionForDevices:50.0f]);
        make.right.equalTo(self.tfOldPassword.superview).with.offset([BLGenernalDefinition resolutionForDevices:-50.0f]);
    }];
    
    [self.tfNewPassword mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.tfOldPassword.mas_bottom).with.offset([BLGenernalDefinition resolutionForDevices:30.0f]);
        make.left.equalTo(self.tfNewPassword.superview).with.offset([BLGenernalDefinition resolutionForDevices:50.0f]);
        make.right.equalTo(self.tfNewPassword.superview).with.offset([BLGenernalDefinition resolutionForDevices:-50.0f]);
    }];
    
    [self.tfNewPasswordConfirmation mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.tfNewPassword.mas_bottom).with.offset([BLGenernalDefinition resolutionForDevices:30.0f]);
        make.left.equalTo(self.tfNewPasswordConfirmation.superview).with.offset([BLGenernalDefinition resolutionForDevices:50.0f]);
        make.right.equalTo(self.tfNewPasswordConfirmation.superview).with.offset([BLGenernalDefinition resolutionForDevices:-50.0f]);
    }];
    
    [self.btnDone mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.tfNewPasswordConfirmation.mas_bottom).with.offset([BLGenernalDefinition resolutionForDevices:70.0f]);
        make.left.equalTo(self.btnDone.superview).with.offset([BLGenernalDefinition resolutionForDevices:127.0f]);
        make.right.equalTo(self.btnDone.superview).with.offset([BLGenernalDefinition resolutionForDevices:-127.0f]);
        make.height.equalTo([NSNumber numberWithDouble:([BLGenernalDefinition resolutionForDevices:30.0f])]);
    }];
}

#pragma mark - Actions
- (void)close:(id)sender {
    [self closeViewToRootViewController:sender];
}

- (void)done:(id)sender {
    NSString *errMsg = [User validatePassword:self.tfNewPassword.text];
    if (errMsg) {
        UIAlertView *av = [[UIAlertView alloc] initWithTitle:nil message:errMsg delegate:self cancelButtonTitle:NSLocalizedString(@"Ok", nil) otherButtonTitles:nil];
        [av show];
        return;
    }
    
    if (![self.tfNewPassword.text isEqualToString:self.tfNewPasswordConfirmation.text]) {
        UIAlertView *av = [[UIAlertView alloc] initWithTitle:nil message:NSLocalizedString(@"please enter same password", nil) delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil];
        [av show];
        return;
    }
    
    [_HUD show:YES];
    [[BLHTTPClient sharedBLHTTPClient] resetPassword:self.currentUser oldPassword:self.tfOldPassword.text newPassword:self.tfNewPassword.text success:^(NSURLSessionDataTask *task, id responseObject) {
        [_HUD hide:YES];
        UIAlertView *av = [[UIAlertView alloc] initWithTitle:nil message:NSLocalizedString(@"Reset password successed!", nil) delegate:self cancelButtonTitle:NSLocalizedString(@"Ok", nil) otherButtonTitles:nil];
        [av show];
        self.tfNewPassword.text = @"";
        self.tfOldPassword.text = @"";
        self.tfNewPasswordConfirmation.text = @"";
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        [_HUD hide:YES];
        NSString *errorMessage = [BLHTTPClient responseMessage:task error:error];
        if (!errorMessage) {
            errorMessage = NSLocalizedString(@"Reset password failed, please try again later!", nil);
        }
        UIAlertView *av = [[UIAlertView alloc] initWithTitle:nil message:errorMessage delegate:self cancelButtonTitle:NSLocalizedString(@"Ok", nil) otherButtonTitles:nil];
        [av show];
    }];
}

#pragma mark - handle tab gesture
- (void)tapHandler:(UITapGestureRecognizer *)gesture {
    [self.tfOldPassword resignFirstResponder];
    [self.tfNewPassword resignFirstResponder];
    [self.tfNewPasswordConfirmation resignFirstResponder];
}

#pragma mark - Private method
- (void)addHUD {
    _HUD = [[MBProgressHUD alloc] initWithView:self.view];
    _HUD.delegate = self;
    _HUD.labelText = NSLocalizedString(@"Uploading", nil);
    [self.view addSubview:_HUD];
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

- (UILabel *)lbTitle {
    if (!_lbTitle) {
        _lbTitle = [[UILabel alloc] init];
        _lbTitle.font = [BLFontDefinition normalFont:18.0f];
        _lbTitle.text = NSLocalizedString(@"Reset Password", nil);
        _lbTitle.textAlignment = NSTextAlignmentCenter;
        _lbTitle.textColor = [UIColor whiteColor];
    }
    return _lbTitle;
}

- (UIButton *)btnClose {
    if (!_btnClose) {
        _btnClose = [[UIButton alloc] init];
        [_btnClose addTarget:self action:@selector(close:) forControlEvents:UIControlEventTouchDown];
        [_btnClose setBackgroundImage:[UIImage imageNamed:@"close_icon.png"] forState:UIControlStateNormal];
    }
    return _btnClose;
}

- (BLTextField *)tfOldPassword {
    if (!_tfOldPassword) {
        _tfOldPassword = [[BLTextField alloc] init];
        _tfOldPassword.placeholder = NSLocalizedString(@"Old Password", nil);
        _tfOldPassword.secureTextEntry = YES;
        _tfOldPassword.clearButtonMode = UITextFieldViewModeWhileEditing;
        _tfOldPassword.delegate = self;
        [_tfOldPassword showClearButton];
    }
    return _tfOldPassword;
}

- (BLTextField *)tfNewPassword {
    if (!_tfNewPassword) {
        _tfNewPassword = [[BLTextField alloc] init];
        _tfNewPassword.placeholder = NSLocalizedString(@"New Password", nil);
        _tfNewPassword.secureTextEntry = YES;
        _tfNewPassword.clearButtonMode = UITextFieldViewModeWhileEditing;
        _tfNewPassword.delegate = self;
        [_tfNewPassword showClearButton];
    }
    return _tfNewPassword;
}

- (BLTextField *)tfNewPasswordConfirmation {
    if (!_tfNewPasswordConfirmation) {
        _tfNewPasswordConfirmation = [[BLTextField alloc] init];
        _tfNewPasswordConfirmation.placeholder = NSLocalizedString(@"Confirmation", nil);
        _tfNewPasswordConfirmation.secureTextEntry = YES;
        _tfNewPasswordConfirmation.clearButtonMode = UITextFieldViewModeWhileEditing;
        _tfNewPasswordConfirmation.delegate = self;
        _tfNewPasswordConfirmation.returnKeyType = UIReturnKeyDone;
        [_tfNewPasswordConfirmation showClearButton];
    }
    return _tfNewPasswordConfirmation;
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

- (User *)currentUser {
    if (!_currentUser) {
        _currentUser = [[User alloc] initWithFromUserDefault];
    }
    return _currentUser;
}

- (UITapGestureRecognizer *)tapGestureRecognizer {
    if (!_tapGestureRecognizer) {
        _tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapHandler:)];
        _tapGestureRecognizer.delegate = self;
    }
    return _tapGestureRecognizer;
}


#pragma mark --textFieldDelegate
//return方法
- (BOOL) textFieldShouldReturn:(UITextField *)textField {
    if (textField == _tfOldPassword) {
        [self.tfNewPassword becomeFirstResponder];
    } else if (textField == _tfNewPassword) {
        [self.tfNewPasswordConfirmation becomeFirstResponder];
    } else {
        [self done:_btnDone];
    }
    return YES;

}
//限制textField输入个数
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    
    NSString *toBeString = [textField.text stringByReplacingCharactersInRange:range withString:string];
        
    if ((textField == _tfNewPassword) || (textField == _tfOldPassword) || (textField == _tfNewPasswordConfirmation)) {
        if (toBeString.length > 16) {
            return NO;
        }
    }
    return YES;
}

@end
