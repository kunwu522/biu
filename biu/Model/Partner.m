//
//  Partner.m
//  biu
//
//  Created by WuTony on 6/7/15.
//  Copyright (c) 2015 BiuLove. All rights reserved.
//

#import "Partner.h"

@implementation Partner

static NSString *PARTNER_ID = @"partner_id";
static NSString *SEXUALITIES = @"sexualities";
static NSString *MIN_AGE = @"min_age";
static NSString *MAX_AGE = @"max_age";
static NSString *PREFER_ZODIACS = @"prefer_zodiacs";
static NSString *PREFER_STYLES = @"prefer_styles";

@synthesize partnerId, sexualities, minAge, maxAge, preferZodiacs, preferStyles;

- (id)initWithFromUserDefault {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    self = [Partner new];
    if (self) {
        self.partnerId = [defaults objectForKey:PARTNER_ID];
        if (!self.partnerId) {
            return nil;
        }
        self.sexualities = [defaults objectForKey:SEXUALITIES];
        self.minAge = [defaults objectForKey:MIN_AGE];
        self.maxAge = [defaults objectForKey:MAX_AGE];
        self.preferZodiacs = [defaults objectForKey:PREFER_ZODIACS];
        self.preferStyles = [defaults objectForKey:PREFER_STYLES];
    }
    return self;
}

- (id)initWithDictionary:(NSDictionary *)dictionary {
    if (!dictionary || (id)dictionary == [NSNull null]) {
        return nil;
    }
    self = [Partner new];
    if (self) {
        self.partnerId = [dictionary objectForKey:@"partner_id"];
        self.sexualities = [dictionary objectForKey:@"sexuality_ids"];
        self.minAge = [dictionary objectForKey:@"min_age"];
        self.maxAge = [dictionary objectForKey:@"max_age"];
        self.preferStyles = [dictionary objectForKey:@"style_ids"];
        self.preferZodiacs = [dictionary objectForKey:@"zodiac_ids"];
    }
    return self;
}

- (void)save {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:self.partnerId forKey:PARTNER_ID];
    [defaults setObject:self.sexualities forKey:SEXUALITIES];
    [defaults setObject:self.minAge forKey:MIN_AGE];
    [defaults setObject:self.maxAge forKey:MAX_AGE];
    [defaults setObject:self.preferZodiacs forKey:PREFER_ZODIACS];
    [defaults setObject:self.preferStyles forKey:PREFER_STYLES];
    [defaults synchronize];
}

+ (NSString *)getStyleNameFromZodiac:(BLStyleType)style {
    NSDictionary *stringOfStyles = @{[NSNumber numberWithInteger:BLStyleTypeManRich] : NSLocalizedString(@"Rich", nil),
                                     [NSNumber numberWithInteger:BLStyleTypeManGFS] : NSLocalizedString(@"GFS", nil),
                                     [NSNumber numberWithInteger:BLStyleTypeManDS] : NSLocalizedString(@"DS Man", nil),
                                     [NSNumber numberWithInteger:BLStyleTypeManTalent] : NSLocalizedString(@"Talent", nil),
                                     [NSNumber numberWithInteger:BLStyleTypeManSport] : NSLocalizedString(@"Sport", nil),
                                     [NSNumber numberWithInteger:BLStyleTypeManFashion] : NSLocalizedString(@"Fashion", nil),
                                     [NSNumber numberWithInteger:BLStyleTypeManYoung] : NSLocalizedString(@"Young", nil),
                                     [NSNumber numberWithInteger:BLStyleTypeManCommon] : NSLocalizedString(@"Common", nil),
                                     [NSNumber numberWithInteger:BLStyleTypeManAll] : NSLocalizedString(@"All", nil),
                                     [NSNumber numberWithInteger:BLStyleTypeWomanGodness] : NSLocalizedString(@"Godness", nil),
                                     [NSNumber numberWithInteger:BLStyleTypeWomanBFM] : NSLocalizedString(@"BFM", nil),
                                     [NSNumber numberWithInteger:BLStyleTypeWomanDS] : NSLocalizedString(@"DS Woman", nil),
                                     [NSNumber numberWithInteger:BLStyleTypeWomanTalent] : NSLocalizedString(@"Talent", nil),
                                     [NSNumber numberWithInteger:BLStyleTypeWomanSport] : NSLocalizedString(@"Sport", nil),
                                     [NSNumber numberWithInteger:BLStyleTypeWomanSexy] : NSLocalizedString(@"Sexy", nil),
                                     [NSNumber numberWithInteger:BLStyleTypeWomanLovely] : NSLocalizedString(@"Lovely", nil),
                                     [NSNumber numberWithInteger:BLStyleTypeWomanSuccessFul] : NSLocalizedString(@"Business", nil),
                                     [NSNumber numberWithInteger:BLStyleTypeWomanAll] : NSLocalizedString(@"All", nil)};
    return [stringOfStyles objectForKey:[NSNumber numberWithInteger:style]];
}

+ (BLGender)genderBySexuality:(BLSexualityType)sexuality {
    BLGender gender = BLGenderNone;
    switch (sexuality) {
        case BLSexualityTypeMan:
        case BLSexualityType1:
        case BLSexualityType0:
            gender = BLGenderMale;
            break;
        case BLSexualityTypeWoman:
        case BLSexualityTypeT:
        case BLSexualityTypeP:
            gender = BLGenderFemale;
            break;
        default:
            break;
    }

    return gender;
}

+ (BLGender)genderByStyle:(BLStyleType)style {
    BLGender gender = BLGenderNone;
    switch (style) {
        case BLStyleTypeManAll:
        case BLStyleTypeManCommon:
        case BLStyleTypeManDS:
        case BLStyleTypeManFashion:
        case BLStyleTypeManGFS:
        case BLStyleTypeManRich:
        case BLStyleTypeManSport:
        case BLStyleTypeManTalent:
        case BLStyleTypeManYoung:
            gender = BLGenderMale;
            break;
        case BLStyleTypeWomanAll:
        case BLStyleTypeWomanBFM:
        case BLStyleTypeWomanDS:
        case BLStyleTypeWomanGodness:
        case BLStyleTypeWomanLovely:
        case BLStyleTypeWomanSexy:
        case BLStyleTypeWomanSport:
        case BLStyleTypeWomanSuccessFul:
        case BLStyleTypeWomanTalent:
            gender = BLGenderFemale;
            break;
        default:
            break;
    }
    return gender;
}

@end
