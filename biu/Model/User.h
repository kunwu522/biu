//
//  User.h
//  biu
//
//  Created by Tony Wu on 5/25/15.
//  Copyright (c) 2015 BiuLove. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Profile.h"
#import "Partner.h"

@interface User : NSObject

@property (strong, nonatomic) NSNumber *userId;
@property (strong, nonatomic) NSString *username;
@property (strong, nonatomic) NSString *email;
@property (strong, nonatomic) NSString *phone;
@property (strong, nonatomic) NSString *password;
@property (strong, nonatomic) Profile *profile;
@property (strong, nonatomic) Partner *partner;
@property (strong, nonatomic) NSNumber *latitude;
@property (strong, nonatomic) NSNumber *longitude;
//@property (strong, nonatomic) NSString *avatarCycleUrl;
//@property (strong, nonatomic) NSString *avatarRectangleUrl;

/*
 * return invalid reason otherwise return nil
 */
+ (NSString *)validateUsername:(NSString *)username;
/*
 * return invalid reason otherwise return nil
 */
+ (NSString *)validatePassword:(NSString *)password;
/*
 * return invalid reason otherwise return nil
 */
+ (NSString *)validatePhoneNumber:(NSString *)phoneNumber;

+ (BOOL)isEmailValid:(NSString*)email;

- (id)initWithFromUserDefault;
- (id)initWithDictionary:(NSDictionary *)dictionary;
- (void)removeFromUserDefault;
- (void)save;

@end
