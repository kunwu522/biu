//
//  BLMenuViewViewController.m
//  biu
//
//  Created by WuTony on 5/31/15.
//  Copyright (c) 2015 BiuLove. All rights reserved.
//

#import "BLMenuViewController.h"
#import "Masonry.h"

@interface BLMenuViewController ()

@property (retain, nonatomic) UIView *background;
@property (retain, nonatomic) UIView *contentView;
@property (retain, nonatomic) UITapGestureRecognizer *tapRecognizer;

@property (retain, nonatomic) UIButton *btnMenu;
@property (retain, nonatomic) UIView *menuView;
@property (retain, nonatomic) UIButton *btnCancel;
@property (retain, nonatomic) UIButton *btnForward;
@property (retain, nonatomic) UIImageView *avatorImageView;
@property (retain, nonatomic) UILabel *lbUsername;
@property (retain, nonatomic) UIImageView *photoImageView;
@property (retain, nonatomic) UIButton *btnPhoto;
@property (retain, nonatomic) UIImageView *passwordImageView;
@property (retain, nonatomic) UIButton *btnPassword;
@property (retain, nonatomic) UIImageView *partnerImageView;
@property (retain, nonatomic) UIButton *btnPartner;
@property (retain, nonatomic) UIImageView *settingImageView;
@property (retain, nonatomic) UIButton *btnSetting;

@end

@implementation BLMenuViewController

- (id)initWithRootViewControllr:(UIViewController *)rootController {
    self = [super init];
    if (self) {
        self.rootController = rootController;
        _viewControllers = [NSArray array];
        _selectedViewController = nil;
        
        [self setupMenuButton];
        [self setupMenuController];
    }
    
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)setupMenuButton {
    _btnMenu = [[UIButton alloc] init];
    [_btnMenu setBackgroundImage:[UIImage imageNamed:@"menu_icon.png"] forState:UIControlStateNormal];
    [_btnMenu addTarget:self action:@selector(showMenu:) forControlEvents:UIControlEventTouchDown];
    [self.view addSubview:_btnMenu];
    
    [_btnMenu mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view).with.offset(31.2);
        make.right.equalTo(self.view).with.offset(-20.8);
        make.width.equalTo(@45.3);
        make.height.equalTo(@45.3);
    }];
}

- (void)setupMenuController {
    _menuView = [[UIView alloc] initWithFrame:self.view.bounds];
    _menuView.backgroundColor = [UIColor grayColor];
    _menuView.alpha = 0;
    [self.view addSubview:_menuView];
    
    _btnCancel = [[UIButton alloc] init];
    [_btnCancel setImage:[UIImage imageNamed:@"back_icon3.png"] forState:UIControlStateNormal];
    [_btnCancel addTarget:self action:@selector(back:) forControlEvents:UIControlEventTouchDown];
    [_menuView addSubview:_btnCancel];
    
    _avatorImageView = [[UIImageView alloc] init];
    _avatorImageView.image = [UIImage imageNamed:@"avator_default.png"];
    _avatorImageView.layer.cornerRadius = 97.0 / 2;
    _avatorImageView.layer.borderWidth = 4.0f;
    _avatorImageView.layer.borderColor = [[UIColor whiteColor] CGColor];
    [_menuView addSubview:_avatorImageView];
    
    _btnForward = [[UIButton alloc] init];
    [_btnForward setImage:[UIImage imageNamed:@"forward_icon2.png"] forState:UIControlStateNormal];
    [_btnForward addTarget:self action:@selector(forward:) forControlEvents:UIControlEventTouchDown];
    [_menuView addSubview:_btnForward];
    
    _lbUsername = [[UILabel alloc] init];
    _lbUsername.font = [BLFontDefinition boldFont:15.0f];
    _lbUsername.textColor = [UIColor whiteColor];
    _lbUsername.text = @"Tony";
    [_menuView addSubview:_lbUsername];
    
    _photoImageView = [[UIImageView alloc] init];
    _photoImageView.image = [UIImage imageNamed:@"photo_icon.png"];
    [_menuView addSubview:_photoImageView];
    
    _btnPhoto = [[UIButton alloc] init];
    _btnPhoto.titleLabel.font = [BLFontDefinition normalFont:20.0f];
    [_btnPhoto setTitleColor:[BLColorDefinition fontGrayColor] forState:UIControlStateNormal];
    [_btnPhoto setTitle:@"Photo" forState:UIControlStateNormal];
    [_menuView addSubview:_btnPhoto];
    
    _passwordImageView = [[UIImageView alloc] init];
    _passwordImageView.image = [UIImage imageNamed:@"password_icon.png"];
    [_menuView addSubview:_passwordImageView];
    
    _btnPassword = [[UIButton alloc] init];
    _btnPassword.titleLabel.font = [BLFontDefinition normalFont:20.0f];
    [_btnPassword setTitleColor:[BLColorDefinition fontGrayColor] forState:UIControlStateNormal];
    [_btnPassword setTitle:@"Password" forState:UIControlStateNormal];
    [_menuView addSubview:_btnPassword];
    
    _partnerImageView = [[UIImageView alloc] init];
    _partnerImageView.image = [UIImage imageNamed:@"partner_icon.png"];
    [_menuView addSubview:_partnerImageView];
    
    _btnPartner = [[UIButton alloc] init];
    _btnPartner.titleLabel.font = [BLFontDefinition normalFont:20.0f];
    [_btnPartner setTitleColor:[BLColorDefinition fontGrayColor] forState:UIControlStateNormal];
    [_btnPartner setTitle:@"Her/Him" forState:UIControlStateNormal];
    [_menuView addSubview:_btnPartner];
    
    _settingImageView = [[UIImageView alloc] init];
    _settingImageView.image = [UIImage imageNamed:@"setting_icon.png"];
    [_menuView addSubview:_settingImageView];
    
    _btnSetting = [[UIButton alloc] init];
    _btnSetting.titleLabel.font = [BLFontDefinition normalFont:20.0f];
    [_btnSetting setTitleColor:[BLColorDefinition fontGrayColor] forState:UIControlStateNormal];
    [_btnSetting setTitle:@"Settings" forState:UIControlStateNormal];
    [_menuView addSubview:_btnSetting];
    
    [_btnCancel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_btnCancel.superview).with.offset(133.3f);
        make.left.equalTo(_btnCancel.superview).with.offset(59.0f);
        make.width.equalTo(@47.2f);
        make.height.equalTo(@47.2f);
    }];
    
    [_avatorImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_avatorImageView.superview).with.offset(108.0);
        make.centerX.equalTo(_avatorImageView.superview.mas_centerX);
        make.width.equalTo(@97.0f);
        make.height.equalTo(@97.0f);
    }];
    
    [_btnForward mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_btnForward.superview).with.offset(133.3f);
        make.right.equalTo(_btnForward.superview).with.offset(-59.0f);
        make.width.equalTo(@47.2f);
        make.height.equalTo(@47.2f);
    }];
    
    [_lbUsername mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(_lbUsername.superview.mas_centerX);
        make.top.equalTo(_avatorImageView.mas_bottom).with.offset(23.6f);
    }];
    
    [_settingImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(_settingImageView.superview).with.offset(-59.0f);
        make.left.equalTo(_settingImageView.superview).with.offset(70.8f);
        make.width.equalTo(@35.4f);
        make.height.equalTo(@35.4f);
    }];
    
    [_btnSetting mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(_settingImageView.mas_centerY);
        make.left.equalTo(_settingImageView.mas_right).with.offset(20.7f);
    }];
    
    [_partnerImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(_settingImageView.mas_top).with.offset(-59.0f);
        make.left.equalTo(_partnerImageView.superview).with.offset(70.8f);
        make.width.equalTo(@35.4f);
        make.height.equalTo(@35.4f);
    }];
    
    [_btnPartner mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(_partnerImageView.mas_centerY);
        make.left.equalTo(_partnerImageView.mas_right).with.offset(20.7f);
    }];
    
    [_passwordImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(_partnerImageView.mas_top).with.offset(-59.0f);
        make.left.equalTo(_passwordImageView.superview).with.offset(70.8f);
        make.width.equalTo(@35.4f);
        make.height.equalTo(@35.4f);
    }];
    
    [_btnPassword mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(_passwordImageView.mas_centerY);
        make.left.equalTo(_passwordImageView.mas_right).with.offset(20.7f);
    }];
    
    [_photoImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(_passwordImageView.mas_top).with.offset(-59.0f);
        make.left.equalTo(_photoImageView.superview).with.offset(70.8f);
        make.width.equalTo(@35.4f);
        make.height.equalTo(@35.4f);
    }];
    
    [_btnPhoto mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(_photoImageView.mas_centerY);
        make.left.equalTo(_photoImageView.mas_right).with.offset(20.7f);
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)setRootController:(UIViewController *)rootController {
    _rootController = rootController;
    
    self.selectedViewController = _rootController;
}

- (void)setSelectedViewController:(UIViewController *)selectedViewController {
    _selectedViewController = selectedViewController;
    
    [_contentView removeFromSuperview];
    _contentView = self.selectedViewController.view;
    _contentView.bounds = self.view.bounds;
    [self.view insertSubview:_contentView aboveSubview:_btnMenu];
}

#pragma mark - Handle action
- (void)showMenu:(id)sender {
    [UIView animateWithDuration:0.2f animations:^{
        _menuView.alpha = 0.8f;
    }];
}

- (void)back:(id)sender {
    [UIView animateWithDuration:0.2f animations:^{
        _menuView.alpha = 0.0f;
    }];
}

- (void)forward:(id)sender {
    
}

- (void)tapRecognized:(UITapGestureRecognizer *)tapRecognized {
    
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
