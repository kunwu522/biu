//
//  BLSettingViewController.h
//  biu
//
//  Created by Tony Wu on 6/2/15.
//  Copyright (c) 2015 BiuLove. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol BLMatchStopLocationDelegate <NSObject>
@required
- (void)didFinishLogout;

@end

@interface BLSettingViewController : UIViewController

@property (weak, nonatomic) id<BLMatchStopLocationDelegate> delegate;

@end













