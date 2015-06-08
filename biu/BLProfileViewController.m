//
//  BLProfileViewController.m
//  biu
//
//  Created by Tony Wu on 5/25/15.
//  Copyright (c) 2015 BiuLove. All rights reserved.
//

#import "BLProfileViewController.h"
#import "BLGenderTableViewCell.h"
#import "BLBirthTableViewCell.h"
#import "BLZodiacAndAgeTableViewCell.h"
#import "BLStyleTableViewCell.h"

#import "BLPartnerViewController.h"
#import "Masonry.h"

@interface BLProfileViewController () <UITableViewDataSource, UITableViewDelegate, BLTableViewCellDeletage>

@property (strong, nonatomic) User *currentUser;
@property (assign, nonatomic) BLGender gender;
@property (strong, nonatomic) NSDate *birthday;
@property (assign, nonatomic) BLZodiac zodiac;
@property (assign, nonatomic) BLStyleType style;

@property (retain, nonatomic) UITableView *tableView;
@property (retain, nonatomic) UIImageView *imageViewAvator;

@end

@implementation BLProfileViewController

@synthesize type;

static const NSInteger SECTION_HEADER = 0;
static const NSInteger SECTION_GENDER = 1;
static const NSInteger SECTION_BIRTHDAY = 2;
static const NSInteger SECTION_ZODIAC_AND_AGE = 3;
static const NSInteger SECTION_STYLE = 4;
static const NSInteger SECTION_BUTTON = 5;

static NSString *BL_NORMAL_CELL_REUSEID = @"BLNormalCell";
static NSString *BL_PROFILE_GENDER_CELL_REUSEID = @"BLGenderCell";
static NSString *BL_PROFILE_BIRTH_CELL_REUSEID = @"BLBirthCell";
static NSString *BL_PROFILE_ZODIAC_AND_AGE_CELL_REUSEID = @"BLZodiacAndAgeCell";
static NSString *BL_PROFIEL_STYLE_CELL_REUSEID = @"BLStyleCell";

static const float AVATOR_WIDTH = 163.0f;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    AppDelegate *delegate = [[UIApplication sharedApplication] delegate];
    _currentUser = delegate.currentUser;
    _gender = _currentUser.profile.gender;
    _birthday = _currentUser.profile.birthday;
    _zodiac = _currentUser.profile.zodiac;
    _style = _currentUser.profile.style;
    
    _tableView = [[UITableView alloc] initWithFrame:self.view.frame];
    _tableView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:_tableView];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.allowsSelection = NO;
    [_tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:BL_NORMAL_CELL_REUSEID];
    [_tableView registerClass:[BLGenderTableViewCell class] forCellReuseIdentifier:BL_PROFILE_GENDER_CELL_REUSEID];
    [_tableView registerClass:[BLBirthTableViewCell class] forCellReuseIdentifier:BL_PROFILE_BIRTH_CELL_REUSEID];
    [_tableView registerClass:[BLZodiacAndAgeTableViewCell class] forCellReuseIdentifier:BL_PROFILE_ZODIAC_AND_AGE_CELL_REUSEID];
    [_tableView registerClass:[BLStyleTableViewCell class] forCellReuseIdentifier:BL_PROFIEL_STYLE_CELL_REUSEID];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

#pragma mark - TableView Delegate and Data Source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 6;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    switch (indexPath.section) {
        case SECTION_HEADER:
        {
            UITableViewCell *cell = (UITableViewCell *)[tableView dequeueReusableCellWithIdentifier:BL_NORMAL_CELL_REUSEID forIndexPath:indexPath];
            cell.backgroundColor = [BLColorDefinition backgroundGrayColor];
            return cell;
        }
        case SECTION_GENDER:
        {
            BLGenderTableViewCell *cell = (BLGenderTableViewCell *)[tableView dequeueReusableCellWithIdentifier:BL_PROFILE_GENDER_CELL_REUSEID forIndexPath:indexPath];
            if (!cell) {
                cell = [[BLGenderTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:BL_PROFILE_GENDER_CELL_REUSEID];
            }
            cell.gender = _gender;
            cell.delegate = self;
            cell.tag = SECTION_GENDER;
            return cell;
            break;
        }
        case SECTION_BIRTHDAY:
        {
            BLBirthTableViewCell *cell = (BLBirthTableViewCell *)[tableView dequeueReusableCellWithIdentifier:BL_PROFILE_BIRTH_CELL_REUSEID forIndexPath:indexPath];
            if (!cell) {
                cell = [[BLBirthTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:BL_PROFILE_BIRTH_CELL_REUSEID];
            }
            cell.birthday = _birthday;
            cell.delegate = self;
            cell.tag = SECTION_BIRTHDAY;
            return cell;
            break;
        }
        case SECTION_ZODIAC_AND_AGE:
        {
            BLZodiacAndAgeTableViewCell *cell = (BLZodiacAndAgeTableViewCell *)[tableView dequeueReusableCellWithIdentifier:BL_PROFILE_ZODIAC_AND_AGE_CELL_REUSEID forIndexPath:indexPath];
            if (!cell) {
                cell = [[BLZodiacAndAgeTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:BL_PROFILE_ZODIAC_AND_AGE_CELL_REUSEID];
            }
            cell.birthday = _birthday;
            cell.delegate = self;
            cell.tag = SECTION_ZODIAC_AND_AGE;
            return cell;
            break;
        }
        case SECTION_STYLE:
        {
            BLStyleTableViewCell *cell = (BLStyleTableViewCell *)[tableView dequeueReusableCellWithIdentifier:BL_PROFIEL_STYLE_CELL_REUSEID forIndexPath:indexPath];
            if (!cell) {
                cell = [[BLStyleTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:BL_PROFIEL_STYLE_CELL_REUSEID];
            }
            cell.delegate = self;
            cell.tag = SECTION_STYLE;
            cell.gender = _gender;
            cell.style = _style;
            return cell;
            break;
        }
        case SECTION_BUTTON:
        {
            UITableViewCell *cell = (UITableViewCell *)[tableView dequeueReusableCellWithIdentifier:BL_NORMAL_CELL_REUSEID forIndexPath:indexPath];
            UIButton *button = [[UIButton alloc] init];
            button.titleLabel.font = [BLFontDefinition boldFont:20.0f];
            [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            [button setTitleColor:[BLColorDefinition fontGrayColor] forState:UIControlStateHighlighted];
            [button setBackgroundColor:[BLColorDefinition fontGreenColor]];
            button.layer.cornerRadius = 5.0f;
            button.clipsToBounds = YES;
            if (self.type == BLProfileViewTypeCreate) {
                [button setTitle:@"Continue" forState:UIControlStateNormal];
                [button addTarget:self action:@selector(createProfile:) forControlEvents:UIControlEventTouchDown];
            } else {
                [button setTitle:@"Save" forState:UIControlStateNormal];
                [button addTarget:self action:@selector(udpateProfile:) forControlEvents:UIControlEventTouchDown];
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
        case SECTION_HEADER:
            return 10.0f;
            break;
        case SECTION_GENDER:
            return 287.0f;
            break;
        case SECTION_BIRTHDAY:
            return 343.9f;
            break;
        case SECTION_ZODIAC_AND_AGE:
            return 250.0f;
            break;
        case SECTION_STYLE:
            return 500.0f;
            break;
        case SECTION_BUTTON:
            return 90.0f;
            break;
        default:
            break;
    }
    return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (section == SECTION_HEADER) {
        return 231.8f;
    }
    return 0;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    if (section == SECTION_HEADER) {
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

#pragma mark - handle cell delegate
- (void)tableViewCell:(BLBaseTableViewCell *)cell didChangeValue:(id)value {
    switch (cell.tag) {
        case SECTION_GENDER:
            _gender = (BLGender)[value integerValue];
            [_tableView reloadData];
            break;
        case SECTION_BIRTHDAY:
            _birthday = (NSDate *)value;
            [_tableView reloadData];
            break;
        case SECTION_ZODIAC_AND_AGE:
            _zodiac = (BLZodiac)[value integerValue];
            break;
        case SECTION_STYLE:
            _style = (BLStyleType)[value integerValue];
            break;
        default:
            break;
    }
}

#pragma mark - handle action
- (void)udpateProfile:(id)sender {
//    Profile *profile = [Profile new];
//    profile.gender = _gender;
//    profile.birthday = _birthday;
//    profile.zodiac = _zodiac;
//    profile.style = _style;
//    [profile save];
//    
//    [[BLHTTPClient sharedBLHTTPClient] createProfile:profile success:^(NSURLSessionDataTask *task, id responseObject) {
//        NSLog(@"Creating profile successed...");
//        BLPartnerViewController *partnerController = [[BLPartnerViewController alloc] initWithNibName:nil bundle:nil];
//        [self.navigationController pushViewController:partnerController animated:YES];
//    } failure:^(NSURLSessionDataTask *task, NSError *error) {
//        NSLog(@"Creating profile failed. Error: %@", error.description);
//        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil message:@"Creating profile failed. Please try again" delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
//        [alertView show];
//    }];
}

- (void)createProfile:(id)sender {
    AppDelegate *delegate = [[UIApplication sharedApplication] delegate];
    delegate.currentUser.profile = [Profile new];
    delegate.currentUser.profile.gender = _gender;
    delegate.currentUser.profile.birthday = _birthday;
    delegate.currentUser.profile.zodiac = _zodiac;
    delegate.currentUser.profile.style = _style;
    
    [[BLHTTPClient sharedBLHTTPClient] createProfile:delegate.currentUser success:^(NSURLSessionDataTask *task, id responseObject) {
        NSLog(@"create profile profile successed...");
        delegate.currentUser.profile.profileId = [responseObject objectForKey:@"profile_id"];
        [delegate.currentUser save];
        BLPartnerViewController *partnerController = [[BLPartnerViewController alloc] initWithNibName:nil bundle:nil];
        [self.navigationController pushViewController:partnerController animated:YES];
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        NSLog(@"create profile profile failed. Error: %@", error.description);
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil message:@"Updating profile failed. Please try again" delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
        [alertView show];
    }];
}

@end
