//
//  ViewController.m
//  biu
//
//  Created by Tony Wu on 5/5/15.
//  Copyright (c) 2015 BiuLove. All rights reserved.
//

#import "BLWelcomeViewController.h"
#import "BLLoginViewController.h"
#import "BLSignupViewController.h"
#import "BLAppDelegate.h"
#import "BLLoginView.h"
#import "BLSignupView.h"
#import "BLMatchViewController.h"
#import "BLMenuNavController.h"
#import "BLMenuViewController.h"
#import "KeychainItemWrapper.h"
#import "BLProfileViewController.h"
#import "Masonry.h"
#import <MBProgressHUD/MBProgressHUD.h>
#import "BLPartnerViewController.h"
#import "BLTextField.h"


@interface BLWelcomeViewController () <BLSignupViewControllerDelegate, BLLoginViewControllerDelegate, MBProgressHUDDelegate>

@property (strong, nonatomic) UIImageView * logo;
@property (strong, nonatomic) UILabel * biuTitle;
@property (strong, nonatomic) UILabel * biuSubtitle;
@property (strong, nonatomic) UIButton *btnLogin;
@property (strong, nonatomic) UIButton *btnSignup;
@property (strong, nonatomic) UILabel *lbSlogan;
@property (strong, nonatomic) UIView *background;
@property (strong, nonatomic) UIImageView *imageView;
@property (strong, nonatomic) UINavigationController *fillingInfoNavController;
@property (nonatomic) BOOL isLoginLayout;

@end

@implementation BLWelcomeViewController

static double ICON_INITIAL_SIZE = 147.5;

//@synthesize masterNavController;

#pragma mark - Life cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
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
        make.top.equalTo(self.view).with.offset([BLGenernalDefinition resolutionForDevices:191.8f]);
        make.width.height.equalTo([NSNumber numberWithDouble:[BLGenernalDefinition resolutionForDevices:ICON_INITIAL_SIZE]]);
    }];
    
    [_biuTitle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(_logo.mas_centerX);
        make.top.equalTo(_logo.mas_bottom).with.offset([BLGenernalDefinition resolutionForDevices:79.7f]);
    }];
    
    [_biuSubtitle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(_logo.mas_centerX);
        make.top.equalTo(_biuTitle.mas_bottom).with.offset([BLGenernalDefinition resolutionForDevices:40.0f]);
    }];
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getWeixinData:) name:@"weixinIfo" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getWeiboData:) name:@"weiboIfo" object:nil];
    
    
}

//存储微信数据
- (void)getWeixinData:(NSNotification *)noti{
    User *user = [User new];
    user.username = noti.object[@"username"];
    user.open_id = noti.object[@"openid"];
    user.avatar_url = noti.object[@"avatar_url"];
    
    [[BLHTTPClient sharedBLHTTPClient] thirdParty:user success:^(NSURLSessionDataTask *task, id responseObject) {
        
        User *thirdLoginInfo = [[User alloc] initWithDictionary:[responseObject objectForKey:@"user"]];
        [thirdLoginInfo save];
        
        if(responseObject[@"user"][@"profile"] && responseObject[@"user"][@"partner"]){
            //进入menu
            
            NSLog(@"OK======");
            BLMatchViewController *matchViewController = [[BLMatchViewController alloc] initWithNibName:nil bundle:nil];
            BLMenuViewController *menuViewController = [[BLMenuViewController alloc] init];
            UINavigationController *masterNavViewController = [[UINavigationController alloc] initWithRootViewController:matchViewController];
            masterNavViewController.navigationBarHidden = YES;
            // Create BL Menu view controller
            BLMenuNavController *menuNavController = [[BLMenuNavController alloc] initWithRootViewController:masterNavViewController
                        menuViewController:menuViewController];
            [self dismissViewControllerAnimated:NO completion:nil];
            [self presentViewController:menuNavController animated:YES completion:nil];
        } else {
            //进入填写个人信息
            NSLog(@"=====NULL======");
        
            [self dismissViewControllerAnimated:NO completion:nil];
            [self presentViewController:self.fillingInfoNavController animated:YES completion:nil];
        }
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        
        NSLog(@"failure======");
    }];

}
//存储微博数据
- (void)getWeiboData:(NSNotification*)noti{
    User *user = [User new];
    user.open_id = noti.object[@"openid"];
    user.avatar_url = noti.object[@"avatar_url"];
    user.username = [noti.object[@"username"] stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    [[NSUserDefaults standardUserDefaults] setObject:user.open_id forKey:@"open_id"];
    [[BLHTTPClient sharedBLHTTPClient] thirdParty:user success:^(NSURLSessionDataTask *task, id responseObject) {
        User *thirdLoginInfo = [[User alloc] initWithDictionary:[responseObject objectForKey:@"user"]];
        [thirdLoginInfo save];
        
        if(responseObject[@"user"][@"profile"] && responseObject[@"user"][@"partner"])  {
            //    进入login
            
            NSLog(@"OK======");
            BLMatchViewController *matchViewController = [[BLMatchViewController alloc] initWithNibName:nil bundle:nil];
            BLMenuViewController *menuViewController = [[BLMenuViewController alloc] init];
            UINavigationController *masterNavViewController = [[UINavigationController alloc] initWithRootViewController:matchViewController];
            masterNavViewController.navigationBarHidden = YES;
            // Create BL Menu view controller
            BLMenuNavController *menuNavController = [[BLMenuNavController alloc] initWithRootViewController:masterNavViewController
                        menuViewController:menuViewController];
            [self dismissViewControllerAnimated:NO completion:nil];
            [self presentViewController:menuNavController animated:YES completion:nil];
            
        } else {
            //    进入signup
            NSLog(@"=====NULL======");
            
            [self dismissViewControllerAnimated:NO completion:nil];
            [self presentViewController:self.fillingInfoNavController animated:YES completion:nil];
        }

    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        NSLog(@"failure, error: %@.", error.localizedDescription);
    }];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark --通过cookie判断登录状态
- (void)viewWillAppear:(BOOL)animated {
    // NSLog(@"deviceToken=-=-=-%@", blDelegate.deviceToken);
    // 获取cookie，判断登录状态
    NSHTTPCookie *userIdCookie = [self findCookieByName:@"user_id" isExpiredBy:(NSDate *)[NSDate date]];
    NSHTTPCookie *rememberTokenCookie = [self findCookieByName:@"remember_token" isExpiredBy:[NSDate date]];
    
    if (userIdCookie && rememberTokenCookie) {
        NSDictionary *dic = [[NSDictionary alloc] init];
        dic = [[NSUserDefaults standardUserDefaults] dictionaryRepresentation];
        User *user = [User new];
        user.userId = dic[@"user_id"];
        user.username = dic[@"username"];
        [user save];
        
        if (dic[@"user_id"]) {

            [[BLHTTPClient sharedBLHTTPClient] getUserIfo:user success:^(NSURLSessionDataTask *task, id responseObject) {
                
                User *userInfo = [[User alloc] initWithDictionary:[responseObject objectForKey:@"user"]];
                [userInfo save];
                if (!(responseObject[@"user"][@"profile"] && !responseObject[@"user"][@"partner"]) && (!([responseObject[@"user"][@"profile"] isKindOfClass:[NSNull class]]) && !([responseObject[@"user"][@"partner"] isKindOfClass:[NSNull class]]))) {//如果profile或partner不为空，从服务器获取数据应判断<null>
                    // 进入menu
                    BLMatchViewController *matchViewController = [[BLMatchViewController alloc] initWithNibName:nil bundle:nil];
                    BLMenuViewController *menuViewController = [[BLMenuViewController alloc] init];
                    UINavigationController *masterNavViewController = [[UINavigationController alloc] initWithRootViewController:matchViewController];
                    masterNavViewController.navigationBarHidden = YES;
                    // Create BL Menu view controller
                    BLMenuNavController *menuNavController = [[BLMenuNavController alloc] initWithRootViewController:masterNavViewController
                                menuViewController:menuViewController];
                    [self dismissViewControllerAnimated:NO completion:nil];
                    [self presentViewController:menuNavController animated:YES completion:nil];
                }else{
                    // 进入profile
                    [self dismissViewControllerAnimated:NO completion:nil];
                    [self presentViewController:self.fillingInfoNavController animated:YES completion:nil];
                }
                
            } failure:^(NSURLSessionDataTask *task, NSError *error) {
                NSLog(@"Failed, error: %@", error.localizedDescription);
            }];
        }
    }
    [self showLoginUI];
}

- (void)viewDidDisappear:(BOOL)animated {
    BLAppDelegate *blDelegate = (BLAppDelegate *)[[UIApplication sharedApplication] delegate];
    NSDictionary *dic = [[NSDictionary alloc] init];
    dic = [[NSUserDefaults standardUserDefaults] dictionaryRepresentation];
    User *user = [User new];
    user.userId = dic[@"user_id"];
    
    if (blDelegate.deviceToken && user.userId) {
        [[BLHTTPClient sharedBLHTTPClient] registToken:blDelegate.deviceToken user:user success:^(NSURLSessionDataTask *task, id responseObject) {
            NSLog(@"Regist device token successed.");
        } failure:^(NSURLSessionDataTask *task, NSError *error) {
            NSLog(@"Regist device token failed. error: %@", error.localizedDescription);
        }];
    }

}

#pragma mark --取出cookie
- (NSHTTPCookie *) findCookieByName:(NSString *)name isExpiredBy:(NSDate *)time {
    NSArray *cookies = [[NSHTTPCookieStorage sharedHTTPCookieStorage] cookies];
    if (!cookies || cookies.count == 0) {
        return nil;
    }
    for (NSHTTPCookie *cookie in cookies) {
        if ([cookie.name isEqualToString:name] && [cookie.expiresDate compare:time] == NSOrderedDescending) {
            return cookie;
        }
    }
    return nil;
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
        [UIView animateWithDuration:1.0 animations:^{
            _btnLogin.alpha = 1;
            _btnSignup.alpha = 1;
        }];
    }];
    _isLoginLayout = YES;
}

- (void)loginViewLayout {
    [_logo mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view).with.offset([BLGenernalDefinition resolutionForDevices:120.7f]);
        make.width.height.equalTo([NSNumber numberWithDouble:[BLGenernalDefinition resolutionForDevices:120.0f]]);
    }];
    
    [_biuTitle mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_logo.mas_bottom).with.offset([BLGenernalDefinition resolutionForDevices:30.0f]);
    }];
    
    [_biuSubtitle mas_updateConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(_logo.mas_centerX);
        make.top.equalTo(_biuTitle.mas_bottom).with.offset([BLGenernalDefinition resolutionForDevices:30.0f]);
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
        make.top.equalTo(_biuTitle.mas_bottom).with.offset([BLGenernalDefinition resolutionForDevices:25.0f]);
        make.left.equalTo(self.view).with.offset([BLGenernalDefinition resolutionForDevices:47.2f]);
        make.right.equalTo(self.view).with.offset([BLGenernalDefinition resolutionForDevices:-47.2f]);
        make.height.equalTo([NSNumber numberWithDouble:[BLGenernalDefinition resolutionForDevices:100.0f]]);
    }];
    
    [_btnLogin mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(_btnSignup.superview).with.offset(-5);
        make.left.equalTo(self.view).with.offset(5);
        make.right.equalTo(_btnSignup.mas_left).with.offset(-3);
        make.height.equalTo([NSNumber numberWithDouble:[BLGenernalDefinition resolutionForDevices:40.0f]]);
        make.width.equalTo(_btnSignup.mas_width);
    }];
    
    [_btnSignup mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(_btnLogin.superview).with.offset(-5);
        make.right.equalTo(self.view).with.offset(-5);
        make.height.equalTo([NSNumber numberWithDouble:[BLGenernalDefinition resolutionForDevices:40.0f]]);
        make.width.equalTo(_btnLogin.mas_width);
    }];
}

- (void)showLoginView:(id)sender {
    BLLoginViewController *loginViewController = [[BLLoginViewController alloc] init];
    loginViewController.delegate = self;
    [self presentViewController:loginViewController animated:YES completion:nil];
}

- (void)showSignupView:(id)sender {
    BLSignupViewController *signupViewController = [[BLSignupViewController alloc] init];
    signupViewController.delegate = self;
    [self presentViewController:signupViewController animated:YES completion:nil];
}

#pragma mark - BLLoginViewController delegate and BLSignupView delegate
- (void)viewController:(UIViewController *)controller didLoginWithCurrentUser:(User *)user {
    BLMatchViewController *matchViewController = [[BLMatchViewController alloc] initWithNibName:nil bundle:nil];
    BLMenuViewController *menuViewController = [[BLMenuViewController alloc] init];
    UINavigationController *masterNavViewController = [[UINavigationController alloc] initWithRootViewController:matchViewController];
    masterNavViewController.navigationBarHidden = YES;
    // Create BL Menu view controller
    BLMenuNavController *menuNavController = [[BLMenuNavController alloc] initWithRootViewController:masterNavViewController
                menuViewController:menuViewController];
    [controller presentViewController:menuNavController animated:YES completion:nil];
}

- (void)viewController:(UIViewController *)controller didSignupWithNewUser:(User *)user {
    [controller presentViewController:self.fillingInfoNavController animated:YES completion:nil];
}

#pragma mark - private method

#pragma mark -
#pragma mark Getter
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

@end





