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
#import "UIViewController+BLMenuNavController.h"
#import "BLMenuNavController.h"
#import "BLMenuButton.h"
#import "Masonry.h"

#import <SDWebImage/UIImageView+WebCache.h>

@interface BLMenuViewController ()

typedef NS_ENUM(NSUInteger, BLSubViewController) {
    BLSubViewControllerRoot = 0,
    BLSubViewControllerProfile = 1,
    BLSubViewControllerPassword = 2,
    BLSubViewControllerPartner = 3,
    BLSubViewControllerSetting = 4
};

@property (strong, nonatomic) User *currentUser;
@property (strong, nonatomic) UIImageView *background;
@property (strong, nonatomic) UIImageView *avatarImageView;
@property (strong, nonatomic) UILabel *lbUsername;
@property (strong, nonatomic) BLMenuButton *btnMe;
@property (strong, nonatomic) BLMenuButton *btnPassword;
@property (strong, nonatomic) BLMenuButton *btnPartner;
@property (strong, nonatomic) BLMenuButton *btnSetting;

@end

@implementation BLMenuViewController

#pragma mark -
#pragma mark View Life Cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor clearColor];
    
    [self.view addSubview:self.background];
    [self.view addSubview:self.avatarImageView];
    [self.view addSubview:self.lbUsername];
    [self.view addSubview:self.btnMe];
    [self.view addSubview:self.btnPartner];
    [self.view addSubview:self.btnPassword];
    [self.view addSubview:self.btnSetting];
    
    [self layoutSubViews];
    
    UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideMenu:)];
    [self.view addGestureRecognizer:tapGestureRecognizer];
}

- (void)viewWillAppear:(BOOL)animated {
    [self.avatarImageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@cycle/avatar/%@", [BLHTTPClient blBaseURL], self.currentUser.userId]]
                            placeholderImage:[UIImage imageNamed:@"avatar_upload_icon.png"]
                                     options:SDWebImageRefreshCached | SDWebImageHandleCookies];
    self.lbUsername.text = self.currentUser.username;
}

#pragma mark -
#pragma mark Actions
- (void)hideMenu:(UITapGestureRecognizer *)tapRecognized {
    [self.menuNavController hideMenuViewController];
}

- (void)pressButton:(UIButton *)sender {
    switch (sender.tag) {
        case BLSubViewControllerProfile:
        {
            BLProfileViewController *profileViewController = [[BLProfileViewController alloc] init];
            profileViewController.profileViewType = BLProfileViewTypeUpdate;
            UINavigationController *profileNavViewController = [[UINavigationController alloc] initWithRootViewController:profileViewController];
            profileNavViewController.navigationBarHidden = YES;
            [self.menuNavController setContentViewController:profileNavViewController animated:YES];
            break;
        }
        case BLSubViewControllerPartner:
        {
            BLPartnerViewController *partnerViewController = [[BLPartnerViewController alloc] init];
            partnerViewController.partnerViewType = BLPartnerViewControllerUpdate;
            [self.menuNavController setContentViewController:partnerViewController animated:YES];
            break;
        }
        case BLSubViewControllerPassword:
        {
            BLPasswordViewController *passwordViewController = [[BLPasswordViewController alloc] init];
            [self.menuNavController setContentViewController:passwordViewController animated:YES];
            break;
        }
        case BLSubViewControllerSetting:
        {
            BLSettingViewController *settingViewController = [[BLSettingViewController alloc] init];
            UINavigationController *settingNavViewController = [[UINavigationController alloc] initWithRootViewController:settingViewController];
            settingNavViewController.navigationBarHidden = YES;
            [self.menuNavController setContentViewController:settingNavViewController animated:YES];
            break;
        }
        default:
            break;
    }
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

- (UIImageView *)avatarImageView {
    if (!_avatarImageView) {
        _avatarImageView = [[UIImageView alloc] init];
        _avatarImageView.layer.cornerRadius = [BLGenernalDefinition resolutionForDevices:(97.0f / 2)];
        _avatarImageView.layer.borderWidth = 3.0f;
        _avatarImageView.layer.borderColor = [[UIColor whiteColor] CGColor];
        _avatarImageView.clipsToBounds = YES;
    }
    return _avatarImageView;
}

- (UILabel *)lbUsername {
    if (!_lbUsername) {
        _lbUsername = [[UILabel alloc] init];
        _lbUsername.font = [BLFontDefinition boldFont:15.0f];
        _lbUsername.textColor = [UIColor whiteColor];
    }
    return _lbUsername;
}

- (BLMenuButton *)btnMe {
    if (!_btnMe) {
        _btnMe = [[BLMenuButton alloc] init];
        _btnMe.tag = BLSubViewControllerProfile;
        _btnMe.blTitle = NSLocalizedString(@"Me", nil);
        _btnMe.blTitleColor = [BLColorDefinition menuFontColor];
        _btnMe.highlightColor = [UIColor whiteColor];
        _btnMe.icon = [UIImage imageNamed:@"me_icon.png"];
        _btnMe.highlightIcon = [UIImage imageNamed:@"me_icon_highlight.png"];
        [_btnMe addTarget:self action:@selector(pressButton:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _btnMe;
}

- (UIButton *)btnPartner {
    if (!_btnPartner) {
        _btnPartner = [[BLMenuButton alloc] init];
        _btnPartner.tag = BLSubViewControllerPartner;
        _btnPartner.blTitle = NSLocalizedString(@"Partner", nil);
        _btnPartner.blTitleColor = [BLColorDefinition menuFontColor];
        _btnPartner.highlightColor = [UIColor whiteColor];
        _btnPartner.icon = [UIImage imageNamed:@"partner_icon.png"];
        _btnPartner.highlightIcon = [UIImage imageNamed:@"partner_icon_highlight.png"];
        [_btnPartner addTarget:self action:@selector(pressButton:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _btnPartner;
}

- (UIButton *)btnPassword {
    if (!_btnPassword) {
        _btnPassword = [[BLMenuButton alloc] init];
        _btnPassword.tag = BLSubViewControllerPassword;
        _btnPassword.blTitle = NSLocalizedString(@"Password", nil);
        _btnPassword.blTitleColor = [BLColorDefinition menuFontColor];
        _btnPassword.highlightColor = [UIColor whiteColor];
        _btnPassword.icon = [UIImage imageNamed:@"password_icon.png"];
        _btnPassword.highlightIcon = [UIImage imageNamed:@"password_icon_highlight.png"];
        [_btnPassword addTarget:self action:@selector(pressButton:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _btnPassword;
}

- (UIButton *)btnSetting {
    if (!_btnSetting) {
        _btnSetting = [[BLMenuButton alloc] init];
        _btnSetting.tag = BLSubViewControllerSetting;
        _btnSetting.blTitle = NSLocalizedString(@"Settings", nil);
        _btnSetting.blTitleColor = [BLColorDefinition menuFontColor];
        _btnSetting.highlightColor = [UIColor whiteColor];
        _btnSetting.icon = [UIImage imageNamed:@"setting_icon.png"];
        _btnSetting.highlightIcon = [UIImage imageNamed:@"setting_icon_highlight.png"];
        [_btnSetting addTarget:self action:@selector(pressButton:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _btnSetting;
}

- (User *)currentUser {
    if (!_currentUser) {
        _currentUser = [[User alloc] initWithFromUserDefault];
    }
    return _currentUser;
}

#pragma mark -
#pragma mark Layout
- (void)layoutSubViews {
    [self.background mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.background.superview);
    }];
    
    [_avatarImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_avatarImageView.superview).with.offset([BLGenernalDefinition resolutionForDevices:108.0f]);
        make.centerX.equalTo(_avatarImageView.superview.mas_centerX);
        make.width.height.equalTo([NSNumber numberWithDouble:[BLGenernalDefinition resolutionForDevices:97.0f]]);
    }];
    
    [_lbUsername mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(_lbUsername.superview.mas_centerX);
        make.top.equalTo(_avatarImageView.mas_bottom).with.offset([BLGenernalDefinition resolutionForDevices:23.6f]);
    }];
    
    [self.btnSetting mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.btnSetting.superview).with.offset([BLGenernalDefinition resolutionForDevices:70.8f]);
        make.bottom.equalTo(self.btnSetting.superview).with.offset([BLGenernalDefinition resolutionForDevices:-79.0f]);
        make.height.equalTo([NSNumber numberWithDouble:[BLGenernalDefinition resolutionForDevices:35.4f]]);
        make.width.equalTo([NSNumber numberWithDouble:[BLGenernalDefinition resolutionForDevices:180.0f]]);
    }];
    
    [self.btnPartner mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.btnPartner.superview).with.offset([BLGenernalDefinition resolutionForDevices:70.8f]);
        make.bottom.equalTo(self.btnSetting.mas_top).with.offset([BLGenernalDefinition resolutionForDevices:-39.0f]);
        make.height.equalTo([NSNumber numberWithDouble:[BLGenernalDefinition resolutionForDevices:35.4f]]);
        make.width.equalTo([NSNumber numberWithDouble:[BLGenernalDefinition resolutionForDevices:180.0f]]);
    }];
    
    [self.btnPassword mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.btnPassword.superview).with.offset([BLGenernalDefinition resolutionForDevices:70.8f]);
        make.bottom.equalTo(self.btnPartner.mas_top).with.offset([BLGenernalDefinition resolutionForDevices:-39.0f]);
        make.height.equalTo([NSNumber numberWithDouble:[BLGenernalDefinition resolutionForDevices:35.4f]]);
        make.width.equalTo([NSNumber numberWithDouble:[BLGenernalDefinition resolutionForDevices:180.0f]]);
    }];
    
    [self.btnMe mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.btnMe.superview).with.offset([BLGenernalDefinition resolutionForDevices:70.8f]);
        make.bottom.equalTo(self.btnPassword.mas_top).with.offset([BLGenernalDefinition resolutionForDevices:-39.0f]);
        make.height.equalTo([NSNumber numberWithDouble:[BLGenernalDefinition resolutionForDevices:35.4f]]);
        make.width.equalTo([NSNumber numberWithDouble:[BLGenernalDefinition resolutionForDevices:180.0f]]);
    }];
}

@end
