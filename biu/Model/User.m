//
//  User.m
//  biu
//
//  Created by Tony Wu on 5/25/15.
//  Copyright (c) 2015 BiuLove. All rights reserved.
//

#import "User.h"

@implementation User

static NSString *USER_ID = @"user_id";
static NSString *USERNAME = @"username";
static NSString *PROFILE_ID = @"profile_id";
static NSString *GENDER = @"gender";
static NSString *BIRTHDAY = @"birthday";
static NSString *ZODIAC = @"zodiac";
static NSString *STYLE = @"style";
static NSString *PARTNER_ID = @"partner_id";
static NSString *SEXUALITY = @"sexuality";
static NSString *MIN_AGE = @"min_age";
static NSString *MAX_AGE = @"max_age";
static NSString *PREFER_ZODIACS = @"prefer_zodiacs";
static NSString *PREFER_STYLES = @"prefer_styles";

@synthesize userId, username, password, email;

+ (NSString *)validateUsername:(NSString *)username
{
    if (!username) {
        return @"Username can not be empty.";
    }
    
    NSString *regex = @"[A-Za-z0-9]{1,16}";
    NSPredicate *usernameTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    if ([usernameTest evaluateWithObject:username]) {
        return nil;
    } else {
        return @"Username should have 6-16 characters, and only numbers and letters are allowed.";
    }
}

+ (NSString *)validatePassword:(NSString *)password
{
    if (!password) {
        return @"Password can not be empty.";
    }
    NSString *pwRegStr = @"((?=.*\\d)(?=.*[A-Z])(?=.*[a-z]).{6,16})";
    NSPredicate *pwTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", pwRegStr];
    if ([pwTest evaluateWithObject:password]) {
        return nil;
    } else {
        return @"Password should have 6-16 characters, including at least 1 uppercase and 1 lowercase and 1 digit.";
    }
}

+ (NSString *)validatePhoneNumber:(NSString *)phoneNumber {
    if (!phoneNumber) {
        return @"phoneNumber can not be empty.";
    }
    
    NSString *phoneRegStr = @"[0-9]{11}";
    NSPredicate *phoneTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", phoneRegStr];
    if ([phoneTest evaluateWithObject:phoneNumber]) {
        return nil;
    } else {
        return @"Phone number is not validated";
    }
}

+ (BOOL)isEmailValid:(NSString*)email
{
    NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailTest evaluateWithObject:email];
}

- (id)initWithFromUserDefault {
    self = [User new];
    if (self) {
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        self.userId = [defaults objectForKey:USER_ID];
        self.username = [defaults objectForKey:USERNAME];
        if (!self.userId || !self.username) {
            return nil;
        }
        NSNumber *profileId = [defaults objectForKey:PROFILE_ID];
        if (profileId) {
            self.profile = [Profile new];
            self.profile.profileId = profileId;
            self.profile.gender = (BLGender)[[defaults objectForKey:GENDER] integerValue];
            self.profile.birthday = [defaults objectForKey:BIRTHDAY];
            self.profile.zodiac = (BLZodiac)[[defaults objectForKey:ZODIAC] integerValue];
            self.profile.style = (BLStyleType)[[defaults objectForKey:STYLE] integerValue];
        } else {
            self.profile = nil;
        }
        
        NSNumber *partnerId = [defaults objectForKey:PARTNER_ID];
        if (partnerId) {
            self.partner = [Partner new];
            self.partner.partnerId = [defaults objectForKey:PARTNER_ID];
            self.partner.sexualityType = (BLSexualityType)[[defaults objectForKey:SEXUALITY] integerValue];
            self.partner.minAge = [defaults objectForKey:MIN_AGE];
            self.partner.maxAge = [defaults objectForKey:MAX_AGE];
            self.partner.preferZodiacs = [defaults objectForKey:PREFER_ZODIACS];
            self.partner.preferStyles = [defaults objectForKey:PREFER_STYLES];
        } else {
            self.partner = nil;
        }
    }
    return self;
}

- (id)initWithDictionary:(NSDictionary *)dictionary {
    self = [self init];
    if (self) {
        self.userId = [dictionary objectForKey:@"user_id"];
        self.username = [dictionary objectForKey:@"username"];
        self.profile = [[Profile alloc] initWithDictionary:[dictionary objectForKey:@"profile"]];
        self.partner = [[Partner alloc] initWithDictionary:[dictionary objectForKey:@"partner"]];
    }
    return self;
}

- (void)removeFromUserDefault {
    [NSUserDefaults resetStandardUserDefaults];
}

- (void)save {
    if ([self.phone isEqualToString:@""] || [self.password isEqualToString:@""]) {
        return;
    }
    
    BLAppDeleate *delegate = [[UIApplication sharedApplication] delegate];
    if (![self.phone isEqualToString:[delegate.passwordItem objectForKey:(__bridge id)kSecAttrAccount]]) {
        [delegate.passwordItem setObject:self.phone forKey:(__bridge id)kSecAttrAccount];
    }
    if (![self.password isEqualToString:[delegate.passwordItem objectForKey:(__bridge id)kSecValueData]]) {
        [delegate.passwordItem setObject:self.password forKey:(__bridge id)kSecValueData];
    }
    
    if (self.userId == nil) {
        NSLog(@"User id is nil...");
        return;
    }
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    if (![defaults objectForKey:USER_ID]) {
        [defaults setObject:self.userId forKey:USER_ID];
    }
    
    if (![self.username isEqualToString:[defaults objectForKey:USERNAME]]) {
        [defaults setObject:self.username forKey:USERNAME];
    }
    
    if (self.profile == nil) {
        [defaults synchronize];
        return;
    }
    [defaults setObject:self.profile.profileId forKey:PROFILE_ID];
    [defaults setObject:[NSNumber numberWithInteger:self.profile.gender] forKey:GENDER];
    [defaults setObject:self.profile.birthday forKey:BIRTHDAY];
    [defaults setObject:[NSNumber numberWithInteger:self.profile.zodiac] forKey:ZODIAC];
    [defaults setObject:[NSNumber numberWithInteger:self.profile.style] forKey:STYLE];
    
    if (self.partner == nil) {
        [defaults synchronize];
        return;
    }
    
    [defaults setObject:self.partner.partnerId forKey:PARTNER_ID];
    [defaults setObject:[NSNumber numberWithInteger:self.partner.sexualityType] forKey:SEXUALITY];
    [defaults setObject:self.partner.minAge forKey:MIN_AGE];
    [defaults setObject:self.partner.maxAge forKey:MAX_AGE];
    [defaults setObject:self.partner.preferZodiacs forKey:PREFER_ZODIACS];
    [defaults setObject:self.partner.preferStyles forKey:PREFER_STYLES];
    
    [defaults synchronize];
}

@end
