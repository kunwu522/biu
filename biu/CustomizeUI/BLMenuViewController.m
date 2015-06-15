//
//  BLMenuViewViewController.m
//  biu
//
//  Created by WuTony on 5/31/15.
//  Copyright (c) 2015 BiuLove. All rights reserved.
//

#import "BLMenuViewController.h"
#import "BLProfileViewController.h"
#import "BLPasswordViewController.h"
#import "BLPartnerViewController.h"
#import "BLSettingViewController.h"

#import "BLBlurView.h"
#import "Masonry.h"

@interface BLMenuViewController ()

typedef NS_ENUM(NSUInteger, BLSubViewController) {
    BLSubViewControllerRoot = 0,
    BLSubViewControllerProfile = 1,
    BLSubViewControllerPassword = 2,
    BLSubViewControllerPartner = 3,
    BLSubViewControllerSetting = 4
};

@property (retain, nonatomic) UIView *background;
@property (strong, nonatomic) UIView *contentView;
@property (retain, nonatomic) UITapGestureRecognizer *tapRecognizer;

@property (retain, nonatomic) UIButton *btnMenu;
@property (retain, nonatomic) UIView *menuView;
@property (retain, nonatomic) BLBlurView *blurView;
@property (retain, nonatomic) UIButton *btnBack;
@property (retain, nonatomic) UIImageView *avatorImageView;
@property (retain, nonatomic) UILabel *lbUsername;
@property (retain, nonatomic) UIImageView *photoImageView;
@property (retain, nonatomic) UIButton *btnMe;
@property (retain, nonatomic) UIImageView *passwordImageView;
@property (retain, nonatomic) UIButton *btnPassword;
@property (retain, nonatomic) UIImageView *partnerImageView;
@property (retain, nonatomic) UIButton *btnPartner;
@property (retain, nonatomic) UIImageView *settingImageView;
@property (retain, nonatomic) UIButton *btnSetting;

@property (strong, nonatomic) NSDictionary *subViewControllers;
@property (strong, nonatomic) NSDictionary *subViewControllersButton;
@property (assign, nonatomic) BLSubViewController selectedController;
@property (strong, nonatomic) UIViewController *selectedViewController;

@end

@implementation BLMenuViewController

- (id)initWithRootViewControllr:(UIViewController *)rootController {
    self = [super init];
    if (self) {
        self.selectedViewController = rootController;
        
        BLProfileViewController *profileViewController = [[BLProfileViewController alloc] initWithNibName:nil bundle:nil];
        profileViewController.profileViewType = BLProfileViewTypeUpdate;
        BLPasswordViewController *passwordViewController = [[BLPasswordViewController alloc] initWithNibName:nil bundle:nil];
        BLPartnerViewController *partnerViewController = [[BLPartnerViewController alloc] initWithNibName:nil bundle:nil];
        BLSettingViewController *settingViewController = [[BLSettingViewController alloc] initWithNibName:nil bundle:nil];
        _subViewControllers = @{[NSNumber numberWithInteger:BLSubViewControllerRoot] : rootController,
                             [NSNumber numberWithInteger:BLSubViewControllerProfile] : profileViewController,
                            [NSNumber numberWithInteger:BLSubViewControllerPassword] : passwordViewController,
                             [NSNumber numberWithInteger:BLSubViewControllerPartner] : partnerViewController,
                             [NSNumber numberWithInteger:BLSubViewControllerSetting] : settingViewController};

        
        [self setupMenuButton];
        [self setupMenuController];
        
        _subViewControllersButton = @{[NSNumber numberWithInteger:BLSubViewControllerRoot] : _btnMenu,
                                   [NSNumber numberWithInteger:BLSubViewControllerProfile] : _btnMe,
                                  [NSNumber numberWithInteger:BLSubViewControllerPassword] : _btnPassword,
                                   [NSNumber numberWithInteger:BLSubViewControllerPartner] : _btnPartner,
                                   [NSNumber numberWithInteger:BLSubViewControllerSetting] : _btnSetting};
        
        _tapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapRecognized:)];
        [_menuView addGestureRecognizer:_tapRecognizer];
        
        _contentView = rootController.view;
        [self.view insertSubview:_contentView belowSubview:_btnMenu];
    }
    
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)selectController:(BLSubViewController)controller {
    if (_selectedController != controller) {
        if (controller != BLSubViewControllerRoot) {
            _btnBack.alpha = 1.0f;
        }
        _selectedViewController = [_subViewControllers objectForKey:[NSNumber numberWithInteger:controller]];
        _selectedController = controller;
        
        _selectedViewController.view.frame = self.view.bounds;
        [_contentView removeFromSuperview];
        _contentView = _selectedViewController.view;
        [self.view insertSubview:_contentView belowSubview:_btnMenu];
    }
    [self closeMenu];
}

#pragma mark - Handle action
- (void)showMenu:(UIButton *)sender {
    [_blurView blurWithView:_selectedViewController.view];
    [UIView animateWithDuration:0.2f animations:^{
        _menuView.alpha = 1.0f;
    }];
}

- (void)tapRecognized:(UITapGestureRecognizer *)tapRecognized {
    [self closeMenu];
}

- (void)pressButton:(UIButton *)sender {
    [self selectController:sender.tag];
}

- (void)backToRoot:(id)sender {
    UIGraphicsBeginImageContextWithOptions(CGSizeMake(CGRectGetWidth(self.view.frame), CGRectGetHeight(self.view.frame)), NO, 1);
    [_contentView drawViewHierarchyInRect:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height) afterScreenUpdates:NO];
    
    UIImage *snapshot = UIGraphicsGetImageFromCurrentImageContext();
    UIImageView *tmpView = [[UIImageView alloc] initWithFrame:self.view.bounds];
    tmpView.image = snapshot;
    [self.view addSubview:tmpView];
    
    _selectedViewController = [_subViewControllers objectForKey:[NSNumber numberWithInteger:BLSubViewControllerRoot]];
    _selectedController = BLSubViewControllerRoot;
    
    [_contentView removeFromSuperview];
    _contentView = _selectedViewController.view;
    CGPoint center = _contentView.center;
    center.x -= self.view.bounds.size.width;
    _contentView.center = center;
    [self.view insertSubview:_contentView belowSubview:_btnMenu];
    
    _btnBack.alpha = 0.0f;
    [UIView animateWithDuration:0.3f delay:0.0f options:UIViewAnimationOptionCurveEaseInOut animations:^{
        CGPoint center1 = tmpView.center;
        CGPoint center2 = _contentView.center;
        center1.x += self.view.bounds.size.width;
        center2.x += self.view.bounds.size.width;
        tmpView.center = center1;
        _contentView.center = center2;
    } completion:^(BOOL finished) {
        [tmpView removeFromSuperview];
    }];
}


#pragma mark - private method
- (void)closeMenu {
    [UIView animateWithDuration:0.2f animations:^{
        _menuView.alpha = 0.0f;
    }];
}

#pragma mark - setup menu view and button
- (void)setupMenuButton {
    _btnMenu = [[UIButton alloc] init];
    [_btnMenu setBackgroundImage:[UIImage imageNamed:@"menu_icon.png"] forState:UIControlStateNormal];
    [_btnMenu addTarget:self action:@selector(showMenu:) forControlEvents:UIControlEventTouchDown];
    [self.view addSubview:_btnMenu];
    
    _btnBack = [[UIButton alloc] init];
    [_btnBack setBackgroundImage:[UIImage imageNamed:@"back_icon2.png"] forState:UIControlStateNormal];
    [_btnBack addTarget:self action:@selector(backToRoot:) forControlEvents:UIControlEventTouchDown];
    _btnBack.alpha = 0.0f;
    [self.view addSubview:_btnBack];
    
    [_btnMenu mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view).with.offset(31.2);
        make.right.equalTo(self.view).with.offset(-20.8);
        make.width.equalTo(@45.3);
        make.height.equalTo(@45.3);
    }];
    
    [_btnBack mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_btnBack.superview).with.offset(31.2f);
        make.left.equalTo(_btnBack.superview).with.offset(20.8f);
        make.width.equalTo(@45.3);
        make.height.equalTo(@45.3);
    }];
}

- (void)setupMenuController {
    _menuView = [[UIView alloc] initWithFrame:self.view.bounds];
    _menuView.backgroundColor = [UIColor clearColor];
    _menuView.alpha = 0;
    [self.view addSubview:_menuView];
    
    _blurView = [[BLBlurView alloc] initWithFrame:_menuView.bounds];
    [_menuView addSubview:_blurView];
    
    _avatorImageView = [[UIImageView alloc] init];
    _avatorImageView.image = [UIImage imageNamed:@"test_avator.png"];
    _avatorImageView.layer.cornerRadius = 97.0 / 2;
    _avatorImageView.layer.borderWidth = 4.0f;
    _avatorImageView.layer.borderColor = [[UIColor whiteColor] CGColor];
    [_menuView addSubview:_avatorImageView];
    
    _lbUsername = [[UILabel alloc] init];
    _lbUsername.font = [BLFontDefinition boldFont:15.0f];
    _lbUsername.textColor = [UIColor whiteColor];
    _lbUsername.text = @"Tony";
    [_menuView addSubview:_lbUsername];
    
    _photoImageView = [[UIImageView alloc] init];
    _photoImageView.image = [UIImage imageNamed:@"me_icon.png"];
    [_menuView addSubview:_photoImageView];
    
    _btnMe = [[UIButton alloc] init];
    _btnMe.tag = BLSubViewControllerProfile;
    _btnMe.titleLabel.font = [BLFontDefinition normalFont:20.0f];
    [_btnMe setTitleColor:[BLColorDefinition menuFontColor] forState:UIControlStateNormal];
    [_btnMe setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
    [_btnMe setTitle:@"Me" forState:UIControlStateNormal];
    [_btnMe addTarget:self action:@selector(pressButton:) forControlEvents:UIControlEventTouchDown];
    [_menuView addSubview:_btnMe];
    
    _passwordImageView = [[UIImageView alloc] init];
    _passwordImageView.image = [UIImage imageNamed:@"password_icon.png"];
    [_menuView addSubview:_passwordImageView];
    
    _btnPassword = [[UIButton alloc] init];
    _btnPassword.tag = BLSubViewControllerPassword;
    _btnPassword.titleLabel.font = [BLFontDefinition normalFont:20.0f];
    [_btnPassword setTitleColor:[BLColorDefinition menuFontColor] forState:UIControlStateNormal];
    [_btnPassword setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
    [_btnPassword setTitle:@"Password" forState:UIControlStateNormal];
    [_btnPassword addTarget:self action:@selector(pressButton:) forControlEvents:UIControlEventTouchDown];
    [_menuView addSubview:_btnPassword];
    
    _partnerImageView = [[UIImageView alloc] init];
    _partnerImageView.image = [UIImage imageNamed:@"partner_icon.png"];
    [_menuView addSubview:_partnerImageView];
    
    _btnPartner = [[UIButton alloc] init];
    _btnPartner.tag = BLSubViewControllerPartner;
    _btnPartner.titleLabel.font = [BLFontDefinition normalFont:20.0f];
    [_btnPartner setTitleColor:[BLColorDefinition menuFontColor] forState:UIControlStateNormal];
    [_btnPartner setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
    [_btnPartner setTitle:@"Partner" forState:UIControlStateNormal];
    [_btnPartner addTarget:self action:@selector(pressButton:) forControlEvents:UIControlEventTouchDown];
    [_menuView addSubview:_btnPartner];
    
    _settingImageView = [[UIImageView alloc] init];
    _settingImageView.image = [UIImage imageNamed:@"setting_icon.png"];
    [_menuView addSubview:_settingImageView];
    
    _btnSetting = [[UIButton alloc] init];
    _btnSetting.tag = BLSubViewControllerSetting;
    _btnSetting.titleLabel.font = [BLFontDefinition normalFont:20.0f];
    [_btnSetting setTitleColor:[BLColorDefinition menuFontColor] forState:UIControlStateNormal];
    [_btnSetting setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
    [_btnSetting setTitle:@"Settings" forState:UIControlStateNormal];
    [_btnSetting addTarget:self action:@selector(pressButton:) forControlEvents:UIControlEventTouchDown];
    [_menuView addSubview:_btnSetting];
    
    [_avatorImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_avatorImageView.superview).with.offset(108.0);
        make.centerX.equalTo(_avatorImageView.superview.mas_centerX);
        make.width.equalTo(@97.0f);
        make.height.equalTo(@97.0f);
    }];
    
    [_lbUsername mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(_lbUsername.superview.mas_centerX);
        make.top.equalTo(_avatorImageView.mas_bottom).with.offset(23.6f);
    }];
    
    [_settingImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(_settingImageView.superview).with.offset(-79.0f);
        make.left.equalTo(_settingImageView.superview).with.offset(70.8f);
        make.width.equalTo(@35.4f);
        make.height.equalTo(@35.4f);
    }];
    
    [_btnSetting mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(_settingImageView.mas_centerY);
        make.left.equalTo(_settingImageView.mas_right).with.offset(20.7f);
    }];
    
    [_partnerImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(_settingImageView.mas_top).with.offset(-39.0f);
        make.left.equalTo(_partnerImageView.superview).with.offset(70.8f);
        make.width.equalTo(@35.4f);
        make.height.equalTo(@35.4f);
    }];
    
    [_btnPartner mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(_partnerImageView.mas_centerY);
        make.left.equalTo(_partnerImageView.mas_right).with.offset(20.7f);
    }];
    
    [_passwordImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(_partnerImageView.mas_top).with.offset(-39.0f);
        make.left.equalTo(_passwordImageView.superview).with.offset(70.8f);
        make.width.equalTo(@35.4f);
        make.height.equalTo(@35.4f);
    }];
    
    [_btnPassword mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(_passwordImageView.mas_centerY);
        make.left.equalTo(_passwordImageView.mas_right).with.offset(20.7f);
    }];
    
    [_photoImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(_passwordImageView.mas_top).with.offset(-39.0f);
        make.left.equalTo(_photoImageView.superview).with.offset(70.8f);
        make.width.equalTo(@35.4f);
        make.height.equalTo(@35.4f);
    }];
    
    [_btnMe mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(_photoImageView.mas_centerY);
        make.left.equalTo(_photoImageView.mas_right).with.offset(20.7f);
    }];
}

@end
