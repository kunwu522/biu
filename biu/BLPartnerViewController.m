//
//  BLPartnerViewController.m
//  biu
//
//  Created by Tony Wu on 6/2/15.
//  Copyright (c) 2015 BiuLove. All rights reserved.
//

#import "BLPartnerViewController.h"
#import "BLSexualityTableViewCell.h"
#import "BLAgeRangeTableViewCell.h"
#import "BLZodiacTableViewCell.h"
#import "BLStyleTableViewCell.h"
#import "BLMatchViewController.h"
#import "BLMenuNavController.h"
#import "BLMenuViewController.h"
#import "UIViewController+BLMenuNavController.h"
#import "BLSexualityTableViewCell.h"
#import "BLProfileViewController.h"

#import "Masonry.h"

@interface BLPartnerViewController () <UITableViewDataSource, UITableViewDelegate, BLTableViewCellDeletage, UIAlertViewDelegate>

typedef NS_ENUM(NSUInteger, BLRequestState) {
    BLRequestStateNone = 0,
    BLRequestStateStarted,
    BLRequestStateFinished,
    BLRequestStateFailed
};

@property (strong, nonatomic) User *currentUser;
@property (assign, nonatomic) NSNumber *sexuality;
@property (strong, nonatomic) NSNumber *minAge;
@property (strong, nonatomic) NSNumber *maxAge;
@property (strong, nonatomic) NSArray *preferZodiacs;
@property (strong, nonatomic) NSArray *preferStyles;
@property (strong, nonatomic) UIButton *btnBack;
@property (strong, nonatomic) UITableView *tableView;
@property (strong, nonatomic) UIImageView *imageViewAvator;
@property (strong, nonatomic) UIButton *btnMenu;
@property (strong, nonatomic) UIButton *btnBackToRoot;
@property (assign, nonatomic) BLRequestState createProfileState;
@property (assign, nonatomic) BLRequestState createPartnerState;
@property (strong, nonatomic) NSTimer *timer;

@property (strong, nonatomic) UINavigationController *fillingInfoNavController;

@end

@implementation BLPartnerViewController
@synthesize sexuality = _sexuality;
static const float AVATOR_WIDTH = 163.0f;

typedef NS_ENUM(NSUInteger, BLPartnerSection) {
    BLPartnerSectionHeader = 0,
    BLPartnerSectionSexuality,
    BLPartnerSectionAgeRange,
    BLPartnerSectionZodiac,
    BLPartnerSectionStyle,
    BLPartnerSectionButton
};

static NSString *BL_PLACEHOLDER_CELL_REUSEID = @"BLPlaceHolderCell";
static NSString *BL_BUTTON_CELL_REUSEID = @"BLButtonCell";
static NSString *BL_PARTNER_SEXUALITY_CELL_REUSEID = @"BLSexualityCell";
static NSString *BL_PARTNER_AGERANGE_CELL_REUSEID = @"BLAgeRangeCell";
static NSString *BL_PARTNER_ZODIAC_CELL_REUSEID = @"BLZodiacCell";
static NSString *BL_PARTNER_STYLE_CELL_REUSEID = @"BLStyleCell";

static CGFloat kImageOriginHight = 200;
static CGFloat kTempHeight = 80.0f;
#pragma mark - life cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [BLColorDefinition backgroundGrayColor];
    
    [self.view addSubview:self.tableView];
    if (self.partnerViewType == BLPartnerViewControllerCreate) {
        [self.view addSubview:self.btnBack];
    } else {
        [self.view addSubview:self.btnMenu];
        [self.view addSubview:self.btnBackToRoot];
        
        [self.btnMenu mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.btnMenu.superview).with.offset([BLGenernalDefinition resolutionForDevices:31.2f]);
            make.right.equalTo(self.btnMenu.superview).with.offset([BLGenernalDefinition resolutionForDevices:-20.8f]);
            make.width.height.equalTo([NSNumber numberWithDouble:[BLGenernalDefinition resolutionForDevices:45.3]]);
        }];
        
        [self.btnBackToRoot mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.btnBackToRoot.superview).with.offset([BLGenernalDefinition resolutionForDevices:31.2f]);
            make.left.equalTo(self.btnBackToRoot.superview).with.offset([BLGenernalDefinition resolutionForDevices:20.8f]);
            make.width.height.equalTo([NSNumber numberWithDouble:[BLGenernalDefinition resolutionForDevices:45.3]]);
        }];
    }
    
    [self blLayoutSubViews];
    
    self.expandZoomImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"login_signup_background.png"]];
    self.expandZoomImageView.frame = CGRectMake(0, -kImageOriginHight - kTempHeight, self.tableView.frame.size.width, kImageOriginHight + kTempHeight);
    [self.tableView addSubview:self.expandZoomImageView];
    
    if (self.currentUser.partner) {
        _minAge = self.currentUser.partner.minAge;
        _maxAge = self.currentUser.partner.maxAge;
        _sexuality = self.currentUser.partner.sexualities.firstObject;
        _preferStyles = self.currentUser.partner.preferStyles;
        _preferZodiacs = self.currentUser.partner.preferZodiacs;
    } else {
        _minAge = @20;
        _maxAge = @25;
        _sexuality = (NSNumber *)@"1";
        _preferZodiacs = [NSArray array];
        _preferStyles = [NSArray array];
    }
}

//tableView下拉图片变长
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    
    CGFloat yOffset  = scrollView.contentOffset.y;
    CGFloat xOffset = (yOffset + kImageOriginHight)/2;
    if (yOffset < -kImageOriginHight) {
        CGRect f = self.expandZoomImageView.frame;
        f.origin.y = yOffset - kTempHeight;
        f.size.height =  -yOffset + kTempHeight;
        f.origin.x = xOffset;
        f.size.width = self.view.frame.size.width + fabsf(xOffset)*2;
        self.expandZoomImageView.frame = f;
    }
}

//- (void)viewWillAppear:(BOOL)animated {
//    if (self.partnerViewType == BLPartnerViewControllerUpdate && self.currentUser.partner) {
//        _minAge = self.currentUser.partner.minAge;
//        _maxAge = self.currentUser.partner.maxAge;
//        _sexuality = self.currentUser.partner.sexualities.firstObject;
//        _preferStyles = self.currentUser.partner.preferStyles;
//        _preferZodiacs = self.currentUser.partner.preferZodiacs;
//    } else {
//        _minAge = @20;
//        _maxAge = @25;
//        _sexuality = (NSNumber *)@"1";//判断profile中男女，给定数据
//        _preferZodiacs = [NSArray array];
//        _preferStyles = [NSArray array];
//    }
//}

- (void)blLayoutSubViews {
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    
    if (self.partnerViewType == BLPartnerViewControllerCreate) {
        [self.btnBack mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(_btnBack.superview).with.offset([BLGenernalDefinition resolutionForDevices:31.2f]);
            make.left.equalTo(_btnBack.superview).with.offset([BLGenernalDefinition resolutionForDevices:20.8f]);
            make.width.height.equalTo([NSNumber numberWithDouble:[BLGenernalDefinition resolutionForDevices:45.3]]);
        }];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Delegate
#pragma mark - TableView Delegate and TableView DataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 6;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
//    if (section == BLPartnerSectionStyle && [self isBisexual]) {
//        return 2;
//    }
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    switch (indexPath.section) {
        case BLPartnerSectionHeader:
        {
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:BL_PLACEHOLDER_CELL_REUSEID forIndexPath:indexPath];
            cell.backgroundColor = [BLColorDefinition backgroundGrayColor];
            cell.tag = BLPartnerSectionHeader;
            return cell;
            break;
        }
        case BLPartnerSectionSexuality:
        {
            BLSexualityTableViewCell *cell = (BLSexualityTableViewCell *)[tableView dequeueReusableCellWithIdentifier:BL_PARTNER_SEXUALITY_CELL_REUSEID forIndexPath:indexPath];
            if (!cell) {
                cell = [[BLSexualityTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:BL_PARTNER_SEXUALITY_CELL_REUSEID];
            }
            cell.delegate = self;
            cell.tag = BLPartnerSectionSexuality;
            
            
            cell.sexuality = _sexuality.integerValue;

            
            return cell;
        }
        case BLPartnerSectionAgeRange:
        {
            BLAgeRangeTableViewCell *cell = (BLAgeRangeTableViewCell *)[tableView dequeueReusableCellWithIdentifier:BL_PARTNER_AGERANGE_CELL_REUSEID
                                                                                                       forIndexPath:indexPath];
            if (!cell) {
                cell = [[BLAgeRangeTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:BL_PARTNER_AGERANGE_CELL_REUSEID];
            }
            cell.delegate = self;
            cell.tag = BLPartnerSectionAgeRange;
            cell.minAge = _minAge.integerValue;
            cell.maxAge = _maxAge.integerValue;
            return cell;
        }
        case BLPartnerSectionZodiac:
        {
            BLZodiacTableViewCell *cell = (BLZodiacTableViewCell *)[tableView dequeueReusableCellWithIdentifier:BL_PARTNER_ZODIAC_CELL_REUSEID forIndexPath:indexPath];
            if (!cell) {
                cell = [[BLZodiacTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:BL_PARTNER_ZODIAC_CELL_REUSEID];
            }
            cell.delegate = self;
            cell.tag = BLPartnerSectionZodiac;
            cell.title.text = NSLocalizedString(@"Zodiacs you prefer", nil);
            cell.allowMultiSelected = YES;
            cell.preferZodiacs = [[NSMutableArray alloc] initWithArray:_preferZodiacs];
            return cell;
            break;
        }
        case BLPartnerSectionStyle:
        {
            BLStyleTableViewCell *cell = (BLStyleTableViewCell *)[tableView dequeueReusableCellWithIdentifier:BL_PARTNER_STYLE_CELL_REUSEID forIndexPath:indexPath];
            if (!cell) {
                cell = [[BLStyleTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:BL_PARTNER_STYLE_CELL_REUSEID];
            }
            
            cell.sexuality = (BLSexualityType)_sexuality.integerValue;
           
            cell.allowMultiSelected = YES;
            cell.delegate = self;
            cell.tag = BLPartnerSectionStyle;
            cell.title.text = NSLocalizedString(@"Styles you prefer", nil);
            
            cell.preferStyles = [[NSMutableArray alloc] initWithArray:_preferStyles];
            
            return cell;
            break;
        }
        case BLPartnerSectionButton:
        {
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:BL_BUTTON_CELL_REUSEID forIndexPath:indexPath];
            cell.backgroundColor = [UIColor clearColor];
            UIButton *button = [[UIButton alloc] init];
            button.titleLabel.font = [BLFontDefinition boldFont:20.0f];
            [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            [button setTitleColor:[BLColorDefinition fontGrayColor] forState:UIControlStateHighlighted];
            [button setBackgroundColor:[BLColorDefinition fontGreenColor]];
            button.layer.cornerRadius = 5.0f;
            button.clipsToBounds = YES;
            if (self.partnerViewType == BLPartnerViewControllerCreate) {
                [button setTitle:NSLocalizedString(@"Find", nil) forState:UIControlStateNormal];
                [button addTarget:self action:@selector(createPartner:) forControlEvents:UIControlEventTouchDown];
            } else {
                [button setTitle:NSLocalizedString(@"Save", nil) forState:UIControlStateNormal];
                [button addTarget:self action:@selector(updatePartner:) forControlEvents:UIControlEventTouchDown];
            }
            [cell addSubview:button];
            
            [button mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(button.superview);
                make.left.equalTo(button.superview).with.offset([BLGenernalDefinition resolutionForDevices:20.0f]);
                make.bottom.right.equalTo(button.superview).with.offset([BLGenernalDefinition resolutionForDevices:-20.0f]);
            }];
            return cell;
            break;
        }
        default:
            break;
    }
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    switch (indexPath.section) {
        case BLPartnerSectionHeader:
            return 10.0f;
            break;
        case BLPartnerSectionSexuality:
            return [BLGenernalDefinition resolutionForDevices:300.0f];
            break;
        case BLPartnerSectionAgeRange:
            return [BLGenernalDefinition resolutionForDevices:350.0f];
            break;
        case BLPartnerSectionZodiac:
            return [BLGenernalDefinition resolutionForDevices:670.0f];
            break;
        case BLPartnerSectionStyle:
            return [BLGenernalDefinition resolutionForDevices:530.0f];
            break;
        case BLPartnerSectionButton:
            return [BLGenernalDefinition resolutionForDevices:90.0f];
        default:
            break;
    }
    return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (section == BLPartnerSectionHeader) {
        return [BLGenernalDefinition resolutionForDevices:231.8f];
    }
    return 0;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    if (section == BLPartnerSectionHeader) {
        UIView *sectionHeaderView = [[UIView alloc] init];
        sectionHeaderView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        sectionHeaderView.backgroundColor = [BLColorDefinition backgroundGrayColor];
        
        UIImageView *imageView = [[UIImageView alloc] init];
        imageView.image = [UIImage imageNamed:@"default_background.png"];
        imageView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        [sectionHeaderView addSubview:imageView];
        
        _imageViewAvator = [[UIImageView alloc] init];
        _imageViewAvator.layer.cornerRadius = [BLGenernalDefinition resolutionForDevices:AVATOR_WIDTH] / 2;
        _imageViewAvator.layer.borderColor = [UIColor whiteColor].CGColor;
        _imageViewAvator.layer.borderWidth = 4.0f;
        _imageViewAvator.image = [UIImage imageNamed:@"partner_avator.png"];
        _imageViewAvator.clipsToBounds = YES;
        [sectionHeaderView addSubview:_imageViewAvator];
        
        [_imageViewAvator mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(_imageViewAvator.superview.mas_centerX);
            make.top.equalTo(_imageViewAvator.superview).with.offset([BLGenernalDefinition resolutionForDevices:95.8f]);
            make.width.equalTo([NSNumber numberWithFloat:[BLGenernalDefinition resolutionForDevices:AVATOR_WIDTH]]);
            make.height.equalTo([NSNumber numberWithFloat:[BLGenernalDefinition resolutionForDevices:AVATOR_WIDTH]]);
        }];
        return sectionHeaderView;
    }
    return nil;
}

#pragma mark Customize Cell delegate
- (void)tableViewCell:(BLBaseTableViewCell *)cell didChangeValue:(id)value {
    switch (cell.tag) {
        case BLPartnerSectionSexuality:
            
            self.sexuality = value;
            [self.tableView reloadData];
            break;
        case BLPartnerSectionAgeRange:
            _minAge = [(NSDictionary *)value objectForKey:@"min_age"];
            _maxAge = [(NSDictionary *)value objectForKey:@"max_age"];
            break;
        case BLPartnerSectionZodiac:
            _preferZodiacs = (NSArray *)value;
            break;
        case BLPartnerSectionStyle:
            _preferStyles = (NSArray *)value;
            break;
        case BLPartnerSectionHeader:
        case BLPartnerSectionButton:
            
        default:
            break;
    }
}

#pragma mark - handle action
- (void)createPartner:(id)sender {
    Partner *partner = [Partner new];
    NSArray *arr = [NSArray arrayWithObject:_sexuality];
    partner.sexualities = arr;
    partner.minAge = _minAge;
    partner.maxAge = _maxAge;
    partner.preferZodiacs = _preferZodiacs;
    partner.preferStyles = _preferStyles;
    
    NSDictionary *dic = [[NSUserDefaults standardUserDefaults] dictionaryRepresentation];
    User *user = [[User alloc] init];
    user.userId = dic[@"user_id"];
    user.username = dic[@"username"];
    [user save];
    
    if (_preferZodiacs.count == 0) {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Please select zodiacs you prefer", nil) message:nil delegate:self cancelButtonTitle:NSLocalizedString(@"OK", nil) otherButtonTitles:nil, nil];
        [alertView show];
    } else if (_preferStyles.count == 0) {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Please select styles you prefer", nil) message:nil delegate:self cancelButtonTitle:NSLocalizedString(@"OK", nil) otherButtonTitles:nil, nil];
        [alertView show];
    } else {

        [[BLHTTPClient sharedBLHTTPClient] createPartner:partner user:user success:^(NSURLSessionDataTask *task, id responseObject) {
            NSLog(@"create profile successed, partner id: %@.", [responseObject objectForKey:@"partner_id"]);
            partner.partnerId = [responseObject objectForKey:@"partner_id"];
            [partner save];
            
            BLMatchViewController *matchViewController = [[BLMatchViewController alloc] initWithNibName:nil bundle:nil];
            BLMenuViewController *menuViewController = [[BLMenuViewController alloc] init];
            UINavigationController *masterNavViewController = [[UINavigationController alloc] initWithRootViewController:matchViewController];
            masterNavViewController.navigationBarHidden = YES;
            // Create BL Menu view controller
            BLMenuNavController *menuNavController = [[BLMenuNavController alloc] initWithRootViewController:masterNavViewController
                                                                                          menuViewController:menuViewController];
            [self presentViewController:menuNavController animated:YES completion:nil];

        } failure:^(NSURLSessionDataTask *task, NSError *error) {
            NSString *message = [BLHTTPClient responseMessage:task error:error];
            if (!message) {
                message = NSLocalizedString(@"create profile failed, please try again later.", nil);
            }
            NSLog(@"create partner failed, error: %@", message);
            UIAlertView *alertV = [[UIAlertView alloc]initWithTitle:NSLocalizedString(@"Create Profile failed\nplease try again", nil) message:nil delegate:self cancelButtonTitle:NSLocalizedString(@"Cancel", nil) otherButtonTitles:nil, nil];
            [alertV show];
        }];
    }
}

- (void)updatePartner:(id)sender {
    
    User *user = [User new];
    user.userId = [[NSUserDefaults standardUserDefaults] dictionaryRepresentation][@"user_id"];
//    NSArray *arr = [NSArray arrayWithObject:_sexuality];
    self.currentUser.partner.sexualities = [NSArray arrayWithObject:_sexuality];
    self.currentUser.partner.minAge = _minAge;
    self.currentUser.partner.maxAge = _maxAge;
    self.currentUser.partner.preferZodiacs = _preferZodiacs;
    self.currentUser.partner.preferStyles = _preferStyles;
    
    if (_preferZodiacs.count == 0) {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Please select zodiacs you prefer", nil) message:nil delegate:self cancelButtonTitle:NSLocalizedString(@"OK", nil) otherButtonTitles:nil, nil];
        [alertView show];
    } else if (_preferStyles.count == 0) {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Please select styles you prefer", nil) message:nil delegate:self cancelButtonTitle:NSLocalizedString(@"OK", nil) otherButtonTitles:nil, nil];
        [alertView show];
    } else {
        
        [[BLHTTPClient sharedBLHTTPClient] updatePartner:self.currentUser.partner user:user success:^(NSURLSessionDataTask *task, id responseObject) {
            NSLog(@"Update partner successed...");
            
            [self.currentUser.partner save];
            UIAlertView *av = [[UIAlertView alloc] initWithTitle:nil message:NSLocalizedString(@"Save Successed!", nil) delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil];
            [av show];
            self.currentUser = nil;
        } failure:^(NSURLSessionDataTask *task, NSError *error) {
            NSLog(@"Update partner failed. Error: %@", error.localizedDescription);
            NSString *errMsg = [BLHTTPClient responseMessage:task error:error];
            if (!errMsg) {
                errMsg = NSLocalizedString(@"Update failed, please try later", nil);
            }
            UIAlertView *av = [[UIAlertView alloc] initWithTitle:nil message:errMsg delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil];
            [av show];
            self.currentUser = nil;
        }];
    }

}

- (void)back:(id)sender {

    [self.navigationController popViewControllerAnimated:YES];
}

- (void)showMenu:(id)sender {
    [self presentMenuViewController:sender];
}

- (void)backToRoot:(id)sender {
    [self backToRootViewController:sender];
}


#pragma mark - private


#pragma mark - Getter and Setter
- (UIButton *)btnBack {
    if (!_btnBack) {
        _btnBack = [[UIButton alloc] init];
        [_btnBack setImage:[UIImage imageNamed:@"back_icon2.png"] forState:UIControlStateNormal];
        [_btnBack addTarget:self action:@selector(back:) forControlEvents:UIControlEventTouchDown];
    }
    return _btnBack;
}

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

- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:self.view.frame];
        _tableView.backgroundColor = [UIColor clearColor];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.allowsSelection = NO;
        [_tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:BL_PLACEHOLDER_CELL_REUSEID];
        [_tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:BL_BUTTON_CELL_REUSEID];
        [_tableView registerClass:[BLSexualityTableViewCell class] forCellReuseIdentifier:BL_PARTNER_SEXUALITY_CELL_REUSEID];
        [_tableView registerClass:[BLAgeRangeTableViewCell class] forCellReuseIdentifier:BL_PARTNER_AGERANGE_CELL_REUSEID];
        [_tableView registerClass:[BLZodiacTableViewCell class] forCellReuseIdentifier:BL_PARTNER_ZODIAC_CELL_REUSEID];
        [_tableView registerClass:[BLStyleTableViewCell class] forCellReuseIdentifier:BL_PARTNER_STYLE_CELL_REUSEID];
    }
    return _tableView;
}

- (User *)currentUser {
    if (!_currentUser) {
        _currentUser = [[User alloc] initWithFromUserDefault];
    }
    return _currentUser;
}

@end
