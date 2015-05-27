//
//  BLProfileViewController.m
//  biu
//
//  Created by Tony Wu on 5/25/15.
//  Copyright (c) 2015 BiuLove. All rights reserved.
//

#import "BLProfileViewController.h"
#import "BLGenderTableViewCell.h"

@interface BLProfileViewController () <UITableViewDataSource, UITableViewDelegate>

@property (retain, nonatomic) UITableView *tableView;
@property (retain, nonatomic) UIImageView *imageViewHeader;


@end

@implementation BLProfileViewController

static const NSInteger SECTION_HEADER = 0;
static const NSInteger SECTION_GENDER = 1;
static const NSInteger SECTION_BIRTHDAY = 2;
static const NSInteger SECTION_ZODIAC = 3;
static const NSInteger SECTION_STYLE = 4;
static const NSInteger SECTION_CONTINUE = 5;

static NSString *BL_PROFILE_GENDER_CELL_REUSEID = @"BLGenderCell";

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    _tableView = [[UITableView alloc] initWithFrame:self.view.frame];
    _tableView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:_tableView];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    
    [_tableView registerClass:[BLGenderTableViewCell class] forCellReuseIdentifier:BL_PROFILE_GENDER_CELL_REUSEID];
    
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
        case SECTION_GENDER:
        {
            BLGenderTableViewCell *cell = (BLGenderTableViewCell *)[tableView dequeueReusableCellWithIdentifier:BL_PROFILE_GENDER_CELL_REUSEID forIndexPath:indexPath];
            if (!cell) {
                cell = [[BLGenderTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:BL_PROFILE_GENDER_CELL_REUSEID];
            }
            return cell;
            break;
        }
        default:
            break;
    }
    return nil;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    if (section == SECTION_HEADER || section == SECTION_CONTINUE) {
        return nil;
    }
    UIView *sectionHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.frame.size.width, 96.2f)];
    sectionHeaderView.backgroundColor = [BLColorDefinition backgroundGrayColor];
    UILabel *lbTitle = [[UILabel alloc] initWithFrame:sectionHeaderView.frame];
    lbTitle.font = [UIFont fontWithName:@"ArialMT" size:30];
    lbTitle.textColor = [BLColorDefinition fontGrayColor];
    lbTitle.textAlignment = NSTextAlignmentCenter;
    lbTitle.backgroundColor = [UIColor clearColor];
    [sectionHeaderView addSubview:lbTitle];
    
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
    return lbTitle;
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
            UIImageView *imageView = [[UIImageView alloc] initWithFrame:sectionFooterView.frame];
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
