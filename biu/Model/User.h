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

typedef NS_ENUM(NSInteger, BLMatchState) {
    BLMatchStateStop = 0,
    BLMatchStateMatching = 1,
    BLMatchStateMatched = 2,
    BLMatchStateAccepted = 3,
    BLMatchStateRejected = 4,
    BLMatchStateCommunication = 5
};

typedef NS_ENUM(NSInteger, BLMatchEvent) {
    BLMatchEventStop = 0,
    BLMatchEventStartMatching = 1,
    BLMatchEventAccept = 2,
    BLMatchEventReject = 3,
    BLMatchEventTimout = 4,
    BLMatchEventClose = 5
};

@property (strong, nonatomic) NSNumber *userId;
@property (strong, nonatomic) NSString *username;
@property (strong, nonatomic) NSString *email;
@property (strong, nonatomic) NSString *phone;
@property (strong, nonatomic) NSString *password;
@property (strong, nonatomic) Profile  *profile;
@property (strong, nonatomic) Partner  *partner;
@property (strong, nonatomic) NSNumber *latitude;
@property (strong, nonatomic) NSNumber *longitude;
@property (assign, nonatomic) BLMatchState state;
@property (strong, nonatomic) NSString *token;
@property (strong, nonatomic) NSString *avatar_url;//微信、微博头像
@property (strong, nonatomic) NSString *open_id;//微信、微博用户唯一标识

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
- (void)updateState:(BLMatchState)state;

@end
