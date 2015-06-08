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
    BLSexualityTypeMan = 0,
    BLSexualityTypeWoman = 1,
    BLSexualityTypeP = 2,
    BLSexualityTypeT = 3,
    BLSexualityType1 = 4,
    BLSexualityType0 = 5,
};

@property (strong, nonatomic) NSNumber *partnerId;
@property (strong, nonatomic) NSNumber *userId;
@property (assign, nonatomic) BLSexualityType sexualityType;
@property (strong, nonatomic) NSArray *preferZodiacs;
@property (strong, nonatomic) NSNumber *minAge;
@property (strong, nonatomic) NSNumber *maxAge;
@property (strong, nonatomic) NSArray *preferStyles;

- (void)save;

@end
