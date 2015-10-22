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
        for (int i = 18; i < 101; i++) {
            [_ageRange addObject:[NSString stringWithFormat:@"%d",i]];
        }
        
        _arrowImageView = [[UIImageView alloc] init];
        _arrowImageView.image = [UIImage imageNamed:@"arrow_icon.png"];
        [self.content addSubview:_arrowImageView];
        
        _minAgePicker = [[BLPickerView alloc] init];
        _minAgePicker.tag = BL_AGE_RANGE_MIN_PICKER;
        _minAgePicker.whichCreat = @"Partner";
        _minAgePicker.delegate = self;
        _minAgePicker.dataSource = self;
        _minAgePicker.fisheyeFactor = 0.001;
        [_minAgePicker selectRow:0 animated:NO];
        [self.content addSubview:_minAgePicker];

        _maxAgePicker = [[BLPickerView alloc] init];
        _maxAgePicker.tag = BL_AGE_RANGE_MAX_PICKER;
        _maxAgePicker.whichCreat = @"Partner";
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
        make.width.equalTo([NSNumber numberWithDouble:[BLGenernalDefinition resolutionForDevices:60.0f]]);
        make.height.equalTo([NSNumber numberWithDouble:[BLGenernalDefinition resolutionForDevices:10.0f]]);
    }];
    
    [_minAgePicker mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(_minAgePicker.superview.mas_centerY);
        make.centerX.equalTo(_arrowImageView.mas_centerX).with.offset([BLGenernalDefinition resolutionForDevices:-100.0f]);
        make.width.equalTo([NSNumber numberWithDouble:[BLGenernalDefinition resolutionForDevices:50.0f]]);
        make.height.equalTo([NSNumber numberWithDouble:[BLGenernalDefinition resolutionForDevices:200.0f]]);
    }];

    [_maxAgePicker mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(_maxAgePicker.superview.mas_centerY);
        make.centerX.equalTo(_arrowImageView.mas_centerX).with.offset([BLGenernalDefinition resolutionForDevices:100.0f]);
        make.width.equalTo([NSNumber numberWithDouble:[BLGenernalDefinition resolutionForDevices:50.0f]]);
        make.height.equalTo([NSNumber numberWithDouble:[BLGenernalDefinition resolutionForDevices:200.0f]]);
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
        _minAge = [[_ageRange objectAtIndex:row] integerValue];
    } else {
        _maxAge = [[_ageRange objectAtIndex:row] integerValue];
    }
    NSDictionary *rangeDictionary = @{@"min_age" : [NSNumber numberWithInteger:self.minAge],
                                      @"max_age" : [NSNumber numberWithInteger:self.maxAge]};
    if ([self.delegate respondsToSelector:@selector(tableViewCell:didChangeValue:)]) {
        [self.delegate tableViewCell:self didChangeValue:rangeDictionary];
    }
}

#pragma mark -
#pragma mark Setter
- (void)setMinAge:(NSUInteger)minAge {
    _minAge = minAge;
    [_minAgePicker selectRow:[self rowFromAge:minAge] animated:YES notifySelection:NO];
}

- (void)setMaxAge:(NSUInteger)maxAge {
    _maxAge = maxAge;
    [_maxAgePicker selectRow:[self rowFromAge:maxAge] animated:YES notifySelection:NO];
}

#pragma mark - Private Method
- (NSInteger)ageFormIndexRow:(NSInteger)row {
    return row + 18;
}

- (NSInteger)rowFromAge:(NSInteger)age {
    return age > 18 ? age - 18 : 0;
}

@end
