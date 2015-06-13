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

#import "Masonry.h"

@interface BLPartnerViewController () <UITableViewDataSource, UITableViewDelegate, BLTableViewCellDeletage>

@property (strong, nonatomic) User *currentUser;
@property (assign, nonatomic) BLSexualityType sexualityType;
@property (strong, nonatomic) NSNumber *minAge;
@property (strong, nonatomic) NSNumber *maxAge;
@property (strong, nonatomic) NSArray *preferZodiacs;
@property (strong, nonatomic) NSArray *preferStyles;

@property (strong, nonatomic) UIButton *btnBack;
@property (strong, nonatomic) UITableView *tableView;
@property (strong, nonatomic) UIImageView *imageViewAvator;

@property (assign, nonatomic) BOOL didCreateProfile;
@property (assign, nonatomic) BOOL didCreatePartner;

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
    
    BLAppDeleate *delegate = [[UIApplication sharedApplication] delegate];
    _currentUser = delegate.currentUser;
    
    _didCreatePartner = NO;
    _didCreateProfile = NO;
    
    [self.view addSubview:self.tableView];
    if (self.partnerViewType == BLPartnerViewControllerCreate) {
        [self.view addSubview:self.btnBack];
    }
    
    [self blLayoutSubViews];
}

- (void)blLayoutSubViews {
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    
    if (self.partnerViewType == BLPartnerViewControllerCreate) {
        [self.btnBack mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(_btnBack.superview).with.offset(31.2f);
            make.left.equalTo(_btnBack.superview).with.offset(20.8f);
            make.width.equalTo(@45.3);
            make.height.equalTo(@45.3);
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
            return cell;
            break;
        }
        case BLPartnerSectionStyle:
        {
            BLStyleTableViewCell *cell = (BLStyleTableViewCell *)[tableView dequeueReusableCellWithIdentifier:BL_PARTNER_STYLE_CELL_REUSEID forIndexPath:indexPath];
            if (!cell) {
                cell = [[BLStyleTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:BL_PARTNER_STYLE_CELL_REUSEID];
            }
            cell.allowMultiSelected = YES;
            cell.sexuality = _sexualityType;
            cell.title.text = NSLocalizedString(@"Styles you prefer", nil);
            cell.delegate = self;
            cell.tag = BLPartnerSectionStyle;
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
                make.left.equalTo(button.superview).with.offset(20.0f);
                make.bottom.equalTo(button.superview).with.offset(-20.0f);
                make.right.equalTo(button.superview).with.offset(-20.0f);
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
            return 300.0f;
            break;
        case BLPartnerSectionAgeRange:
            return 350.0f;
            break;
        case BLPartnerSectionZodiac:
            return 640.0f;
            break;
        case BLPartnerSectionStyle:
            return 500.0f;
            break;
        case BLPartnerSectionButton:
            return 90.0f;
        default:
            break;
    }
    return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (section == BLPartnerSectionHeader) {
        return 231.8f;
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
        _imageViewAvator.layer.cornerRadius = AVATOR_WIDTH / 2;
        _imageViewAvator.layer.borderColor = [UIColor whiteColor].CGColor;
        _imageViewAvator.layer.borderWidth = 4.0f;
        _imageViewAvator.image = [UIImage imageNamed:@"partner_avator.png"];
        _imageViewAvator.clipsToBounds = YES;
        [sectionHeaderView addSubview:_imageViewAvator];
        
        [_imageViewAvator mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(_imageViewAvator.superview.mas_centerX);
            make.top.equalTo(_imageViewAvator.superview).with.offset(95.8f);
            make.width.equalTo([NSNumber numberWithFloat:AVATOR_WIDTH]);
            make.height.equalTo([NSNumber numberWithFloat:AVATOR_WIDTH]);
        }];
        return sectionHeaderView;
    }
    return nil;
}

- (void)tableViewCell:(BLBaseTableViewCell *)cell didChangeValue:(id)value {
    switch (cell.tag) {
        case BLPartnerSectionSexuality:
            _sexualityType = (BLSexualityType)[value integerValue];
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
    partner.userId = _currentUser.userId;
    partner.sexualityType = _sexualityType;
    partner.minAge = _minAge;
    partner.maxAge = _maxAge;
    partner.preferZodiacs = _preferZodiacs;
    partner.preferStyles = _preferStyles;
    
    if (self.profile) {
        [[BLHTTPClient sharedBLHTTPClient] createProfile:self.profile success:^(NSURLSessionDataTask *task, id responseObject) {
            NSLog(@"create profile successed...");
            self.profile.profileId = [responseObject objectForKey:@"profile_id"];
            BLAppDeleate *blDelegate = [[UIApplication sharedApplication] delegate];
            blDelegate.currentUser.profile = self.profile;
            [blDelegate.currentUser save];
            _didCreateProfile = YES;
            [self presentMatchView];
        } failure:^(NSURLSessionDataTask *task, NSError *error) {
            NSLog(@"create profile profile failed. Error: %@", error.description);
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil message:@"Updating profile failed. Please try again" delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
            [alertView show];
        }];
    } else {
        NSLog(@"Error: profile is null.");
    }
    
    [[BLHTTPClient sharedBLHTTPClient] createPartner:partner success:^(NSURLSessionDataTask *task, id responseObject) {
        NSLog(@"create profile successed, partner id: %@.", [responseObject objectForKey:@"partner_id"]);
        partner.partnerId = [responseObject objectForKey:@"partner_id"];
        BLAppDeleate *blDelegate = [[UIApplication sharedApplication] delegate];
        blDelegate.currentUser.partner = partner;
        [blDelegate.currentUser save];
        _didCreatePartner = YES;
        [self presentMatchView];
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        NSString *message = [BLHTTPClient responseMessage:task error:error];
        if (!message) {
            message = NSLocalizedString(@"create profile failed, please try again later.", nil);
        }
        UIAlertView *av = [[UIAlertView alloc] initWithTitle:nil message:message delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil];
        [av show];
    }];
}

- (void)back:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)updatePartner:(id)sender {
    
}

#pragma mark - private
- (void)presentMatchView {
    if (_didCreatePartner || _didCreateProfile) {
        BLAppDeleate *blDelegate = [[UIApplication sharedApplication] delegate];
        [self presentViewController:blDelegate.menuViewController animated:YES completion:nil];
    }
}

#pragma mark - getting and Setting
- (UIButton *)btnBack {
    if (!_btnBack) {
        _btnBack = [[UIButton alloc] init];
        [_btnBack setImage:[UIImage imageNamed:@"back_icon2.png"] forState:UIControlStateNormal];
        [_btnBack addTarget:self action:@selector(back:) forControlEvents:UIControlEventTouchDown];
    }
    return _btnBack;
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

@end
