//
//  BLLabel.h
//  biu
//
//  Created by Dezi on 15/9/14.
//  Copyright (c) 2015年 BiuLove. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, BLLabelControlEvents) {
    BLLabelControlEventTap,
    BLLabelControlEventLongPressBegan,
    BLLabelControlEventLongPressEnd,
};

@interface BLLabel : UILabel

- (void)addTarget:(id)target action:(SEL)action forControlEvents:(BLLabelControlEvents)controlEvents;


@end
