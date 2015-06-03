//
//  BLSexualityTableViewCell.h
//  biu
//
//  Created by Tony Wu on 6/3/15.
//  Copyright (c) 2015 BiuLove. All rights reserved.
//

#import "BLBaseTableViewCell.h"

@interface BLSexualityTableViewCell : BLBaseTableViewCell

typedef NS_ENUM(NSUInteger, BLSexualityType) {
    BLSexualityTypeMan = 0,
    BLSexualityTypeWoman,
    BLSexualityTypeP,
    BLSexualityTypeT,
    BLSexualityType1,
    BLSexualityType0
};

@property (assign, nonatomic) BLSexualityType sexuality;

@end
