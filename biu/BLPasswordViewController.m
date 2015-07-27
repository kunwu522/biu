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

@interface BLPasswordViewController ()

@property (strong, nonatomic) UILabel *lbTitle;
@property (strong, nonatomic) BLTextField *tfPhone;
@property (strong, nonatomic) BLTextField *tfPasscode;
@property (strong, nonatomic) BLTextField *tfPassword;
@property (strong, nonatomic) UIButton *btnDone;
@property (strong, nonatomic) UIButton *btnClose;

@end

@implementation BLPasswordViewController

#pragma mark -
#pragma mark View life cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark -
#pragma mark Getter
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

@end
