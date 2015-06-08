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

@property (assign, nonatomic) BLSexualityType sexualityType;
@property (strong, nonatomic) NSNumber *minAge;
@property (strong, nonatomic) NSNumber *maxAge;
@property (strong, nonatomic) NSArray *preferZodiacs;
@property (strong, nonatomic) NSArray *preferStyles;

@property (strong, nonatomic) UITableView *tableView;
@property (strong, nonatomic) UIImageView *imageViewAvator;

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

static NSString *BL_NORMAL_CELL_REUSEID = @"BLNormalCell";
static NSString *BL_PARTNER_SEXUALITY_CELL_REUSEID = @"BLSexualityCell";
static NSString *BL_PARTNER_AGERANGE_CELL_REUSEID = @"BLAgeRangeCell";
static NSString *BL_PARTNER_ZODIAC_CELL_REUSEID = @"BLZodiacCell";
static NSString *BL_PARTNER_STYLE_CELL_REUSEID = @"BLStyleCell";

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
    [_tableView registerClass:[BLSexualityTableViewCell class] forCellReuseIdentifier:BL_PARTNER_SEXUALITY_CELL_REUSEID];
    [_tableView registerClass:[BLAgeRangeTableViewCell class] forCellReuseIdentifier:BL_PARTNER_AGERANGE_CELL_REUSEID];
    [_tableView registerClass:[BLZodiacTableViewCell class] forCellReuseIdentifier:BL_PARTNER_ZODIAC_CELL_REUSEID];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - TableView Delegate and Data Source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 4;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    switch (indexPath.section) {
        case BLPartnerSectionHeader:
        {
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:BL_NORMAL_CELL_REUSEID forIndexPath:indexPath];
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
            cell.delegate = self;
            cell.tag = BLPartnerSectionStyle;
            return cell;
        }
        case BLPartnerSectionButton:
        {
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:BL_NORMAL_CELL_REUSEID forIndexPath:indexPath];
            UIButton *button = [[UIButton alloc] init];
            button.titleLabel.font = [BLFontDefinition boldFont:20.0f];
            [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            [button setTitleColor:[BLColorDefinition fontGrayColor] forState:UIControlStateHighlighted];
            [button setBackgroundColor:[BLColorDefinition fontGreenColor]];
            button.layer.cornerRadius = 5.0f;
            button.clipsToBounds = YES;
            if (self.type == BLPartnerViewControllerCreate) {
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
            _sexualityType = (BLSexualityType)value;
            [_tableView reloadData];
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
    
}

- (void)updatePartner:(id)sender {
    
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
