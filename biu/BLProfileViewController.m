//
//  BLProfileViewController.m
//  biu
//
//  Created by Tony Wu on 5/25/15.
//  Copyright (c) 2015 BiuLove. All rights reserved.
//

#import "BLProfileViewController.h"
#import "BLCamViewController.h"
#import "BLGenderTableViewCell.h"
#import "BLBirthTableViewCell.h"
#import "BLZodiacAndAgeTableViewCell.h"
#import "BLStyleTableViewCell.h"
#import "BLPartnerViewController.h"
#import "UIViewController+BLBlurMenu.h"
#import "Masonry.h"

#import <SDWebImage/UIImageView+WebCache.h>

@interface BLProfileViewController () <UITableViewDataSource, UITableViewDelegate, BLTableViewCellDeletage, BLCamViewControllerDelegate>

@property (strong, nonatomic) User *currentUser; //works if profileViewType is BLProfileViewTypeUpdate

@property (assign, nonatomic) BLGender gender;
@property (strong, nonatomic) NSDate *birthday;
@property (assign, nonatomic) BLZodiac zodiac;
@property (assign, nonatomic) BLStyleType style;

@property (retain, nonatomic) UITableView *tableView;
@property (strong, nonatomic) UIButton *btnMenu;
@property (strong, nonatomic) UIButton *btnBackToRoot;

@end

@implementation BLProfileViewController

@synthesize profileViewType = _profileViewType;

static const NSInteger SECTION_HEADER = 0;
static const NSInteger SECTION_GENDER = 1;
static const NSInteger SECTION_BIRTHDAY = 2;
static const NSInteger SECTION_ZODIAC_AND_AGE = 3;
static const NSInteger SECTION_STYLE = 4;
static const NSInteger SECTION_BUTTON = 5;

static NSString *BL_PLACEHOLDER_CELL_REUSEID = @"BLPlaceHolderCell";
static NSString *BL_BUTTON_CELL_REUSEID = @"BLButtonCell";
static NSString *BL_PROFILE_GENDER_CELL_REUSEID = @"BLGenderCell";
static NSString *BL_PROFILE_BIRTH_CELL_REUSEID = @"BLBirthCell";
static NSString *BL_PROFILE_ZODIAC_AND_AGE_CELL_REUSEID = @"BLZodiacAndAgeCell";
static NSString *BL_PROFIEL_STYLE_CELL_REUSEID = @"BLStyleCell";

static const float AVATOR_WIDTH = 163.0f;

#pragma mark - life cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [BLColorDefinition backgroundGrayColor];
    
    if (self.profileViewType == BLProfileViewTypeUpdate && self.currentUser) {
        self.gender = self.currentUser.profile.gender;
        self.birthday = self.currentUser.profile.birthday;
        self.style = self.currentUser.profile.style;
    } else {
        self.gender = BLGenderMale;
        self.birthday = nil;
        self.zodiac = BLZodiacNone;
        self.style = BLStyleTypeNone;
    }
    
    _tableView = [[UITableView alloc] initWithFrame:self.view.frame];
    _tableView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:_tableView];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.allowsSelection = NO;
    [_tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:BL_PLACEHOLDER_CELL_REUSEID];
    [_tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:BL_BUTTON_CELL_REUSEID];
    [_tableView registerClass:[BLGenderTableViewCell class] forCellReuseIdentifier:BL_PROFILE_GENDER_CELL_REUSEID];
    [_tableView registerClass:[BLBirthTableViewCell class] forCellReuseIdentifier:BL_PROFILE_BIRTH_CELL_REUSEID];
    [_tableView registerClass:[BLZodiacAndAgeTableViewCell class] forCellReuseIdentifier:BL_PROFILE_ZODIAC_AND_AGE_CELL_REUSEID];
    [_tableView registerClass:[BLStyleTableViewCell class] forCellReuseIdentifier:BL_PROFIEL_STYLE_CELL_REUSEID];
    
    if (self.profileViewType == BLProfileViewTypeUpdate) {
        [self.view addSubview:self.btnMenu];
        [self.view addSubview:self.btnBackToRoot];
        
        [self.btnMenu mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.btnMenu.superview).with.offset(31.2);
            make.right.equalTo(self.btnMenu.superview).with.offset(-20.8);
            make.width.equalTo(@45.3);
            make.height.equalTo(@45.3);
        }];
        
        [self.btnBackToRoot mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.btnBackToRoot.superview).with.offset(31.2f);
            make.left.equalTo(self.btnBackToRoot.superview).with.offset(20.8f);
            make.width.equalTo(@45.3);
            make.height.equalTo(@45.3);
        }];
    }
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
#pragma mark - Delegates
#pragma mark TableViewDelegate and TableViewDataSource
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
            UITableViewCell *cell = (UITableViewCell *)[tableView dequeueReusableCellWithIdentifier:BL_PLACEHOLDER_CELL_REUSEID forIndexPath:indexPath];
            if (!cell) {
                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:BL_PLACEHOLDER_CELL_REUSEID];
                
            }
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
            cell.gender = self.gender;
            cell.style = self.style;
            return cell;
            break;
        }
        case SECTION_BUTTON:
        {
            UITableViewCell *cell = (UITableViewCell *)[tableView dequeueReusableCellWithIdentifier:BL_BUTTON_CELL_REUSEID forIndexPath:indexPath];
            if (!cell) {
                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:BL_BUTTON_CELL_REUSEID];
                
            }
            cell.backgroundColor = [UIColor clearColor];
            UIButton *button = [[UIButton alloc] init];
            button.titleLabel.font = [BLFontDefinition boldFont:20.0f];
            [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            [button setTitleColor:[BLColorDefinition fontGrayColor] forState:UIControlStateHighlighted];
            [button setBackgroundColor:[BLColorDefinition fontGreenColor]];
            button.layer.cornerRadius = 5.0f;
            button.clipsToBounds = YES;
            if (self.profileViewType == BLProfileViewTypeCreate) {
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
        
        UIImageView *imageViewAvator = [[UIImageView alloc] init];
        [imageViewAvator sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@cycle/avatar/%@",
                                                            [BLHTTPClient blBaseURL],
                                                            self.currentUser.profile.profileId]]
                     placeholderImage:[UIImage imageNamed:@"avatar_upload_icon.png"]
                              options:SDWebImageRefreshCached];
        imageViewAvator.layer.cornerRadius = AVATOR_WIDTH / 2;
        imageViewAvator.layer.borderColor = [UIColor whiteColor].CGColor;
        imageViewAvator.layer.borderWidth = 4.0f;
        imageViewAvator.clipsToBounds = YES;
        imageViewAvator.userInteractionEnabled = YES;
        [sectionHeaderView addSubview:imageViewAvator];
        
        [imageViewAvator mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(imageViewAvator.superview.mas_centerX);
            make.top.equalTo(imageViewAvator.superview).with.offset(95.8f);
            make.width.equalTo([NSNumber numberWithFloat:AVATOR_WIDTH]);
            make.height.equalTo([NSNumber numberWithFloat:AVATOR_WIDTH]);
        }];
        
        UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(showTakingPhotoView:)];
        [imageViewAvator addGestureRecognizer:tapGestureRecognizer];
        
        return sectionHeaderView;
    }
    return nil;
}

#pragma mark Customized Delegate
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

- (void)didFinishTakeOrChooseImage:(UIImage *)image orignalImage:(UIImage *)orignalImage {
    //Restore Image to SDWebImage cache
    [[SDImageCache sharedImageCache]storeImage:image forKey:[NSString stringWithFormat:@"%@cycle/avatar/%@",
                                                             [BLHTTPClient blBaseURL],
                                                             self.currentUser.profile.profileId]];
    [self.tableView reloadData];
    [self dismissViewControllerAnimated:NO completion:nil];
    
    [[BLHTTPClient sharedBLHTTPClient] uploadAvatar:self.currentUser.profile avatar:image isRect:NO success:^(NSURLSessionDataTask *task, id responseObject) {
        NSLog(@"Upload avatar cycle successed.");
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        NSString *errMsg = [BLHTTPClient responseMessage:task error:error];
        if (!errMsg) {
            errMsg = NSLocalizedString(@"Opps, upload avatar failed, please try later", nil);
        }
        UIAlertView *av = [[UIAlertView alloc] initWithTitle:nil message:errMsg delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil];
        [av show];
    }];
    
    [[BLHTTPClient sharedBLHTTPClient] uploadAvatar:self.currentUser.profile avatar:orignalImage isRect:YES success:^(NSURLSessionDataTask *task, id responseObject) {
        NSLog(@"Upload avatar rectangle successed.");
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        NSString *errMsg = [BLHTTPClient responseMessage:task error:error];
        if (!errMsg) {
            errMsg = NSLocalizedString(@"Opps, upload avatar failed, please try later", nil);
        }
        UIAlertView *av = [[UIAlertView alloc] initWithTitle:nil message:errMsg delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil];
        [av show];
    }];
}

#pragma mark - Actions
- (void)showTakingPhotoView:(id)sender {
    BLCamViewController *takingPhotoViewController = [[BLCamViewController alloc] initWithNibName:nil bundle:nil];
    takingPhotoViewController.delegate = self;
    [self.navigationController presentViewController:takingPhotoViewController animated:YES completion:nil];
}

- (void)showMenu:(id)sender {
    [self presentMenuViewController:sender];
}

- (void)backToRoot:(id)sender {
    [self backToRootViewController:sender];
}

- (void)udpateProfile:(UITapGestureRecognizer *)gestureRecogizer {
    self.currentUser.profile.gender = _gender;
    self.currentUser.profile.birthday = _birthday;
    self.currentUser.profile.zodiac = _zodiac;
    self.currentUser.profile.style = _style;
    
    [[BLHTTPClient sharedBLHTTPClient] updateProfile:self.currentUser.profile success:^(NSURLSessionDataTask *task, id responseObject) {
        NSLog(@"Update profile successed...");
        [self.currentUser.profile save];
        [self dismissViewControllerAnimated:YES completion:nil];
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        NSLog(@"Creating profile failed. Error: %@", error.description);
        NSString *errMsg = [BLHTTPClient responseMessage:task error:error];
        if (!errMsg) {
            errMsg = NSLocalizedString(@"Creating profile failed. Please try again", nil);
        }
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil message:errMsg delegate:self cancelButtonTitle:@"Ok" otherButtonTitles: nil];
        [alertView show];
    }];
}

- (void)createProfile:(id)sender {
    Profile *profile = [Profile new];
    profile.userId = _currentUser.userId;
    profile.gender = _gender;
    profile.birthday = _birthday;
    profile.zodiac = _zodiac;
    profile.style = _style;
    
    BLPartnerViewController *partnerController = [[BLPartnerViewController alloc] initWithNibName:nil bundle:nil];
    partnerController.profile = profile;
    [self.navigationController pushViewController:partnerController animated:YES];
}

#pragma mark - 
#pragma mark Setter
- (void)setProfileViewType:(BLProfileViewType)profileViewType {
    _profileViewType = profileViewType;
    if (profileViewType == BLProfileViewTypeUpdate) {
        BLAppDeleate *delegate = [[UIApplication sharedApplication] delegate];
        _currentUser = delegate.currentUser;
        _gender = _currentUser.profile.gender;
        _birthday = _currentUser.profile.birthday;
        _zodiac = _currentUser.profile.zodiac;
        _style = _currentUser.profile.style;
    }
}

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

- (BLProfileViewType)profileViewType {
    return _profileViewType;
}

- (User *)currentUser {
    if (!_currentUser) {
        BLAppDeleate *delegate = [[UIApplication sharedApplication] delegate];
        _currentUser = delegate.currentUser;
    }
    return _currentUser;
}
@end
