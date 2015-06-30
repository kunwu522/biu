//
//  Profile.m
//  biu
//
//  Created by WuTony on 6/5/15.
//  Copyright (c) 2015 BiuLove. All rights reserved.
//

#import "Profile.h"

@implementation Profile

static NSString *PROFILE_ID = @"profile_id";
static NSString *GENDER = @"gender";
static NSString *BIRTHDAY = @"birthday";
static NSString *ZODIAC = @"zodiac";
static NSString *STYLE = @"style";
static NSString *SEXUALITY = @"sexuality";

@synthesize profileId, userId, username, gender, birthday, zodiac, style, avatarUrl;

- (id)initWithFromUserDefault {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    self = [Profile new];
    if (self) {
        self.profileId = [defaults objectForKey:PROFILE_ID];
        if (!self.profileId) {
            return nil;
        }
        self.gender = (BLGender)[[defaults objectForKey:GENDER] integerValue];
        self.birthday = [defaults objectForKey:BIRTHDAY];
        self.zodiac = (BLZodiac)[[defaults objectForKey:ZODIAC] integerValue];
        self.style = (BLStyleType)[[defaults objectForKey:STYLE] integerValue];
    }
    return self;
}

- (id)initWithDictionary:(NSDictionary *)dictionary {
    self = [Profile new];
    if (self) {
        self.profileId = [dictionary objectForKey:@"profile_id"];
        self.gender = (BLGender)[[dictionary objectForKey:@"gender"] integerValue];
        self.birthday = [[Profile dateFormatter] dateFromString:[dictionary objectForKey:@"birthday"]];
        self.style = (BLStyleType)[[dictionary objectForKey:@"style"] integerValue];
        self.zodiac = (BLZodiac)[[dictionary objectForKey:@"zodiac"] integerValue];
        self.avatarUrl = [dictionary objectForKey:@"avatar_url"];
        self.sexuality = (BLSexualityType)[[dictionary objectForKey:@"sexuality"] integerValue];
    }
    return self;
}

- (void)save {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:[NSNumber numberWithInteger:self.zodiac] forKey:@"zodiac"];
    [defaults setObject:[NSNumber numberWithInteger:self.style] forKey:@"style"];
    
    
    [defaults setObject:self.profileId forKey:PROFILE_ID];
    [defaults setObject:[NSNumber numberWithInteger:self.gender] forKey:GENDER];
    [defaults setObject:self.birthday forKey:BIRTHDAY];
    [defaults setObject:[NSNumber numberWithInteger:self.zodiac] forKey:ZODIAC];
    [defaults setObject:[NSNumber numberWithInteger:self.style] forKey:STYLE];
    [defaults setObject:[NSNumber numberWithInteger:self.sexuality] forKey:SEXUALITY];
    [defaults synchronize];
}

+ (NSDateFormatter *)dateFormatter {
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.dateFormat = @"yyyy-MM-dd";
    return dateFormatter;
}

+ (BLZodiac)getZodiacFromBirthday:(NSDate *)birthday {
    if (!birthday) {
        return BLZodiacAries;
    }
    
    NSCalendar *gregorianCal = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSDateComponents *dateComps = [gregorianCal components: (NSCalendarUnitDay | NSCalendarUnitMonth)
                                                  fromDate: birthday];
    // Then use it
    NSInteger month=[dateComps month];
    NSInteger days=[dateComps day];
    
    switch (month)
    {
        case 1:
            //compare the dates
            return days <= 19 ? BLZodiacCapricorn : BLZodiacAquarius;
            break;
        case 2:
            return days <= 18 ? BLZodiacAquarius : BLZodiacPisces;
            break;
        case 3:
            return days <= 20 ? BLZodiacPisces : BLZodiacAries;
            break;
        case 4:
            return days <= 19 ? BLZodiacAries : BLZodiacTaurus;
            break;
        case 5:
            return days <= 20 ? BLZodiacTaurus : BLZodiacGemini;
            break;
        case 6:
            return days <= 21 ? BLZodiacGemini : BLZodiacCancer;
            break;
        case 7:
            return days <= 22 ? BLZodiacCancer : BLZodiacLeo;
            break;
        case 8:
            return days <= 22 ? BLZodiacLeo : BLZodiacVirgo;
            break;
        case 9:
            return days <= 22 ? BLZodiacVirgo : BLZodiacLibra;
            break;
        case 10:
            return days <= 23 ? BLZodiacLibra : BLZodiacScorpio;
            break;
        case 11:
            return days <= 22 ? BLZodiacScorpio : BLZodiacSagittarius;
            break;
        case 12:
            return days <= 21 ? BLZodiacSagittarius : BLZodiacCapricorn;
            break;
        default:
            break;
    }
    return BLZodiacAries;
}

+ (NSUInteger)getAgeFromBirthday:(NSDate *)birthday {
    if (!birthday) {
        return 0;
    }
    
    NSDate* now = [NSDate date];
    NSDateComponents* ageComponents = [[NSCalendar currentCalendar]
                                       components:NSCalendarUnitYear
                                       fromDate:birthday
                                       toDate:now
                                       options:0];
    NSUInteger age = [ageComponents year];
    return age;
}

+ (NSString *)getZodiacNameFromZodiac:(BLZodiac)zodiac isShotVersion:(BOOL)isShot {
    NSDictionary *stringOfZodiac = nil;
    if (isShot) {
        stringOfZodiac = @{[NSNumber numberWithInteger:BLZodiacAries] : NSLocalizedString(@"Aries", nil),
                           [NSNumber numberWithInteger:BLZodiacTaurus] : NSLocalizedString(@"Taurus", nil),
                           [NSNumber numberWithInteger:BLZodiacGemini] : NSLocalizedString(@"Gemini", nil),
                           [NSNumber numberWithInteger:BLZodiacCancer] : NSLocalizedString(@"Cancer", nil),
                           [NSNumber numberWithInteger:BLZodiacLeo] : NSLocalizedString(@"Leo", nil),
                           [NSNumber numberWithInteger:BLZodiacVirgo] : NSLocalizedString(@"Virgo", nil),
                           [NSNumber numberWithInteger:BLZodiacLibra] : NSLocalizedString(@"Libra", nil),
                           [NSNumber numberWithInteger:BLZodiacScorpio] : NSLocalizedString(@"Scorpio", nil),
                           [NSNumber numberWithInteger:BLZodiacSagittarius] : NSLocalizedString(@"Sgr", nil),
                           [NSNumber numberWithInteger:BLZodiacCapricorn] : NSLocalizedString(@"Cap", nil),
                           [NSNumber numberWithInteger:BLZodiacAquarius] : NSLocalizedString(@"Agr", nil),
                           [NSNumber numberWithInteger:BLZodiacPisces] : NSLocalizedString(@"Pisces", nil)};
    } else {
        stringOfZodiac = @{[NSNumber numberWithInteger:BLZodiacAries] : NSLocalizedString(@"Aries", nil),
                          [NSNumber numberWithInteger:BLZodiacTaurus] : NSLocalizedString(@"Taurus", nil),
                          [NSNumber numberWithInteger:BLZodiacGemini] : NSLocalizedString(@"Gemini", nil),
                          [NSNumber numberWithInteger:BLZodiacCancer] : NSLocalizedString(@"Cancer", nil),
                          [NSNumber numberWithInteger:BLZodiacLeo] : NSLocalizedString(@"Leo", nil),
                          [NSNumber numberWithInteger:BLZodiacVirgo] : NSLocalizedString(@"Virgo", nil),
                          [NSNumber numberWithInteger:BLZodiacLibra] : NSLocalizedString(@"Libra", nil),
                          [NSNumber numberWithInteger:BLZodiacScorpio] : NSLocalizedString(@"Scorpio", nil),
                          [NSNumber numberWithInteger:BLZodiacSagittarius] : NSLocalizedString(@"Sagittarius", nil),
                          [NSNumber numberWithInteger:BLZodiacCapricorn] : NSLocalizedString(@"Capricorn", nil),
                          [NSNumber numberWithInteger:BLZodiacAquarius] : NSLocalizedString(@"Aquarius", nil),
                          [NSNumber numberWithInteger:BLZodiacPisces] : NSLocalizedString(@"Pisces", nil)};
    }
    
    return [stringOfZodiac objectForKey:[NSNumber numberWithInteger:zodiac]];
}

@end
