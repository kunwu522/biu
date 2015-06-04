//
//  BLStyleTableViewCell.h
//  biu
//
//  Created by Tony Wu on 6/2/15.
//  Copyright (c) 2015 BiuLove. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BLBaseTableViewCell.h"
#import "BLGenderTableViewCell.h"

@interface BLStyleTableViewCell : BLBaseTableViewCell

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

@property (assign, nonatomic) BLGender gender;

@end
