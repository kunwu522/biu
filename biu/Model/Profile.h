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

typedef NS_ENUM(NSUInteger, BLStyleManType) {
    BLStyleManTypeRich = 0,
    BLStyleManTypeGFS = 1,
    BLStyleManTypeDS = 2,
    BLStyleManTypeTalent = 3,
    BLStyleManTypeSport = 4,
    BLStyleManTypeFashion = 5,
    BLStyleManTypeYoung = 6,
    BLStyleManTypeCommon = 7,
    BLStyleManTypeAll = 8,
};

typedef NS_ENUM(NSUInteger, BLStyleWomanType) {
    BLStyleWomanTypeGodness = 0,
    BLStyleWomanTypeBFM = 1,
    BLStyleWomanTypeDS = 2,
    BLStyleWomanTypeTalent = 3,
    BLStyleWomanTypeSport = 4,
    BLStyleWomanTypeSexy = 5,
    BLStyleWomanTypeLovely = 6,
    BLStyleWomanTypeSuccessFul = 7,
    BLStyleWomanTypeAll = 8,
};

@property (strong, nonatomic) NSDate *birthday;
@property (strong, nonatomic) NSNumber *age;
@property (assign, nonatomic) BLZodiac zodiac;
@property (assign, nonatomic) BLGender gender;
@property (assign, nonatomic) NSUInteger style;

@end
