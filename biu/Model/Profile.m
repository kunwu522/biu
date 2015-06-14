//
//  Profile.m
//  biu
//
//  Created by WuTony on 6/5/15.
//  Copyright (c) 2015 BiuLove. All rights reserved.
//

#import "Profile.h"

@implementation Profile

@synthesize profileId, userId, username, gender, birthday, zodiac, style, avatarUrl;

- (id)initWithDictionary:(NSDictionary *)dictionary {
    self = [Profile new];
    if (self) {
        self.profileId = [dictionary objectForKey:@"profile_id"];
        self.gender = (BLGender)[[dictionary objectForKey:@"gender"] integerValue];
        self.birthday = [[Profile dateFormatter] dateFromString:[dictionary objectForKey:@"birthday"]];
        self.style = (BLStyleType)[[dictionary objectForKey:@"style"] integerValue];
        self.zodiac = (BLZodiac)[[dictionary objectForKey:@"zodiac"] integerValue];
        self.avatarUrl = [dictionary objectForKey:@"avatar_url"];
    }
    return self;
}

- (void)save {
    NSUserDefaults *defaults = [[NSUserDefaults alloc] initWithSuiteName:[NSString stringWithFormat:@"%@_profile", self.userId]];
    [defaults setObject:self.profileId forKey:@"id"];
    [defaults setObject:self.userId forKey:@"user_id"];
    [defaults setObject:self.username forKey:@"username"];
    [defaults setObject:[NSNumber numberWithInteger:self.gender] forKey:@"gender"];
    [defaults setObject:self.birthday forKey:@"birthday"];
    [defaults setObject:[NSNumber numberWithInteger:self.zodiac] forKey:@"zodiac"];
    [defaults setObject:[NSNumber numberWithInteger:self.style] forKey:@"style"];
    [defaults setObject:self.avatarUrl forKey:@"avatar_url"];
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
