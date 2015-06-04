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
#import "BLZodiacTableViewCell.h"
#import "BLStyleTableViewCell.h"

#import "Masonry.h"

@interface BLProfileViewController () <UITableViewDataSource, UITableViewDelegate>

@property (retain, nonatomic) UITableView *tableView;
@property (retain, nonatomic) UIImageView *imageViewAvator;

@end

@implementation BLProfileViewController

@synthesize type;

static const NSInteger SECTION_HEADER = 0;
static const NSInteger SECTION_GENDER = 1;
static const NSInteger SECTION_BIRTHDAY = 2;
static const NSInteger SECTION_ZODIAC = 3;
static const NSInteger SECTION_STYLE = 4;
static const NSInteger SECTION_BUTTON = 5;

static NSString *BL_NORMAL_CELL_REUSEID = @"BLNormalCell";
static NSString *BL_PROFILE_GENDER_CELL_REUSEID = @"BLGenderCell";
static NSString *BL_PROFILE_BIRTH_CELL_REUSEID = @"BLBirthCell";
static NSString *BL_PROFILE_ZODIAC_CELL_REUSEID = @"BLZodiacCell";
static NSString *BL_PROFIEL_STYLE_CELL_REUSEID = @"BLStyleCell";

static const float AVATOR_WIDTH = 163.0f;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
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
    [_tableView registerClass:[BLZodiacTableViewCell class] forCellReuseIdentifier:BL_PROFILE_ZODIAC_CELL_REUSEID];
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
            return cell;
            break;
        }
        case SECTION_BIRTHDAY:
        {
            BLBirthTableViewCell *cell = (BLBirthTableViewCell *)[tableView dequeueReusableCellWithIdentifier:BL_PROFILE_BIRTH_CELL_REUSEID forIndexPath:indexPath];
            if (!cell) {
                cell = [[BLBirthTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:BL_PROFILE_BIRTH_CELL_REUSEID];
            }
            return cell;
            break;
        }
        case SECTION_ZODIAC:
        {
            BLZodiacTableViewCell *cell = (BLZodiacTableViewCell *)[tableView dequeueReusableCellWithIdentifier:BL_PROFILE_ZODIAC_CELL_REUSEID forIndexPath:indexPath];
            if (!cell) {
                cell = [[BLZodiacTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:BL_PROFILE_ZODIAC_CELL_REUSEID];
            }
            return cell;
            break;
        }
        case SECTION_STYLE:
        {
            BLStyleTableViewCell *cell = (BLStyleTableViewCell *)[tableView dequeueReusableCellWithIdentifier:BL_PROFIEL_STYLE_CELL_REUSEID forIndexPath:indexPath];
            if (!cell) {
                cell = [[BLStyleTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:BL_PROFIEL_STYLE_CELL_REUSEID];
            }
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
                [button addTarget:self action:@selector(next:) forControlEvents:UIControlEventTouchDown];
            } else {
                [button setTitle:@"Save" forState:UIControlStateNormal];
                [button addTarget:self action:@selector(save:) forControlEvents:UIControlEventTouchDown];
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
        case SECTION_ZODIAC:
            return 640.0f;
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

#pragma mark - handle action
- (void)next:(id)sender {
    
}

- (void)save:(id)sender {
    
}

@end
