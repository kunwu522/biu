//
//  BLSettingViewController.m
//  biu
//
//  Created by Tony Wu on 6/2/15.
//  Copyright (c) 2015 BiuLove. All rights reserved.
//

#import "BLSettingViewController.h"
#import "BLWelcomeViewController.h"
#import "BLSuggestionViewController.h"
#import "BLAboutUsViewController.h"
#import "BLContractViewController.h"
#import "BLPasswordViewController.h"
#import "UIViewController+BLMenuNavController.h"
#import "Masonry.h"

@interface BLSettingViewController () <UITableViewDataSource, UITableViewDelegate, BLContractViewControllerDelegate>

@property (strong, nonatomic) UIImageView *background;
@property (strong, nonatomic) UILabel *lbTitle;
@property (strong, nonatomic) UITableView *tableView;
@property (strong, nonatomic) UIButton *btnClose;
@property (strong, nonatomic) UIButton *btnLogout;

@property (strong, nonatomic) NSArray *dataSource;

@end

@implementation BLSettingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.view addSubview:self.background];
    [self.view addSubview:self.lbTitle];
    [self.view addSubview:self.tableView];
    [self.view addSubview:self.btnClose];
    [self.view addSubview:self.btnLogout];

    self.dataSource = @[
//  注释掉分享，需要时打开
//  @{@"label" : NSLocalizedString(@"Share to WeChai", nil), @"haveDetailView" : @NO},
//                        @{@"label" : NSLocalizedString(@"Share to Weibo", nil), @"haveDetailView" : @NO},
                        @{@"label" : NSLocalizedString(@"Suggestion", nil), @"haveDetailView" : @YES},
                        @{@"label" : NSLocalizedString(@"About us", nil), @"haveDetailView" : @YES},
                        @{@"label" : NSLocalizedString(@"Contract", nil), @"haveDetailView" : @YES}];
    
    [self loadLayouts];
}

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
    
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.lbTitle.mas_bottom).with.offset([BLGenernalDefinition resolutionForDevices:50.0f]);
        make.left.right.equalTo(self.tableView.superview);
        make.height.equalTo([NSNumber numberWithDouble:[BLGenernalDefinition resolutionForDevices:400.0f]]);
    }];
    
    [self.btnLogout mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.btnLogout.superview).with.offset([BLGenernalDefinition resolutionForDevices:40.0f]);
        make.bottom.equalTo(self.btnLogout.superview).with.offset([BLGenernalDefinition resolutionForDevices:-50.0f]);
    }];
}

#pragma mark - Delegates
#pragma mark TableView Datasource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([UITableViewCell class]) forIndexPath:indexPath];
    cell.backgroundColor = [UIColor clearColor];
    
    NSDictionary *parameters = [self.dataSource objectAtIndex:indexPath.row];
    UILabel *label = [[UILabel alloc] init];
    label.text = [parameters objectForKey:@"label"];
    label.textColor = [UIColor whiteColor];
    label.font = [BLFontDefinition normalFont:15.0f];
    [cell addSubview:label];
    
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(label.superview);
        make.left.equalTo(label.superview).with.offset([BLGenernalDefinition resolutionForDevices:40.0f]);
    }];
    
    BOOL haveDetailView = [[parameters objectForKey:@"haveDetailView"] boolValue];
    if (haveDetailView) {
        UIImageView *arrow = [[UIImageView alloc] init];
        arrow.image = [UIImage imageNamed:@"right_arrow.png"];
        [cell addSubview:arrow];
        [arrow mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(arrow.superview);
            make.right.equalTo(arrow.superview).with.offset([BLGenernalDefinition resolutionForDevices:-20.0f]);
            make.width.height.equalTo([NSNumber numberWithDouble:[BLGenernalDefinition resolutionForDevices:20.0f]]);
        }];
    }
    
    // Draw top border only on first cell
    if (indexPath.row == 0) {
        UIView *topLineView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, 0.5)];
        topLineView.backgroundColor = [UIColor grayColor];
        [cell.contentView addSubview:topLineView];
    }
    
    UIView *bottomLineView = [[UIView alloc] initWithFrame:CGRectMake(0, cell.bounds.size.height, self.view.bounds.size.width, 0.5)];
    bottomLineView.backgroundColor = [UIColor grayColor];
    [cell.contentView addSubview:bottomLineView];
    
    return cell;
}

#pragma mark TableView delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    switch (indexPath.row) {
//        case 0:
//            break;
//        case 1:
//            break;
        case 0:
        {
            BLSuggestionViewController *suggestionViewController = [[BLSuggestionViewController alloc] init];
            [self.navigationController pushViewController:suggestionViewController animated:YES];
            break;
        }
        case 1:
        {
            BLAboutUsViewController *aboutUsViewController = [[BLAboutUsViewController alloc] init];
            [self.navigationController pushViewController:aboutUsViewController animated:YES];
            break;
        }
        case 2:
        {
            BLContractViewController *contractViewController = [[BLContractViewController alloc] init];
            contractViewController.delegate = self;
            [self.navigationController pushViewController:contractViewController animated:YES];
            break;
        }
        default:
            break;
    }
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark BLContractViewController delegate
- (void)didDismissBLContractViewController:(BLContractViewController *)vc {
    [vc.navigationController popViewControllerAnimated:YES];
}

#pragma mark - Action
- (void)logout:(id)sender {
    [[BLHTTPClient sharedBLHTTPClient] logout:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        NSLog(@"User log out successful.");
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        NSLog(@"User log out failed. Error: %@", error.description);
    }];
    
    BLAppDelegate *delegate = (BLAppDelegate *)[[UIApplication sharedApplication] delegate];

    delegate.currentUser = nil;

    //清userDefaults
    if (![[NSUserDefaults standardUserDefaults] boolForKey:@"dongClearHXCache"]) {
        NSString *appDomainStr = [[NSBundle mainBundle] bundleIdentifier];
        [[NSUserDefaults standardUserDefaults] removePersistentDomainForName:appDomainStr];
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"dontClearHXCache"];
        [[NSUserDefaults standardUserDefaults] synchronize];
    } else {
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"dontClearHXCache"];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
    
    //Clear Cookies
    [self removeCookieByName:@"user_id"];
    [self removeCookieByName:@"remember_token"];
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(didFinishLogout)]) {
        [self.delegate didFinishLogout];
    }
        
    BLWelcomeViewController *welViewController = [[BLWelcomeViewController alloc] initWithNibName:nil bundle:nil];
    UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:welViewController];
    navController.navigationBarHidden = YES;
    [self presentViewController:navController animated:YES completion:nil];
    
}

- (void)showMenu:(id)sender {
    [self presentMenuViewController:sender];
}

- (void)backToRoot:(id)sender {
    [self backToRootViewController:sender];
}

- (void)close:(id)sender {
    [self closeViewToRootViewController:sender];
}

#pragma mark - Private methods
- (void) removeCookieByName:(NSString *)name {
    NSArray *cookies = [[NSHTTPCookieStorage sharedHTTPCookieStorage] cookies];
    if (!cookies || cookies.count == 0) {
        return;
    }
    for (NSHTTPCookie *cookie in cookies) {
        if ([cookie.name isEqualToString:name]) {
            [[NSHTTPCookieStorage sharedHTTPCookieStorage] deleteCookie:cookie];
        }
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

- (UILabel *)lbTitle {
    if (!_lbTitle) {
        _lbTitle = [[UILabel alloc] init];
        _lbTitle.font = [BLFontDefinition normalFont:18.0f];
        _lbTitle.text = NSLocalizedString(@"Setting", nil);
        _lbTitle.textAlignment = NSTextAlignmentCenter;
        _lbTitle.textColor = [UIColor whiteColor];
    }
    return _lbTitle;
}

- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] init];
        _tableView.backgroundColor = [UIColor clearColor];
        _tableView.dataSource = self;
        _tableView.delegate = self;
        _tableView.rowHeight = [BLGenernalDefinition resolutionForDevices:60.0f];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        [_tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:NSStringFromClass([UITableViewCell class])];
    }
    return _tableView;
}

- (UIButton *)btnLogout {
    if (!_btnLogout) {
        _btnLogout = [[UIButton alloc] init];
        [_btnLogout setTitle:NSLocalizedString(@"Logout", nil) forState:UIControlStateNormal];
        [_btnLogout setTitleColor:[BLColorDefinition fontGreenColor] forState:UIControlStateNormal];
        _btnLogout.titleLabel.font = [BLFontDefinition normalFont:15.0f];
        
        [_btnLogout addTarget:self action:@selector(logout:) forControlEvents:UIControlEventTouchUpInside];
        
        
    }
    return _btnLogout;
}


- (UIButton *)btnClose {
    if (!_btnClose) {
        _btnClose = [[UIButton alloc] init];
        [_btnClose addTarget:self action:@selector(close:) forControlEvents:UIControlEventTouchDown];
        [_btnClose setBackgroundImage:[UIImage imageNamed:@"close_icon.png"] forState:UIControlStateNormal];
    }
    return _btnClose;
}

@end
