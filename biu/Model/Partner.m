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

@end
