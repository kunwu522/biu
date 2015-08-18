//
//  BLPartnerViewController.h
//  biu
//
//  Created by Tony Wu on 6/2/15.
//  Copyright (c) 2015 BiuLove. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BLPartnerViewController : UIViewController

typedef NS_ENUM(NSUInteger, BLPartnerViewControllerType) {
    BLPartnerViewControllerCreate,
    BLPartnerViewControllerUpdate,
};

@property (assign, nonatomic) BLPartnerViewControllerType partnerViewType;

// it works when partnerViewType is create
@property (strong, nonatomic) Profile *profile;

@property (nonatomic, strong) UIImageView *expandZoomImageView;

@end
