//
//  BLGenderTableViewCell.h
//  biu
//
//  Created by Tony Wu on 5/26/15.
//  Copyright (c) 2015 BiuLove. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BLBaseTableViewCell.h"

@interface BLGenderTableViewCell : BLBaseTableViewCell

typedef NS_ENUM(NSInteger, BLGender) {
    BLGenderFemale = 0,
    BLGenderMale = 1,
    BLGenderNone = 2
};

- (void)setGender:(BLGender)gender;
- (BLGender)getGender;

@end
