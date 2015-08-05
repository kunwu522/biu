//
//  BLContractViewController.h
//  biu
//
//  Created by Tony Wu on 7/27/15.
//  Copyright (c) 2015 BiuLove. All rights reserved.
//

#import <UIKit/UIKit.h>

@class BLContractViewController;

@protocol BLContractViewControllerDelegate <NSObject>

@required
- (void)didDismissBLContractViewController:(BLContractViewController *)vc;

@end

@interface BLContractViewController : UIViewController

@property (weak, nonatomic) id<BLContractViewControllerDelegate> delegate;

@end
