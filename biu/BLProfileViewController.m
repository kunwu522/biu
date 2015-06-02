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

#import "Masonry.h"

@interface BLProfileViewController () <UITableViewDataSource, UITableViewDelegate>

@property (retain, nonatomic) UITableView *tableView;
@property (retain, nonatomic) UIImageView *imageViewAvator;


@end

@implementation BLProfileViewController

static const NSInteger SECTION_HEADER = 0;
static const NSInteger SECTION_GENDER = 1;
static const NSInteger SECTION_BIRTHDAY = 2;
static const NSInteger SECTION_ZODIAC = 3;
static const NSInteger SECTION_STYLE = 4;
static const NSInteger SECTION_CONTINUE = 5;

static NSString *BL_NORMAL_CELL_REUSEID = @"BLNormalCell";
static NSString *BL_PROFILE_GENDER_CELL_REUSEID = @"BLGenderCell";
static NSString *BL_PROFILE_BIRTH_CELL_REUSEID = @"BLBirthCell";

static const float AVATOR_WIDTH = 163.0f;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    _tableView = [[UITableView alloc] initWithFrame:self.view.frame];
    _tableView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:_tableView];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [_tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:BL_NORMAL_CELL_REUSEID];
    [_tableView registerClass:[BLGenderTableViewCell class] forCellReuseIdentifier:BL_PROFILE_GENDER_CELL_REUSEID];
    [_tableView registerClass:[BLBirthTableViewCell class] forCellReuseIdentifier:BL_PROFILE_BIRTH_CELL_REUSEID];
    
    _imageViewAvator = [[UIImageView alloc] init];
    _imageViewAvator.layer.cornerRadius = AVATOR_WIDTH / 2;
    _imageViewAvator.layer.borderColor = [UIColor whiteColor].CGColor;
    _imageViewAvator.layer.borderWidth = 2.0f;
    _imageViewAvator.image = [UIImage imageNamed:@"partner_avator.png"];
    [self.view addSubview:_imageViewAvator];
    
    [_imageViewAvator mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(_imageViewAvator.superview.mas_centerX);
        make.top.equalTo(_imageViewAvator.superview).with.offset(95.8f);
        make.width.equalTo([NSNumber numberWithFloat:AVATOR_WIDTH]);
        make.height.equalTo([NSNumber numberWithFloat:AVATOR_WIDTH]);
    }];
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
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    switch (indexPath.section) {
        case SECTION_HEADER:
        {
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:BL_NORMAL_CELL_REUSEID forIndexPath:indexPath];
            UIImageView *imageView = [[UIImageView alloc] initWithFrame:cell.bounds];
            imageView.image = [UIImage imageNamed:@"default_background.png"];
            [cell addSubview:imageView];
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
        }
        default:
            break;
    }
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    switch (indexPath.section) {
        case SECTION_HEADER:
            return 231.8f;
            break;
        case SECTION_GENDER:
        case SECTION_BIRTHDAY:
            return 200.0f;
            break;
        default:
            break;
    }
    return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    switch (section) {
        case SECTION_GENDER:
            return 80.0f;
            break;
        case SECTION_BIRTHDAY:
        case SECTION_STYLE:
        case SECTION_ZODIAC:
            return 50.0f;
            break;
        case SECTION_HEADER:
        case SECTION_CONTINUE:
        default:
            break;
    }
    return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    switch (section) {
        case SECTION_GENDER:
        case SECTION_BIRTHDAY:
        case SECTION_ZODIAC:
            return 40.0f;
            break;
        case SECTION_HEADER:
        case SECTION_STYLE:
        case SECTION_CONTINUE:
        default:
            break;
    }
    return 0;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    if (section == SECTION_HEADER || section == SECTION_CONTINUE) {
        return nil;
    }

    UIView *sectionHeaderView = [[UIView alloc] init];
    sectionHeaderView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    sectionHeaderView.backgroundColor = [BLColorDefinition backgroundGrayColor];
    UILabel *lbTitle = [[UILabel alloc] init];
    lbTitle.font = [BLFontDefinition normalFont:20.0f];
    lbTitle.textColor = [BLColorDefinition fontGrayColor];
    lbTitle.textAlignment = NSTextAlignmentCenter;
    lbTitle.backgroundColor = [UIColor clearColor];
    [sectionHeaderView addSubview:lbTitle];
    
    [lbTitle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(lbTitle.superview.mas_centerX);
        make.bottom.equalTo(lbTitle.superview).with.offset(-10);
    }];
    
    switch (section) {
        case SECTION_GENDER:
            lbTitle.text = @"Choose your Gender";
            break;
        case SECTION_BIRTHDAY:
            lbTitle.text = @"Choose your Date of birth";
            break;
        case SECTION_ZODIAC:
            lbTitle.text = @"Choose your Zodiac";
            break;
        case SECTION_STYLE:
            lbTitle.text = @"Choose your Style";
            break;
        default:
            return nil;
            break;
    }
    return sectionHeaderView;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    UIView *sectionFooterView = nil;
    switch (section) {
        case SECTION_GENDER:
        case SECTION_BIRTHDAY:
        case SECTION_ZODIAC:
        {
            sectionFooterView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.frame.size.width, 50.0f)];
            sectionFooterView.backgroundColor = [BLColorDefinition backgroundGrayColor];
            CGFloat width = 269.3f;
            CGFloat height = 16.0f;
            UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake((sectionFooterView.frame.size.width - width) * 0.5f,
                                                                                   (sectionFooterView.frame.size.height - height) * 0.5f,
                                                                                   width, height)];
            imageView.backgroundColor = [UIColor clearColor];
            imageView.image = [UIImage imageNamed:@"padding.png"];
            [sectionFooterView addSubview:imageView];
            break;
        }
        case SECTION_HEADER:
        case SECTION_STYLE:
        case SECTION_CONTINUE:
        default:
            break;
    }
    return sectionFooterView;
}


@end
