//
//  BLLoginViewController.h
//  biu
//
//  Created by Tony Wu on 7/23/15.
//  Copyright (c) 2015 BiuLove. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol BLLoginViewControllerDelegate <NSObject>

@required
- (void)viewController:(UIViewController *)controller didLoginWithCurrentUser:(User *)user;

@end

@interface BLLoginViewController : UIViewController

@property (weak, nonatomic) id<BLLoginViewControllerDelegate> delegate;

@end
