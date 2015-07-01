//
//  ViewController.m
//  biu
//
//  Created by Tony Wu on 5/5/15.
//  Copyright (c) 2015 BiuLove. All rights reserved.
//

#import "BLWelcomeViewController.h"
#import "BLAppDeleate.h"
#import "BLLoginViewController.h"
#import "BLLoginView.h"
#import "BLSignupView.h"
#import "BLSignupViewController.h"
#import "BLMatchViewController.h"
#import "KeychainItemWrapper.h"
#import "Masonry.h"

#import "BLTextField.h"


@interface BLWelcomeViewController () <BLSignupViewDelegate, BLLoginViewDelegate>

@property (retain, nonatomic) KeychainItemWrapper *passwordItem;

@property (retain, nonatomic) UIImageView * logo;
@property (retain, nonatomic) UILabel * biuTitle;
@property (retain, nonatomic) UILabel * biuSubtitle;

//For login view
@property (retain, nonatomic) BLTextField * tfEmail;
@property (retain, nonatomic) BLTextField * txtPassword;
@property (retain, nonatomic) UILabel *lbLoginWith;
@property (retain, nonatomic) UIButton *btnLogin;
@property (retain, nonatomic) UIButton *btnSignup;
@property (retain, nonatomic) UILabel *lbSlogan;

@property (retain, nonatomic) UIView *background;
@property (retain, nonatomic) UIImageView *imageView;

@property (nonatomic) BOOL isLoginLayout;


@end

@implementation BLWelcomeViewController

static double ICON_INITIAL_SIZE = 147.5;

@synthesize masterNavController;

#pragma mark - Life cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    NSLog(@"View frame: %f-%f", self.view.frame.size.width, self.view.frame.size.height);
    
    _isLoginLayout = NO;
    
    self.view.backgroundColor = [UIColor clearColor];
    
    _background = [[UIView alloc] initWithFrame:self.view.frame];
    _imageView = [[UIImageView alloc] initWithFrame:_background.frame];
    _imageView.image = [UIImage imageNamed:@"wel_background.png"];
    _imageView.contentMode = UIViewContentModeScaleAspectFill;
    [_background addSubview:_imageView];
    [self.view addSubview:_background];
    
    //Initial View
    _logo = [[UIImageView alloc] init];
    _logo.image = [UIImage imageNamed:@"logo.png"];
    [self.view addSubview:_logo];
    
    _biuTitle = [[UILabel alloc] init];
    _biuTitle.text = NSLocalizedString(@"BIU", nil);
    _biuTitle.font = [BLFontDefinition boldFont:45.0f];
    _biuTitle.textColor = [UIColor whiteColor];
    _biuTitle.textAlignment = NSTextAlignmentCenter;
    _biuTitle.adjustsFontSizeToFitWidth = YES;
    [self.view addSubview:_biuTitle];
    
    _biuSubtitle = [[UILabel alloc] init];
    _biuSubtitle.text = NSLocalizedString(@"I ' M   C L O S E", nil);
    _biuSubtitle.font = [BLFontDefinition boldFont:15.0f];
    _biuSubtitle.textColor = [UIColor colorWithRed:89.0 / 255.0 green:96.0 / 255.0 blue:104.0 / 255.0 alpha:1];
    _biuSubtitle.textAlignment = NSTextAlignmentCenter;
    _biuSubtitle.adjustsFontSizeToFitWidth = YES;
    [self.view addSubview:_biuSubtitle];
    
    // Create constraints
    [_logo mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view.mas_centerX);
        make.top.equalTo(self.view).with.offset(191.8);
        make.height.equalTo([NSNumber numberWithDouble:ICON_INITIAL_SIZE]);
        make.width.equalTo([NSNumber numberWithDouble:ICON_INITIAL_SIZE]);
    }];
    
    [_biuTitle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(_logo.mas_centerX);
        make.top.equalTo(_logo.mas_bottom).with.offset(79.7);
    }];
    
    [_biuSubtitle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(_logo.mas_centerX);
        make.top.equalTo(_biuTitle.mas_bottom).with.offset(40);
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidAppear:(BOOL)animated {
    sleep(1);
    
    BLAppDeleate *delegate = [[UIApplication sharedApplication] delegate];
    if (!delegate.currentUser) {
        [self showLoginUI];
    } else {
        [[BLHTTPClient sharedBLHTTPClient] login:delegate.currentUser success:^(NSURLSessionDataTask *task, id responseObject) {
            BLAppDeleate *delegate = [[UIApplication sharedApplication] delegate];
            delegate.currentUser = [[User alloc] initWithDictionary:responseObject];
            [delegate.currentUser save];
            if (delegate.currentUser.profile && delegate.currentUser.partner) {
                [self dismissViewControllerAnimated:NO completion:nil];
                [self presentViewController:delegate.blurMenu animated:YES completion:nil];
            } else {
                [self presentViewController:delegate.fillingInfoNavController animated:YES completion:nil];
            }
        } failure:^(NSURLSessionDataTask *task, NSError *error) {
            NSLog(@"Validate user failed: %@, code: %li", error.description, (long)error.code);
            [self showLoginUI];
        }];
    }

}

- (void)showLoginUI {
    if (_isLoginLayout) {
        return;
    }
    
    [self loginViewLayout];
    [UIView animateWithDuration:0.5 animations:^{
        [self.view layoutIfNeeded];
        _biuTitle.transform = CGAffineTransformScale(_biuTitle.transform, 0.67, 0.67);
    } completion:^(BOOL finished) {
        // TODO: show login input and button
        [UIView animateWithDuration:1.0 animations:^{
            _btnLogin.alpha = 1;
            _btnSignup.alpha = 1;
        }];
    }];
    _isLoginLayout = YES;
}

- (BOOL)checkUserLogin {
    BLAppDeleate *delegate = [[UIApplication sharedApplication] delegate];
    _passwordItem = delegate.passwordItem;
    
    NSString *username = [_passwordItem objectForKey:(__bridge id)kSecAttrAccount];
    NSString *password = [_passwordItem objectForKey:(__bridge id)kSecValueData];
    
    if ([username isEqualToString:@""] || [password isEqualToString:@""]) {
        return NO;
    }
    
    //TODO: validate username&password by connection with server
    
    
    return YES;
}

- (void)login {
    
}

- (void)signup {
    
}

- (void)loginViewLayout {
    [_logo mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view).with.offset(120.7);
        make.height.equalTo(@120.0);
        make.width.equalTo(@120.0);
    }];
    
    [_biuTitle mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_logo.mas_bottom).with.offset(30.0f);
    }];
    
    [_biuSubtitle mas_updateConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(_logo.mas_centerX);
        make.top.equalTo(_biuTitle.mas_bottom).with.offset(30.0f);
    }];
    
    _btnLogin = [[UIButton alloc] init];
    [_btnLogin addTarget:self action:@selector(showLoginView:) forControlEvents:UIControlEventTouchDown];
    [_btnLogin setTitle:NSLocalizedString(@"Login", nil) forState:UIControlStateNormal];
    _btnLogin.titleLabel.font = [BLFontDefinition normalFont:16];
    _btnLogin.titleLabel.textColor = [UIColor whiteColor];
    _btnLogin.backgroundColor = [UIColor colorWithRed:93.0 / 255.0 green:112.0 / 255.0 blue:129.0 / 255.0 alpha:1];
    _btnLogin.layer.cornerRadius = 5;
    [self.view addSubview:_btnLogin];
    _btnLogin.alpha = 0;
    
    _btnSignup = [[UIButton alloc] init];
    [_btnSignup addTarget:self action:@selector(showSignupView:) forControlEvents:UIControlEventTouchDown];
    [_btnSignup setTitle:NSLocalizedString(@"Sign up", nil) forState:UIControlStateNormal];
    _btnSignup.titleLabel.font = [BLFontDefinition normalFont:16];
    _btnSignup.titleLabel.textColor = [UIColor whiteColor];
    _btnSignup.backgroundColor = [UIColor colorWithRed:19.0 / 255.0 green:183.0 / 255.0 blue:120.0 / 255.0 alpha:1];
    _btnSignup.layer.cornerRadius = 5;
    [self.view addSubview:_btnSignup];
    _btnSignup.alpha = 0;

    [_lbSlogan mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_biuTitle.mas_bottom).with.offset(25.0);
        make.left.equalTo(self.view).with.offset(47.2);
        make.right.equalTo(self.view).with.offset(-47.2);
        make.height.equalTo(@100);
    }];
    
    [_btnLogin mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(_btnSignup.superview).with.offset(-5);
        make.left.equalTo(self.view).with.offset(5);
        make.right.equalTo(_btnSignup.mas_left).with.offset(-3);
        make.height.equalTo(@40.0f);
        make.width.equalTo(_btnSignup.mas_width);
    }];
    
    [_btnSignup mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(_btnLogin.superview).with.offset(-5);
//        make.left.equalTo(_btnLogin.mas_right).with.offset(5);
        make.right.equalTo(self.view).with.offset(-5);
        make.height.equalTo(@40.0f);
        make.width.equalTo(_btnLogin.mas_width);
    }];
}

- (void)showLoginView:(id)sender {
    BLLoginView *loginView = [[BLLoginView alloc] initWithFrame:CGRectMake(0, self.view.bounds.size.height, self.view.bounds.size.width, self.view.bounds.size.height)];
    loginView.delegate = self;
    [self.view addSubview:loginView];
    
    [UIView animateWithDuration:0.3f animations:^{
        CGPoint center = loginView.center;
        center.y = self.view.center.y;
        loginView.center = center;
    }];
}

- (void)showSignupView:(id)sender {
    BLSignupView *signupView = [[BLSignupView alloc] initWithFrame:CGRectMake(0, self.view.bounds.size.height, self.view.bounds.size.width, self.view.bounds.size.height)];
    signupView.delegate = self;
    [self.view addSubview:signupView];
    [UIView animateWithDuration:0.3f animations:^{
        CGPoint center = signupView.center;
        center.y = self.view.center.y;
        signupView.center = center;
    }];
}

#pragma mark - BLLoginView delegate and BLSignupView delegate
- (void)didLoginWithCurrentUser:(User *)user {
    [self saveCurrentUser:user];
    BLAppDeleate *appDelegate = [[UIApplication sharedApplication] delegate];
    [self presentViewController:appDelegate.blurMenu animated:YES completion:nil];
}

- (void)didSignupWithNewUser:(User *)user {
    [self saveCurrentUser:user];
    BLAppDeleate *appDelegate = [[UIApplication sharedApplication] delegate];
    [self presentViewController:appDelegate.fillingInfoNavController animated:YES completion:nil];
}

#pragma mark - private method
- (void)saveCurrentUser:(User *)user {
    BLAppDeleate *delegate = [[UIApplication sharedApplication] delegate];
    delegate.currentUser = user;
    [delegate.currentUser save];
    
    [[BLHTTPClient sharedBLHTTPClient] deviceToken:delegate.deviceToken user:delegate.currentUser success:^(NSURLSessionDataTask *task, id responseObject) {
        NSLog(@"regist device successed.");
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        NSLog(@"Regist device failed, error: %@", error.localizedDescription);
        UIAlertView *av = [[UIAlertView alloc] initWithTitle:nil message:NSLocalizedString(@"System error", nil) delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil];
        [av show];
    }];
}

@end
