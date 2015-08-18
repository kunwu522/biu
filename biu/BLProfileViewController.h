//
//  BLProfileViewController.h
//  biu
//
//  Created by Tony Wu on 5/25/15.
//  Copyright (c) 2015 BiuLove. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BLProfileViewController : UIViewController

typedef NS_ENUM(NSUInteger, BLProfileViewType) {
    BLProfileViewTypeCreate = 0,
    BLProfileViewTypeUpdate = 1,
};

@property (assign, nonatomic) BLProfileViewType profileViewType; //default is BLProfileViewTypeCreate
@property (nonatomic, strong) UIImageView *expandZoomImageView;

@end












