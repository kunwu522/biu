//
//  BLSettingViewController.m
//  biu
//
//  Created by Tony Wu on 6/2/15.
//  Copyright (c) 2015 BiuLove. All rights reserved.
//

#import "BLSettingViewController.h"
#import "BLWelcomeViewController.h"
#import "UIViewController+BLMenuNavController.h"
#import "Masonry.h"

@interface BLSettingViewController ()

@property (strong, nonatomic) UIButton *btnLogout;
@property (strong, nonatomic) UIButton *btnMenu;
@property (strong, nonatomic) UIButton *btnBackToRoot;

@end

@implementation BLSettingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    _btnLogout = [[UIButton alloc] init];
    [_btnLogout addTarget:self action:@selector(logout:) forControlEvents:UIControlEventTouchDown];
    [_btnLogout setBackgroundColor:[UIColor redColor]];
    _btnLogout.titleLabel.font = [BLFontDefinition boldFont:20.0f];
    [_btnLogout setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_btnLogout setTitle:@"LOG OUT" forState:UIControlStateNormal];
    [self.view addSubview:_btnLogout];
    
    [_btnLogout mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(_btnLogout.superview);
        make.centerY.equalTo(_btnLogout.superview).with.offset(100.0f);
        make.width.equalTo(@200);
        make.height.equalTo(@50);
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Action
- (void)logout:(id)sender {
    //TODO: clear data in NSUserDefaults
    [[BLHTTPClient sharedBLHTTPClient] logout:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        NSLog(@"User log out successful.");
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        NSLog(@"User log out failed. Error: %@", error.description);
    }];
    
    BLAppDelegate *delegate = [[UIApplication sharedApplication] delegate];
    [delegate.passwordItem resetKeychainItem];
    delegate.currentUser = nil;
    [NSUserDefaults resetStandardUserDefaults];
    
    BLWelcomeViewController *welViewController = [[BLWelcomeViewController alloc] initWithNibName:nil bundle:nil];
    UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:welViewController];
    navController.navigationBarHidden = YES;
    [self dismissViewControllerAnimated:NO completion:nil];
    [self presentViewController:navController animated:YES completion:nil];
}

- (void)showMenu:(id)sender {
    [self presentMenuViewController:sender];
}

- (void)backToRoot:(id)sender {
    [self backToRootViewController:sender];
}

#pragma mark -
#pragma mark Getter
- (UIButton *)btnMenu {
    if (!_btnMenu) {
        _btnMenu = [[UIButton alloc] init];
        [_btnMenu setBackgroundImage:[UIImage imageNamed:@"menu_icon.png"] forState:UIControlStateNormal];
        [_btnMenu addTarget:self action:@selector(showMenu:) forControlEvents:UIControlEventTouchDown];
    }
    return _btnMenu;
}

- (UIButton *)btnBackToRoot {
    if (!_btnBackToRoot) {
        _btnBackToRoot = [[UIButton alloc] init];
        [_btnBackToRoot setBackgroundImage:[UIImage imageNamed:@"back_icon2.png"] forState:UIControlStateNormal];
        [_btnBackToRoot addTarget:self action:@selector(backToRoot:) forControlEvents:UIControlEventTouchDown];
    }
    return _btnBackToRoot;
}

@end
