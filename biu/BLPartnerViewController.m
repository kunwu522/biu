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

#import "Masonry.h"

@interface BLPartnerViewController () <UITableViewDataSource, UITableViewDelegate, BLTableViewCellDeletage>

typedef NS_ENUM(NSUInteger, BLRequestState) {
    BLRequestStateNone = 0,
    BLRequestStateStarted,
    BLRequestStateFinished,
    BLRequestStateFailed
};

@property (strong, nonatomic) User *currentUser;
@property (strong, nonatomic) NSArray *sexualities;
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

@end

@implementation BLPartnerViewController

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
}

- (void)viewWillAppear:(BOOL)animated {
    if (self.partnerViewType == BLPartnerViewControllerUpdate && self.currentUser.partner) {
        _minAge = self.currentUser.partner.minAge;
        _maxAge = self.currentUser.partner.maxAge;
        _sexualities = self.currentUser.partner.sexualities;
        _preferStyles = self.currentUser.partner.preferStyles;
        _preferZodiacs = self.currentUser.partner.preferZodiacs;
    } else {
        _minAge = @20;
        _maxAge = @25;
        _sexualities = [NSArray array];
        _preferZodiacs = [NSArray array];
        _preferStyles = [NSArray array];
    }
}

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
    if (section == BLPartnerSectionStyle && [self isBisexual]) {
        return 2;
    }
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
            cell.sexualities = [[NSMutableArray alloc] initWithArray:_sexualities];
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
            
            if ([self isBisexual]) {
                NSMutableArray *maleMutableArray = [NSMutableArray array];
                NSMutableArray *femaleMutableArray = [NSMutableArray array];
                for (NSNumber *sexuality in self.sexualities) {
                    if (sexuality.integerValue == BLSexualityTypeNone) {
                        continue;
                    } else if (sexuality.integerValue == BLSexualityTypeMan
                               || sexuality.integerValue == BLSexualityType1
                               || sexuality.integerValue == BLSexualityType0) {
                        [maleMutableArray addObject:sexuality];
                    } else {
                        [femaleMutableArray addObject:sexuality];
                    }
                }
                
                if (indexPath.item == 0) {
                    cell.sexuality = ((NSNumber *)maleMutableArray.firstObject).integerValue;
                    cell.title.text = NSLocalizedString(@"Styles you prefer (male)", nil);
                } else {
                    cell.sexuality = ((NSNumber *)femaleMutableArray.firstObject).integerValue;
                    cell.title.text = NSLocalizedString(@"Styles you prefer (female)", nil);
                }
            } else {
                cell.sexuality = ((NSNumber *)self.sexualities.firstObject).integerValue;
                
                cell.title.text = NSLocalizedString(@"Styles you prefer", nil);
            }
            cell.allowMultiSelected = YES;
            cell.delegate = self;
            cell.tag = BLPartnerSectionStyle;
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
                [button setTitle:@"Find" forState:UIControlStateNormal];
                [button addTarget:self action:@selector(createPartner:) forControlEvents:UIControlEventTouchDown];
            } else {
                [button setTitle:@"Save" forState:UIControlStateNormal];
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
            _sexualities = (NSArray *)value;
            [self removePreferStylesBaseOnSexuality];
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
    partner.sexualities = _sexualities;
    partner.minAge = _minAge;
    partner.maxAge = _maxAge;
    partner.preferZodiacs = _preferZodiacs;
    partner.preferStyles = _preferStyles;
    
    self.timer = [NSTimer scheduledTimerWithTimeInterval:0.5 target:self selector:@selector(timerfired) userInfo:nil repeats:YES];
    if (self.profile) {
            
        _createProfileState = BLRequestStateStarted;
        [[BLHTTPClient sharedBLHTTPClient] createProfile:self.profile user:self.currentUser success:^(NSURLSessionDataTask *task, id responseObject) {
            NSLog(@"create profile successed...");
            self.profile.profileId = [responseObject objectForKey:@"profile_id"];
            [self.profile save];
            _createProfileState = BLRequestStateFinished;
        } failure:^(NSURLSessionDataTask *task, NSError *error) {
            NSLog(@"create profile profile failed. Error: %@", error.description);
            _createProfileState = BLRequestStateFailed;
        }];
    } else {
        NSLog(@"Error: profile is null.");
        _createProfileState = BLRequestStateFailed;
    }
    
    _createPartnerState = BLRequestStateStarted;
    [[BLHTTPClient sharedBLHTTPClient] createPartner:partner user:self.currentUser success:^(NSURLSessionDataTask *task, id responseObject) {
        NSLog(@"create profile successed, partner id: %@.", [responseObject objectForKey:@"partner_id"]);
        partner.partnerId = [responseObject objectForKey:@"partner_id"];
        [partner save];
        _createPartnerState = BLRequestStateFinished;
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        NSString *message = [BLHTTPClient responseMessage:task error:error];
        if (!message) {
            message = NSLocalizedString(@"create profile failed, please try again later.", nil);
        }
        NSLog(@"create partner failed, error: %@", message);
        _createPartnerState = BLRequestStateFailed;
    }];
}

- (void)updatePartner:(id)sender {
    self.currentUser.partner.sexualities = _sexualities;
    self.currentUser.partner.minAge = _minAge;
    self.currentUser.partner.maxAge = _maxAge;
    self.currentUser.partner.preferZodiacs = _preferZodiacs;
    self.currentUser.partner.preferStyles = _preferStyles;
    
    [[BLHTTPClient sharedBLHTTPClient] updatePartner:self.currentUser.partner user:self.currentUser success:^(NSURLSessionDataTask *task, id responseObject) {
        NSLog(@"Update partner successed...");
        [self.currentUser.partner save];
        UIAlertView *av = [[UIAlertView alloc] initWithTitle:nil message:NSLocalizedString(@"Save Successed!", nil) delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil];
        [av show];
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        NSLog(@"Update partner failed. Error: %@", error.localizedDescription);
        NSString *errMsg = [BLHTTPClient responseMessage:task error:error];
        if (!errMsg) {
            errMsg = NSLocalizedString(@"Update failed, please try later", nil);
        }
        UIAlertView *av = [[UIAlertView alloc] initWithTitle:nil message:errMsg delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil];
        [av show];
    }];
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

- (void)timerfired {
    if (_createPartnerState == BLRequestStateFinished && _createProfileState == BLRequestStateFinished) {

        // Create master navigation controller
        BLMatchViewController *matchViewController = [[BLMatchViewController alloc] initWithNibName:nil bundle:nil];
        BLMenuViewController *menuViewController = [[BLMenuViewController alloc] init];
        UINavigationController *masterNavViewController = [[UINavigationController alloc] initWithRootViewController:matchViewController];
        masterNavViewController.navigationBarHidden = YES;
        // Create BL Menu view controller
        BLMenuNavController *menuNavController = [[BLMenuNavController alloc] initWithRootViewController:masterNavViewController
                                                                  menuViewController:menuViewController];
        [self presentViewController:menuNavController animated:YES completion:nil];
        [_timer invalidate];
    }
    if (_createProfileState == BLRequestStateFailed || _createPartnerState == BLRequestStateFailed) {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil message:NSLocalizedString(@"Updating profile failed. Please try again", nil) delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
        [alertView show];
        [_timer invalidate];
    }
}

#pragma mark - private
- (BOOL)isBisexual {
    if (_sexualities.count < 2) {
        return NO;
    }
    
    BOOL hasMaleSexuality = NO;
    if ([_sexualities containsObject:[NSNumber numberWithInteger:BLSexualityTypeMan]]
        || [_sexualities containsObject:[NSNumber numberWithInteger:BLSexualityType1]]
        || [_sexualities containsObject:[NSNumber numberWithInteger:BLSexualityType0]]) {
        hasMaleSexuality = YES;
    }
    BOOL hasFemaleSexuality = NO;
    if ([_sexualities containsObject:[NSNumber numberWithInteger:BLSexualityTypeWoman]]
        || [_sexualities containsObject:[NSNumber numberWithInteger:BLSexualityTypeT]]
        || [_sexualities containsObject:[NSNumber numberWithInteger:BLSexualityTypeP]]) {
        hasFemaleSexuality = YES;
    }
    
    if (hasFemaleSexuality && hasMaleSexuality) {
        return YES;
    }

    return NO;
}

- (void)removePreferStylesBaseOnSexuality {
    if (![self isBisexual]) {
        BLGender gender = [Partner genderBySexuality:((NSNumber *)self.sexualities.firstObject).integerValue];
        NSMutableArray *preferStyles = [NSMutableArray array];
        for (NSNumber *style in self.preferStyles) {
            if ([Partner genderByStyle:style.integerValue] == gender) {
                [preferStyles addObject:style];
            }
        }
        self.preferStyles = (NSArray *)preferStyles;
    }
}

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
