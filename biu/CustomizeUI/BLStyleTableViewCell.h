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

@property (assign, nonatomic) BLGender gender;
@property (assign, nonatomic) BLStyleType style;

@property (assign, nonatomic) BOOL allowMultiSelected;
// working when isAllowMultiSelected == YES
@property (assign, nonatomic) BLSexualityType sexuality;
@property (assign, nonatomic) NSMutableDictionary *preferStyles;

@end
