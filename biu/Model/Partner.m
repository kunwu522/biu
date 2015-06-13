//
//  Partner.m
//  biu
//
//  Created by WuTony on 6/7/15.
//  Copyright (c) 2015 BiuLove. All rights reserved.
//

#import "Partner.h"

@implementation Partner

@synthesize partnerId, userId, sexualityType, minAge, maxAge, preferZodiacs, preferStyles;

- (id)initWithDictionary:(NSDictionary *)dictionary {
    self = [Partner new];
    if (self) {
        self.partnerId = [dictionary objectForKey:@"partner_id"];
        self.sexualityType = (BLSexualityType)[[dictionary objectForKey:@"sexuality"] integerValue];
        self.minAge = [dictionary objectForKey:@"min_age"];
        self.maxAge = [dictionary objectForKey:@"max_age"];
        self.preferStyles = [dictionary objectForKey:@"style_ids"];
        self.preferZodiacs = [dictionary objectForKey:@"zodiac_ids"];
    }
    return self;
}

- (void)save {
    NSUserDefaults *defaults = [[NSUserDefaults alloc] initWithSuiteName:@"%@_partner"];
    [defaults setObject:self.partnerId forKey:@"partner_id"];
    [defaults setObject:self.userId forKey:@"user_id"];
    [defaults setObject:[NSNumber numberWithInteger:self.sexualityType] forKey:@"sexuality"];
    [defaults setObject:self.minAge forKey:@"min_age"];
    [defaults setObject:self.maxAge forKey:@"max_age"];
    [defaults setObject:self.preferZodiacs forKey:@"prefer_zodiac"];
    [defaults setObject:self.preferStyles forKey:@"prefer_style"];
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

@end
