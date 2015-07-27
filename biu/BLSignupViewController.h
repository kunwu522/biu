//
//  BLSignupViewController.h
//  biu
//
//  Created by Tony Wu on 7/23/15.
//  Copyright (c) 2015 BiuLove. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol BLSignupViewControllerDelegate <NSObject>

@required
- (void)viewController:(UIViewController *)controller didSignupWithNewUser:(User *)user;

@end

@interface BLSignupViewController : UIViewController

@property (weak, nonatomic) id<BLSignupViewControllerDelegate> delegate;

@end
