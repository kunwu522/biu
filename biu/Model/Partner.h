//
//  Partner.h
//  biu
//
//  Created by WuTony on 6/7/15.
//  Copyright (c) 2015 BiuLove. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Partner : NSObject

typedef NS_ENUM(NSUInteger, BLSexualityType) {
    BLSexualityTypeNone = 0,
    BLSexualityTypeMan = 1,
    BLSexualityTypeWoman = 2,
    BLSexualityTypeP = 3,
    BLSexualityTypeT = 4,
    BLSexualityType1 = 5,
    BLSexualityType0 = 6
};

@property (strong, nonatomic) NSNumber *partnerId;
@property (strong, nonatomic) NSNumber *userId;
@property (assign, nonatomic) BLSexualityType sexualityType;
@property (strong, nonatomic) NSArray *preferZodiacs;
@property (strong, nonatomic) NSNumber *minAge;
@property (strong, nonatomic) NSNumber *maxAge;
@property (strong, nonatomic) NSArray *preferStyles;

- (id)initWithDictionary:(NSDictionary *)dictionary;
- (void)save;

+ (NSString *)getStyleNameFromZodiac:(BLStyleType)style;

@end
