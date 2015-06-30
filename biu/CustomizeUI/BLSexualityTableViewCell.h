//
//  BLSexualityTableViewCell.h
//  biu
//
//  Created by Tony Wu on 6/3/15.
//  Copyright (c) 2015 BiuLove. All rights reserved.
//

#import "BLBaseTableViewCell.h"

@interface BLSexualityTableViewCell : BLBaseTableViewCell

@property (assign, nonatomic) BLSexualityType sexuality;
@property (assign, nonatomic) BLGender gender;

// working when isAllowMultiSelected == YES
@property (strong, nonatomic) NSMutableArray *sexualities;

@end
