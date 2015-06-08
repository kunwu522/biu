//
//  Profile.m
//  biu
//
//  Created by WuTony on 6/5/15.
//  Copyright (c) 2015 BiuLove. All rights reserved.
//

#import "Profile.h"

@implementation Profile

@synthesize profileId, userId, username, gender, birthday, zodiac, style;

- (void)save {
    NSUserDefaults *defaults = [[NSUserDefaults alloc] initWithSuiteName:[NSString stringWithFormat:@"%@_profile", self.userId]];
    [defaults setObject:self.profileId forKey:@"id"];
    [defaults setObject:self.userId forKey:@"user_id"];
    [defaults setObject:self.username forKey:@"username"];
    [defaults setObject:[NSNumber numberWithInteger:self.gender] forKey:@"gender"];
    [defaults setObject:self.birthday forKey:@"birthday"];
    [defaults setObject:[NSNumber numberWithInteger:self.zodiac] forKey:@"zodiac"];
    [defaults setObject:[NSNumber numberWithInteger:self.style] forKey:@"style"];
    [defaults synchronize];
}

@end
