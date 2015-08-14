//
//  BLMatchViewController.h
//  biu
//
//  Created by Tony Wu on 5/27/15.
//  Copyright (c) 2015 BiuLove. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BLSettingViewController.h"

@protocol BLMAtchStateDelegate <NSObject>

- (void)changeStateWithEvent:(BLMatchEvent)event;

@end

@interface BLMatchViewController : UIViewController<BLMatchStopLocationDelegate>

- (void)matched:(User *)matchedUser;

@end
