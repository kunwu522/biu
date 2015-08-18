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
    BLGenderNone = 0,
    BLGenderMale = 1,
    BLGenderFemale = 2
};

typedef NS_ENUM(NSUInteger, BLZodiac) {
    BLZodiacNone = 0,
    BLZodiacAries = 1,//白羊
    BLZodiacTaurus = 2,//金牛
    BLZodiacGemini = 3,//双子
    BLZodiacCancer = 4,//巨蟹
    BLZodiacLeo = 5,//狮子
    BLZodiacVirgo = 6,//处女
    BLZodiacLibra = 7,//天秤
    BLZodiacScorpio = 8,//天蝎
    BLZodiacSagittarius = 9,//射手
    BLZodiacCapricorn = 10,//摩羯
    BLZodiacAquarius = 11,//水瓶
    BLZodiacPisces = 12,//双鱼
};

typedef NS_ENUM(NSUInteger, BLStyleType) {
    BLStyleTypeNone = 0,
    BLStyleTypeManRich = 1,
    BLStyleTypeManGFS = 2,
    BLStyleTypeManDS = 3,
    BLStyleTypeManTalent = 4,
    BLStyleTypeManSport = 5,
    BLStyleTypeManFashion = 6,
    BLStyleTypeManYoung = 7,
    BLStyleTypeManCommon = 8,
    BLStyleTypeManAll = 9,
    BLStyleTypeWomanGodness = 10,
    BLStyleTypeWomanBFM = 11,
    BLStyleTypeWomanDS = 12,
    BLStyleTypeWomanTalent = 13,
    BLStyleTypeWomanSport = 14,
    BLStyleTypeWomanSexy = 15,
    BLStyleTypeWomanLovely = 16,
    BLStyleTypeWomanSuccessFul = 17,
    BLStyleTypeWomanAll = 18
};

typedef NS_ENUM(NSUInteger, BLSexualityType) {
    BLSexualityTypeNone = 0,
    BLSexualityTypeMan = 1,
    BLSexualityTypeWoman = 2,
    BLSexualityTypeP = 3,
    BLSexualityTypeT = 4,
    BLSexualityType1 = 5,
    BLSexualityType0 = 6
};

@property (strong, nonatomic) NSNumber *profileId;
//@property (strong, nonatomic) NSNumber *userId;
@property (strong, nonatomic) NSString *username;
@property (strong, nonatomic) NSDate *birthday;
@property (strong, nonatomic) NSNumber *age;
@property (assign, nonatomic) BLZodiac zodiac;
@property (assign, nonatomic) BLGender gender;
@property (assign, nonatomic) BLStyleType style;
@property (assign, nonatomic) BLSexualityType sexuality;

- (id)initWithFromUserDefault;
- (id)initWithDictionary:(NSDictionary *)dictionary;
- (void)save;

+ (NSUInteger)getAgeFromBirthday:(NSDate *)birthday;
+ (BLZodiac)getZodiacFromBirthday:(NSDate *)birthday;
+ (NSString *)getZodiacNameFromZodiac:(BLZodiac)zodiac isShotVersion:(BOOL)isShot;

@end






