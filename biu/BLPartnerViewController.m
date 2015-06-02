//
//  BLPartnerViewController.m
//  biu
//
//  Created by Tony Wu on 6/2/15.
//  Copyright (c) 2015 BiuLove. All rights reserved.
//

#import "BLPartnerViewController.h"
#import "BLZodiacTableViewCell.h"

#import "Masonry.h"

@interface BLPartnerViewController () <UITableViewDataSource, UITableViewDelegate>

@property (retain, nonatomic) UITableView *tableView;
@property (retain, nonatomic) UIImageView *imageViewAvator;

@end

@implementation BLPartnerViewController

static const float AVATOR_WIDTH = 163.0f;

typedef NS_ENUM(NSUInteger, BLPartnerSection) {
    BLPartnerSectionHeader = 0,
    BLPartnerSectionSexuality,
    BLPartnerSectionAgeRange,
    BLPartnerSectionZodiac,
    BLPartnerSectionStyle,
    BLPartnerSectionButtion
};

static NSString *BL_NORMAL_CELL_REUSEID = @"BLNormalCell";
static NSString *BL_PROFILE_ZODIAC_CELL_REUSEID = @"BLZodiacCell";

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
    [_tableView registerClass:[BLZodiacTableViewCell class] forCellReuseIdentifier:BL_PROFILE_ZODIAC_CELL_REUSEID];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - TableView Delegate and Data Source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
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
            return cell;
        }
        case BLPartnerSectionZodiac:
        {
            BLZodiacTableViewCell *cell = (BLZodiacTableViewCell *)[tableView dequeueReusableCellWithIdentifier:BL_PROFILE_ZODIAC_CELL_REUSEID forIndexPath:indexPath];
            if (!cell) {
                cell = [[BLZodiacTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:BL_PROFILE_ZODIAC_CELL_REUSEID];
            }
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
        case BLPartnerSectionZodiac:
            return 640.0f;
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
        _imageViewAvator.layer.borderWidth = 2.0f;
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

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
