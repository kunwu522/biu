//
//  BLMenuButton.h
//  biu
//
//  Created by Tony Wu on 6/2/15.
//  Copyright (c) 2015 BiuLove. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BLMenuButton : UIButton

@property (strong, nonatomic) UIImage *icon;
@property (strong, nonatomic) UIImage *highlightIcon;
@property (strong, nonatomic) UIColor *blTitleColor;
@property (strong, nonatomic) UIColor *highlightColor;
@property (strong, nonatomic) NSString *blTitle;

@end
