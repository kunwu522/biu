//
//  BLGenderTableViewCell.m
//  biu
//
//  Created by Tony Wu on 5/26/15.
//  Copyright (c) 2015 BiuLove. All rights reserved.
//

#import "BLGenderTableViewCell.h"

#import "Masonry.h"

@interface BLGenderTableViewCell ()

@property (nonatomic) BLGender gender;

@property (retain, nonatomic) UIView *maleView;
@property (retain, nonatomic) UIView *femaleView;
@property (retain, nonatomic) UIImageView *imageViewDivision;
@property (retain, nonatomic) UIImageView *imageViewMale;
@property (retain, nonatomic) UIImageView *imageViewFemale;
@property (retain, nonatomic) UIImage *imageMaleSelected;
@property (retain, nonatomic) UIImage *imageMaleUnselected;
@property (retain, nonatomic) UIImage *imageFemaleSelected;
@property (retain, nonatomic) UIImage *imageFemaleUnselected;

@property (retain, nonatomic) UIGestureRecognizer *tapMaleGestureRecognizer;
@property (retain, nonatomic) UIGestureRecognizer *tapFemaleGestureRecognizer;

@end

@implementation BLGenderTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        _gender = BLGenderNone;
        
        self.backgroundColor = [BLColorDefinition backgroundGrayColor];
        
        _imageMaleSelected = [UIImage imageNamed:@"male_selected_icon.png"];
        _imageMaleUnselected = [UIImage imageNamed:@"male_unselected_icon.png"];
        _imageFemaleSelected = [UIImage imageNamed:@"female_selected_icon.png"];
        _imageFemaleUnselected = [UIImage imageNamed:@"female_unselected_icon.png"];
        
        _imageViewDivision = [[UIImageView alloc] init];
        _imageViewDivision.image = [UIImage imageNamed:@"division_icon.png"];
        [self addSubview:_imageViewDivision];
        
        _maleView = [[UIView alloc] init];
        _maleView.backgroundColor = [UIColor clearColor];
        _imageViewMale = [[UIImageView alloc] initWithFrame:_maleView.frame];
        _imageViewMale.image = _imageMaleUnselected;
        [_maleView addSubview:_imageViewMale];
        [self addSubview:_maleView];
        
        _femaleView = [[UIView alloc] init];
        _femaleView.backgroundColor = [UIColor clearColor];
        _imageViewFemale = [[UIImageView alloc] initWithFrame:_femaleView.frame];
        _imageViewFemale.image = _imageFemaleUnselected;
        [_femaleView addSubview:_imageViewFemale];
        [self addSubview:_femaleView];
        
        _tapMaleGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapMaleHandler:)];
        _tapMaleGestureRecognizer.delegate = self;
        [_maleView addGestureRecognizer:_tapMaleGestureRecognizer];
        
        _tapFemaleGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapFemaleHandler:)];
        _tapFemaleGestureRecognizer.delegate = self;
        [_femaleView addGestureRecognizer:_tapFemaleGestureRecognizer];
        
        [self layout];
    }
    return self;
}

- (BLGender)getGender {
    return _gender;
}

- (void)setGender:(BLGender)gender {
    if (gender == BLGenderNone) {
        _imageViewMale.image = _imageMaleUnselected;
        _imageViewFemale.image = _imageFemaleUnselected;
        return;
    }
    
    if (_gender == BLGenderNone) {
        switch (gender) {
            case BLGenderMale:
                _imageViewMale.image = _imageMaleSelected;
                break;
            case BLGenderFemale:
                _imageViewFemale.image = _imageFemaleSelected;
                break;
            default:
                break;
        }
    }
    
    if (_gender != gender) {
        [self switchGender];
        _gender = gender;
    }
}

#pragma mark - private
- (void)layout {
    [_imageViewDivision mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.mas_centerX);
        make.centerY.equalTo(self.mas_centerY);
        make.width.equalTo(@12.5f);
        make.height.equalTo(@72.5f);
    }];
    
    [_maleView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.mas_centerY);
        make.right.equalTo(_imageViewDivision.mas_left).with.offset(-40.0f);
        make.width.equalTo(@94.4f);
        make.height.equalTo(@141.5f);
    }];
    
    [_femaleView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.mas_centerY);
        make.left.equalTo(_imageViewDivision.mas_right).with.offset(40.0f);
        make.width.equalTo(@94.4f);
        make.height.equalTo(@141.5f);
    }];
    
    [_imageViewMale mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(_imageViewMale.superview);
    }];
    
    [_imageViewFemale mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(_imageViewFemale.superview);
    }];
}

- (void)switchGender {
    switch (_gender) {
        case BLGenderMale:
            _imageViewMale.image = _imageMaleUnselected;
            _imageViewFemale.image = _imageFemaleSelected;
            break;
        case BLGenderFemale:
            _imageViewFemale.image = _imageFemaleUnselected;
            _imageViewMale.image = _imageMaleSelected;
        default:
            break;
    }
}

#pragma mark - Gesture Handler
- (void)tapMaleHandler:(UITapGestureRecognizer *)recognizer {
    [self setGender:BLGenderMale];
}

- (void)tapFemaleHandler:(UITapGestureRecognizer *)recognizer {
    [self setGender:BLGenderFemale];
}

@end
