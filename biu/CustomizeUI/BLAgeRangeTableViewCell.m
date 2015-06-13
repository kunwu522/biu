//
//  BLAgeRangeTableViewCell.m
//  biu
//
//  Created by Tony Wu on 6/3/15.
//  Copyright (c) 2015 BiuLove. All rights reserved.
//

#import "BLAgeRangeTableViewCell.h"
#import "BLPickerView.h"

#import "Masonry.h"

@interface BLAgeRangeTableViewCell () <BLPickerViewDataSource, BLPickerViewDelegate>

@property (strong, nonatomic) BLPickerView *minAgePicker;
@property (strong, nonatomic) BLPickerView *maxAgePicker;
@property (strong, nonatomic) UIImageView *arrowImageView;

@property (strong, nonatomic) NSMutableArray *ageRange;

@end

@implementation BLAgeRangeTableViewCell

static const int BL_AGE_RANGE_MIN_PICKER = 0;
static const int BL_AGE_RANGE_MAX_PICKER = 1;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.title.text = NSLocalizedString(@"Age range you like", nil);
        
        _minAge = 20;
        _maxAge = 25;
        
        _ageRange = [[NSMutableArray alloc] init];
        for (int i = 16; i < 101; i++) {
            [_ageRange addObject:[NSString stringWithFormat:@"%d",i]];
        }
        
        _arrowImageView = [[UIImageView alloc] init];
        _arrowImageView.image = [UIImage imageNamed:@"arrow_icon.png"];
        [self.content addSubview:_arrowImageView];
        
        _minAgePicker = [[BLPickerView alloc] init];
        _minAgePicker.tag = BL_AGE_RANGE_MIN_PICKER;
        _minAgePicker.delegate = self;
        _minAgePicker.dataSource = self;
        _minAgePicker.fisheyeFactor = 0.001;
        [_minAgePicker selectRow:0 animated:NO];
        [self.content addSubview:_minAgePicker];

        _maxAgePicker = [[BLPickerView alloc] init];
        _maxAgePicker.tag = BL_AGE_RANGE_MAX_PICKER;
        _maxAgePicker.delegate = self;
        _maxAgePicker.dataSource = self;
        _maxAgePicker.fisheyeFactor = 0.001;
        [_maxAgePicker selectRow:9 animated:NO];
        [self.content addSubview:_maxAgePicker];
        
        [self layout];
    }
    return self;
}

- (void)layout {
    [super layout];
    
    [_arrowImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(_arrowImageView.superview.mas_centerX);
        make.centerY.equalTo(_arrowImageView.superview.mas_centerY);
        make.width.equalTo(@60);
        make.height.equalTo(@10);
    }];
    
    [_minAgePicker mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(_minAgePicker.superview.mas_centerY);
        make.centerX.equalTo(_arrowImageView.mas_centerX).with.offset(-100.0f);
        make.width.equalTo(@50);
        make.height.equalTo(@200);
    }];

    [_maxAgePicker mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(_maxAgePicker.superview.mas_centerY);
        make.centerX.equalTo(_arrowImageView.mas_centerX).with.offset(100.0f);
        make.width.equalTo(@50);
        make.height.equalTo(@200);
    }];
}

#pragma mark - handle picker delegate and data source
- (NSInteger)numberOfRowsInPickerView:(BLPickerView *)pickerView {
    return _ageRange.count;
}

- (NSString *)pickerView:(BLPickerView *)pickerView titleForRow:(NSInteger)row {
    return [_ageRange objectAtIndex:row];
}

- (void)pickerView:(BLPickerView *)pickerView didSelectRow:(NSInteger)row {
    if (pickerView.tag == BL_AGE_RANGE_MIN_PICKER) {
        self.minAge = [[_ageRange objectAtIndex:row] integerValue];
    } else {
        self.maxAge = [[_ageRange objectAtIndex:row] integerValue];
    }
    NSDictionary *rangeDictionary = @{@"min_age" : [NSNumber numberWithInteger:self.minAge],
                                      @"max_age" : [NSNumber numberWithInteger:self.maxAge]};
    if ([self.delegate respondsToSelector:@selector(tableViewCell:didChangeValue:)]) {
        [self.delegate tableViewCell:self didChangeValue:rangeDictionary];
    }
}

#pragma mark
- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
