//
//  BLShowZodiacAndAge.m
//  biu
//
//  Created by Tony Wu on 6/8/15.
//  Copyright (c) 2015 BiuLove. All rights reserved.
//

#import "BLZodiacAndAgeTableViewCell.h"
#import "Masonry.h"

@interface BLZodiacAndAgeTableViewCell ()

@property (strong, nonatomic) UIView *zodiacView;
@property (strong, nonatomic) UIImageView *imageViewZodiac;
@property (strong, nonatomic) UILabel *lbZodiac;
@property (strong, nonatomic) UIView *age;
@property (strong, nonatomic) UIView *ageBackground;
@property (strong, nonatomic) UILabel *lbAgeNumber;
@property (strong, nonatomic) UILabel *lbAgeDesc;

@property (strong, nonatomic) NSDictionary *stringOfZodiac;

@end

@implementation BLZodiacAndAgeTableViewCell

static const float IMAGE_WIDTH = 80.0f;
static const float LINE_SPACING = 10.0f;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.title.text = NSLocalizedString(@"Your zodia and age", nil);
        
        _zodiacView = [[UIView alloc] init];
        _zodiacView.backgroundColor = [UIColor clearColor];
        [self.content addSubview:_zodiacView];
        
        _imageViewZodiac = [[UIImageView alloc] init];
        _imageViewZodiac.layer.cornerRadius = IMAGE_WIDTH / 2;
        _imageViewZodiac.clipsToBounds = YES;
        _imageViewZodiac.image = [UIImage imageNamed:@"zodiac_selected_icon0.png"];
        [_zodiacView addSubview:_imageViewZodiac];
        
        _lbZodiac = [[UILabel alloc]init];
        _lbZodiac.textAlignment = NSTextAlignmentCenter;
        _lbZodiac.textColor = [BLColorDefinition fontGrayColor];
        _lbZodiac.font = [BLFontDefinition lightFont:[BLGenernalDefinition resolutionForDevices:18.0f]];
        _lbZodiac.text = [Profile getZodiacNameFromZodiac:BLZodiacAries isShotVersion:NO];
        [_zodiacView addSubview:_lbZodiac];
        
        _age = [[UIView alloc] init];
        _age.backgroundColor = [UIColor clearColor];
        [self.content addSubview:_age];
        
        _ageBackground = [[UIView alloc] init];
        _ageBackground.backgroundColor = [UIColor whiteColor];
        _ageBackground.layer.cornerRadius = IMAGE_WIDTH / 2;
        _ageBackground.clipsToBounds = YES;
        [_age addSubview:_ageBackground];
        
        _lbAgeNumber = [[UILabel alloc] init];
        _lbAgeNumber.textAlignment = NSTextAlignmentCenter;
        _lbAgeNumber.textColor = [BLColorDefinition fontGreenColor];
        _lbAgeNumber.font = [BLFontDefinition normalFont:45.0f];
        _lbAgeNumber.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        _lbAgeNumber.text = @"20";
        [_ageBackground addSubview:_lbAgeNumber];
        
        _lbAgeDesc = [[UILabel alloc] init];
        _lbAgeDesc.textAlignment = NSTextAlignmentCenter;
        _lbAgeDesc.textColor = [BLColorDefinition fontGrayColor];
        _lbAgeDesc.font = [BLFontDefinition lightFont:[BLGenernalDefinition resolutionForDevices:18.0f]];
        _lbAgeDesc.text = NSLocalizedString(@"Age", nil);
        [_age addSubview:_lbAgeDesc];
        
        [_zodiacView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(_zodiacView.superview);
            make.centerX.equalTo(_zodiacView.superview).with.offset(-70);
            make.width.equalTo([NSNumber numberWithFloat:IMAGE_WIDTH]);
            make.height.equalTo([NSNumber numberWithFloat:(IMAGE_WIDTH + _lbZodiac.font.lineHeight + LINE_SPACING)]);
        }];
        [_imageViewZodiac mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(_imageViewZodiac.superview);
            make.left.equalTo(_imageViewZodiac.superview);
            make.right.equalTo(_imageViewZodiac.superview);
            make.height.equalTo([NSNumber numberWithFloat:IMAGE_WIDTH]);
        }];
        [_lbZodiac mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(_imageViewZodiac.mas_bottom).with.offset(LINE_SPACING);
            make.left.equalTo(_lbZodiac.superview);
            make.bottom.equalTo(_lbZodiac.superview);
            make.right.equalTo(_lbZodiac.superview);
        }];
        
        [_age mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(_age.superview);
            make.centerX.equalTo(_age.superview).with.offset(70);
            make.width.equalTo([NSNumber numberWithFloat:IMAGE_WIDTH]);
            make.height.equalTo([NSNumber numberWithFloat:(IMAGE_WIDTH + _lbAgeDesc.font.lineHeight + LINE_SPACING)]);
        }];
        [_ageBackground mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(_ageBackground.superview);
            make.left.equalTo(_ageBackground.superview);
            make.right.equalTo(_ageBackground.superview);
            make.height.equalTo([NSNumber numberWithFloat:IMAGE_WIDTH]);
        }];
        [_lbAgeDesc mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(_ageBackground.mas_bottom).with.offset(LINE_SPACING);
            make.left.equalTo(_lbAgeDesc.superview);
            make.bottom.equalTo(_lbAgeDesc.superview);
            make.right.equalTo(_lbAgeDesc.superview);
        }];
    }
    return self;
}

- (void)setBirthday:(NSDate *)birthday {
    if (!birthday) {
        return;
    }
    _zodiac = [Profile getZodiacFromBirthday:birthday];
    NSUInteger age = [Profile getAgeFromBirthday:birthday];
    
    _imageViewZodiac.image = [UIImage imageNamed:[NSString stringWithFormat:@"zodiac_selected_icon%@.png", [NSNumber numberWithInteger:_zodiac]]];
    _lbZodiac.text = [Profile getZodiacNameFromZodiac:_zodiac isShotVersion:YES];
    
    _lbAgeNumber.text = [NSString stringWithFormat:@"%lu", (unsigned long)age];
    
    if ([self.delegate respondsToSelector:@selector(tableViewCell:didChangeValue:)]) {
        [self.delegate tableViewCell:self didChangeValue:[NSNumber numberWithInteger:_zodiac]];
    }
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
