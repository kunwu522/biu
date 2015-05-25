//
//  User.h
//  biu
//
//  Created by Tony Wu on 5/25/15.
//  Copyright (c) 2015 BiuLove. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface User : NSObject

@property (retain, nonatomic) NSNumber *id;
@property (retain, nonatomic) NSString *username;
@property (retain, nonatomic) NSString *email;
@property (retain, nonatomic) NSString *password;

/*
 * return invalid reason otherwise return nil
 */
+ (NSString *)validateUsername:(NSString *)username;
/*
 * return invalid reason otherwise return nil
 */
+ (NSString *)validatePassword:(NSString *)password;
+ (BOOL)isEmailValid:(NSString*)email;

@end
