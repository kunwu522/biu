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
static NSString *STATE = @"state";
static NSString *DEVICE_TOKEN = @"device_token";
static NSString *AVATAR_CYCLE_URL = @"avatar_cycle_url";
static NSString *AVATAR_RECTANGLE_URL = @"avatar_rectangle_url";

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
        BLAppDelegate *delegate = (BLAppDelegate *)[[UIApplication sharedApplication] delegate];
        self.phone = [delegate.passwordItem objectForKey:(__bridge id)kSecAttrAccount];
        NSObject *pwd = [delegate.passwordItem objectForKey:(__bridge id)(kSecValueData)];
        if ([pwd isKindOfClass:[NSData class]]) {
            self.password = [[NSString alloc] initWithData:(NSData *)pwd encoding:NSUTF8StringEncoding];
        } else if ([pwd isKindOfClass:[NSString class]]) {
            self.password = (NSString *)pwd;
        }
        if ([self.phone isEqualToString:@""] || [self.password isEqualToString:@""]) {
            return nil;
        }
        
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        self.userId = [defaults objectForKey:USER_ID];
        self.username = [defaults objectForKey:USERNAME];
        self.state = [[defaults objectForKey:STATE] integerValue];
        self.token = [defaults objectForKey:DEVICE_TOKEN];
        if (!self.userId || !self.username) {
            return nil;
        }
        self.profile = [[Profile alloc] initWithFromUserDefault];
        self.partner = [[Partner alloc] initWithFromUserDefault];
    }
    return self;
}

- (id)initWithDictionary:(NSDictionary *)dictionary {
    if (!dictionary) {
        return nil;
    }
    
    self = [self init];
    if (self) {
        self.userId = [dictionary objectForKey:@"user_id"];
        self.username = [dictionary objectForKey:@"username"];
        self.phone = [dictionary objectForKey:@"phone"];
        if ([dictionary objectForKey:@"device_token"] != [NSNull null]) {
            self.token = [dictionary objectForKey:@"device_token"];
        }
        if (!self.userId || !self.username) {
            return nil;
        }
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
    
    BLAppDelegate *delegate = (BLAppDelegate *)[[UIApplication sharedApplication] delegate];
    
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
    [defaults setObject:self.userId forKey:USER_ID];
    [defaults setObject:self.username forKey:USERNAME];
    [defaults setObject:[NSNumber numberWithInteger:self.state] forKey:STATE];
    
    if (self.token) {
        [defaults setObject:self.token forKey:DEVICE_TOKEN];
    }
//    [defaults setObject:self.avatarCycleUrl forKey:AVATAR_CYCLE_URL];
//    [defaults setObject:self.avatarRectangleUrl forKey:AVATAR_RECTANGLE_URL];
    
    if (self.profile == nil) {
        [defaults synchronize];
        return;
    }
    [self.profile save];
    
    if (self.partner == nil) {
        [defaults synchronize];
        return;
    }
    [self.partner save];
    
    [defaults synchronize];
}

- (void)updateState:(BLMatchState)state {
    self.state = state;
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:[NSNumber numberWithInteger:self.state] forKey:STATE];
    [defaults synchronize];
}

@end
