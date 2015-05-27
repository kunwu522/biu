//
//  User.m
//  biu
//
//  Created by Tony Wu on 5/25/15.
//  Copyright (c) 2015 BiuLove. All rights reserved.
//

#import "User.h"

@implementation User

@synthesize id, username, password, email;

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

+ (BOOL)isEmailValid:(NSString*)email
{
    NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailTest evaluateWithObject:email];
}

@end
