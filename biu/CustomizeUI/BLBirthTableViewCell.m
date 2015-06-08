//
//  BLBirthTableViewCell.m
//  biu
//
//  Created by WuTony on 6/1/15.
//  Copyright (c) 2015 BiuLove. All rights reserved.
//

#import "BLBirthTableViewCell.h"
#import "Masonry.h"

@interface BLBirthTableViewCell ()

@property (retain, nonatomic) UIDatePicker *datePicker;

@end

@implementation BLBirthTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.title.text = NSLocalizedString(@"Choose your Date of birth", nil);
        
        _datePicker = [[UIDatePicker alloc] init];
        [_datePicker addTarget:self action:@selector(dateChanged:) forControlEvents:UIControlEventValueChanged];
        _datePicker.datePickerMode = UIDatePickerModeDate;
        [self.content addSubview:_datePicker];
        
        [self layout];
    }
    return self;
}

- (void)layout {
    [super layout];
    
    [_datePicker mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(_datePicker.superview.mas_centerX);
        make.centerY.equalTo(_datePicker.superview.mas_centerY);
    }];
}

#pragma mark - handle changing date
- (void)dateChanged:(id)sender {
    UIDatePicker *picker = sender;
    self.birthday = picker.date;
    if ([self.delegate respondsToSelector:@selector(tableViewCell:didChangeValue:)]) {
        [self.delegate tableViewCell:self didChangeValue:self.birthday];
    }
}

#pragma mark -
- (void)setBirthday:(NSDate *)birthday {
    [_datePicker setDate:birthday];
}

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
