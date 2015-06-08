//
//  Profile.h
//  biu
//
//  Created by WuTony on 6/5/15.
//  Copyright (c) 2015 BiuLove. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Profile : NSObject

typedef NS_ENUM(NSInteger, BLGender) {
    BLGenderFemale = 0,
    BLGenderMale = 1,
    BLGenderNone = 2
};

typedef NS_ENUM(NSUInteger, BLZodiac) {
    BLZodiacAries = 0,
    BLZodiacTaurus = 1,
    BLZodiacGemini = 2,
    BLZodiacCancer = 3,
    BLZodiacLeo = 4,
    BLZodiacVirgo = 5,
    BLZodiacLibra = 6,
    BLZodiacScorpio = 7,
    BLZodiacSagittarius = 8,
    BLZodiacCapricorn = 9,
    BLZodiacAquarius = 10,
    BLZodiacPisces = 11
};

typedef NS_ENUM(NSUInteger, BLStyleType) {
    BLStyleTypeManRich = 0,
    BLStyleTypeManGFS = 1,
    BLStyleTypeManDS = 2,
    BLStyleTypeManTalent = 3,
    BLStyleTypeManSport = 4,
    BLStyleTypeManFashion = 5,
    BLStyleTypeManYoung = 6,
    BLStyleTypeManCommon = 7,
    BLStyleTypeManAll = 8,
    BLStyleTypeWomanGodness = 0,
    BLStyleTypeWomanBFM = 1,
    BLStyleTypeWomanDS = 2,
    BLStyleTypeWomanTalent = 3,
    BLStyleTypeWomanSport = 4,
    BLStyleTypeWomanSexy = 5,
    BLStyleTypeWomanLovely = 6,
    BLStyleTypeWomanSuccessFul = 7,
    BLStyleTypeWomanAll = 8,
};

@property (strong, nonatomic) NSNumber *profileId;
@property (strong, nonatomic) NSNumber *userId;
@property (strong, nonatomic) NSString *username;
@property (strong, nonatomic) NSDate *birthday;
@property (strong, nonatomic) NSNumber *age;
@property (assign, nonatomic) BLZodiac zodiac;
@property (assign, nonatomic) BLGender gender;
@property (assign, nonatomic) BLStyleType style;

- (void)save;

@end
