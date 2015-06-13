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

@property (assign, nonatomic) BLZodiac zodiac;

@property (assign, nonatomic) BOOL allowMultiSelected;
// working when isAllowMultiSelected == YES
@property (strong, nonatomic) NSMutableArray *preferZodiacs;

@end
