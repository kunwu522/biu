//
//  BLZodiacTableViewCell.h
//  biu
//
//  Created by WuTony on 6/2/15.
//  Copyright (c) 2015 BiuLove. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BLBaseTableViewCell.h"

@interface BLZodiacTableViewCell : BLBaseTableViewCell

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

@property (assign, nonatomic) BLZodiac zodiac;

@end
