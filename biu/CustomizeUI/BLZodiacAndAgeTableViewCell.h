//
//  BLShowZodiacAndAge.h
//  biu
//
//  Created by Tony Wu on 6/8/15.
//  Copyright (c) 2015 BiuLove. All rights reserved.
//

#import "BLBaseTableViewCell.h"

@interface BLZodiacAndAgeTableViewCell : BLBaseTableViewCell

@property (strong, nonatomic) NSDate *birthday;

@property (assign, nonatomic, readonly) BLZodiac zodiac;

@end
